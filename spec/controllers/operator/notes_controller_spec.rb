require 'rails_helper'

describe Operator::NotesController do

  let(:user) { create(:user, :operator) }

  let(:view_context) { controller.view_context }
  let(:ticket) { create(:ticket, :confirmed, created_by: user) }

  describe 'GET #edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      render_views

      before { sign_in(user) && get(:edit, params: { id: ticket }) }

      it { is_expected.to render_template(:edit) }

      context 'helpers' do
        it 'ticket' do
          expect(view_context.ticket).to eq(ticket)
        end
      end
    end
  end

  describe 'PATCH #update' do

    let(:valid_ticket) { ticket }

    let(:permitted_params) do
      [ :note ]
    end

    let(:note) { "Operator note" }

    let(:valid_params) do
      {
        id: ticket,
        ticket: {
          note: note
        }
      }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).
          for(:update, params: valid_params ).on(:ticket)
      end

      context 'valid' do
        it 'saves' do
          patch(:update, params: valid_params)

          expect(response).to redirect_to(operator_ticket_path(ticket))

          valid_ticket.reload

          expected_flash = I18n.t("operator.notes.update.done", title: valid_ticket.title)

          expect(valid_ticket.reload.note).to eq(note)
          expect(controller).to set_flash.to(expected_flash)
        end
      end

      context 'redirect path when comes from' do
        let(:ticket_call_center) { create(:ticket, :replied, :call_center) }

        context 'call_center_ticket' do
          let(:referrer_path) { operator_call_center_ticket_path(id: ticket_call_center)}

          before do
            allow_any_instance_of(ActionController::TestRequest).to receive(:referrer) do
              "#{referrer_path}&from=call_center_ticket"
            end
            valid_params[:id] = ticket_call_center
            patch(:update, params: valid_params)
          end

          it { expect(response).to redirect_to(referrer_path) }
        end

        context 'ticket' do
          let(:referrer_path) { operator_ticket_path(ticket)}

          before do
            allow_any_instance_of(ActionController::TestRequest).to receive(:referrer) do
              referrer_path
            end

            patch(:update, params: valid_params)
          end

          it { expect(response).to redirect_to(referrer_path) }
        end
      end

      context 'helpers' do
        it 'ticket' do
          patch(:update, params: valid_params)
          expect(view_context.ticket).to eq(valid_ticket)
        end
      end
    end
  end

end
