require 'rails_helper'

describe TicketArea::TicketsController do

  let(:ticket) { create(:ticket) }
  let(:confirmed_ticket) { create(:ticket, :confirmed) }
  let(:unconfirmed_ticket) { create(:ticket, :in_progress) }

  let(:permitted_params) do
    [
      :name,
      :email,
      :description,
      :sou_type,
      :organ_id,
      :unknown_organ,
      :department_id,
      :unknown_department,
      :status,
      :used_input,

      :answer_type,
      :answer_phone,
      :answer_cell_phone,

      :city_id,
      :answer_address_street,
      :answer_address_number,
      :answer_address_zipcode,
      :answer_address_complement,
      :answer_twitter,
      :answer_facebook,
      :answer_instagram,

      :document_type,
      :document,
      :person_type,

      :anonymous,

      :target_address_zipcode,
      :target_city_id,
      :target_address_street,
      :target_address_number,
      :target_address_neighborhood,
      :target_address_complement,

      attachments_attributes: [
        :id, :document, :_destroy
      ]
    ]
  end

  describe '#show' do
    context 'unauthenticated' do
      before { get(:show, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_ticket_session_path) }
    end

    context 'authenticated' do
      before { sign_in(ticket) }

      context 'unauthorized when logged with another ticket' do
        let(:another_ticket) { create(:ticket) }

        before { get(:show, params: { id: another_ticket }) }

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'not found' do
        before do
          get(:show, params: { id: 'not_found' })
        end

        it { is_expected.to respond_with(:not_found) }
      end

      context 'authorized' do
        context 'template' do
          render_views

          context 'confirmed' do
            before { sign_in(confirmed_ticket) && get(:show, params: { id: confirmed_ticket }) }

            it { is_expected.to render_template('ticket_area/tickets/show') }
            it { is_expected.to render_template('shared/tickets/_confirmed') }
            it { is_expected.not_to render_template('shared/tickets/_unconfirmed') }
            it { is_expected.to render_template('shared/tickets/_show') }
          end

          context 'print' do
            before { sign_in(confirmed_ticket) && get(:show, params: { id: confirmed_ticket, print: true }) }

            it { is_expected.to render_template('shared/tickets/print') }
          end
        end

        context 'generate password' do

          before do
            sign_in(confirmed_ticket)
            get(:show, params: { id: confirmed_ticket })
          end

          it { expect(controller.ticket.password).not_to be_empty }
        end

        context 'helpers' do

          let(:ticket_child){ create(:ticket, :with_parent, parent: ticket) }

          it 'ticket' do
            get(:show, params: { id: ticket })

            expect(controller.ticket).to eq(ticket)
          end

          it 'new_comment' do
            # criamos um novo comentário pra ser usado no form.

            get(:show, params: { id: ticket })

            expect(controller.new_comment).to be_present
            expect(controller.new_comment.commentable).to eq(ticket)
          end

          context 'ticket_children' do

            it 'with parent' do
              get(:show, params: { id: ticket })

              expect(controller.ticket_children).to eq(ticket.sorted_tickets)
            end

            it 'with child' do
              get(:show, params: { id: ticket_child })

              expect(controller.ticket_children).to eq(ticket.sorted_tickets)
            end
          end

          context 'readonly?' do
            it { expect(controller.readonly?).to be_falsey }
          end
        end
      end
    end
  end

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_ticket_session_path) }
    end

    context 'authorized' do
      before { sign_in(ticket) && get(:edit, params: { id: ticket }) }

      describe 'forbidden' do
        render_views

        it { is_expected.to respond_with(:forbidden) }
      end
    end
  end

  describe '#update' do
    let(:valid_ticket) { ticket }
    let(:valid_ticket_attributes) { valid_ticket.attributes }
    let(:valid_ticket_params) { { id: ticket, ticket: valid_ticket_attributes } }

    context 'unauthorized' do
      before { patch(:update, params: valid_ticket_params) }

      it { is_expected.to redirect_to(new_ticket_session_path) }
    end

    context 'authorized' do
      before { sign_in(ticket) }

      context 'valid' do
        it 'forbidden' do
          valid_ticket_params[:ticket][:name] = 'new name'
          patch(:update, params: valid_ticket_params)

          is_expected.to respond_with(:forbidden)
        end
      end
    end
  end

  describe '#history' do
    context 'unauthorized' do
      before { get(:history, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_ticket_session_path) }
    end

    context 'authorized' do
      render_views
      before { sign_in(ticket) && get(:history, params: { id: ticket }) }

      it { is_expected.to render_template('shared/tickets/ticket_logs/_history') }

      it { expect(controller.ticket).to eq(ticket) }
    end

  end
end
