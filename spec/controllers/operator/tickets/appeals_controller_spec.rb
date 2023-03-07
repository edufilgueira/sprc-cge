require 'rails_helper'

describe Operator::Tickets::AppealsController do
  let(:user) { create(:user, :operator_call_center) }
  let(:ticket) { create(:ticket, :sic, :replied, :feedback, call_center_responsible: user) }
  let(:ticket_sou) { create(:ticket, :replied) }
  let(:ticket_child) { create(:ticket, :sic, :replied, :with_parent, parent: ticket) }

  let(:permitted_params) do
    [
      :description
    ]
  end

  describe 'new' do

    context 'unauthorized' do
      before { get(:new, params: { ticket_id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      render_views

      context 'sou' do
        before { get(:new, params: { ticket_id: ticket_sou }) }

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'sic' do

        context 'ticket child' do
          before { get(:new, params: { ticket_id: ticket_child }) }

          it { is_expected.to respond_with(:forbidden) }
        end

        context 'ticket parent' do
          before { get(:new, params: { ticket_id: ticket }) }

          context 'template' do
            render_views

            it { is_expected.to respond_with(:success) }
            it { is_expected.to render_template(:new) }
          end

          context 'helper methods' do
            it 'ticket_log' do
              expect(controller.ticket_log).to be_new_record
            end

            it 'ticket' do
              expect(controller.ticket).to eq(ticket)
            end
          end
        end
      end
    end

  end

  describe '#create' do

    let(:justification) { 'Faltou informações' }

    let(:valid_params) do
      {
        ticket_id: ticket,
        ticket_log: {
          description: justification
        }
      }
    end
    let(:invalid_params) do
      {
        ticket_id: ticket,
        ticket_log: {
          description: ''
        }
      }
    end
    let(:sou_valid_params) do
      {
        ticket_id: ticket_sou,
        ticket_log: {
          description: justification
        }
      }
    end

    let(:child_valid_params) do
      {
        ticket_id: ticket_child,
        ticket_log: {
          description: justification
        }
      }
    end

    context 'unauthorized' do
      before { get(:new, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      render_views

      context 'invalid' do
        it 'not saves' do
          expect do
            post(:create, params: invalid_params)

            expect(controller).to set_flash.now.to(I18n.t('operator.tickets.appeals.create.error'))
            is_expected.to render_template(:new)
          end.to change(TicketLog, :count).by(0)
        end
      end

      context 'valid' do
        context 'sou' do
          it 'not saves' do
            expect do
              post(:create, params: sou_valid_params)

              is_expected.to respond_with(:forbidden)
            end.to change(TicketLog, :count).by(0)
          end
        end

        context 'sic' do

          context 'ticket child' do
            it 'not saves' do
              expect do
                post(:create, params: child_valid_params)

                is_expected.to respond_with(:forbidden)
              end.to change(TicketLog, :count).by(0)
            end
          end

          context 'ticket parent' do

            let!(:current_datetime) { DateTime.now }
            let(:next_weekday) { Holiday.next_weekday(5) }

            before { allow(DateTime).to receive(:now){ current_datetime } }

            it 'saves' do
              expect do
                post(:create, params: valid_params)

                ticket.reload

                is_expected.to redirect_to(operator_ticket_path(ticket))
                expect(controller).to set_flash.to(I18n.t('operator.tickets.appeals.create.done'))

                expect(ticket.appeals).to eq(1)
                expect(ticket.appeals_at.utc.to_i).to eq(current_datetime.utc.to_i)
                expect(ticket.deadline).to eq(next_weekday)
                expect(ticket.deadline_ends_at).to eq(Date.today + next_weekday.days)
                expect(ticket.appeal?).to be_truthy
                expect(ticket.confirmed?).to be_truthy

                expect(ticket.call_center_feedback_at).to be_nil

              end.to change(TicketLog, :count).by(1)
            end

            it 'create ticket log' do
              post(:create, params: valid_params)

              ticket_log = TicketLog.last

              expect(ticket_log.ticket).to eq(ticket)
              expect(ticket_log.responsible).to eq(user)
              expect(ticket_log.action).to eq('appeal')
              expect(ticket_log.description).to eq(justification)
            end

            it 'notify' do
              service = double

              allow(Notifier::Appeal).to receive(:delay) { service }
              allow(service).to receive(:call)

              post(:create, params: valid_params)

              expect(service).to have_received(:call).with(ticket.id)
            end

            context 'clear call_center_responsible' do
              let(:ticket) { create(:ticket, :sic, :replied, :with_call_center_responsible, created_by: user) }

              before { post(:create, params: valid_params) }

              it { expect(ticket.reload.call_center_responsible_id).to eq(nil) }
            end
          end

          it 'allowed params' do
            should permit(*permitted_params).
            for(:create, params: valid_params ).on(:ticket_log)
          end
        end
      end
    end
  end

end
