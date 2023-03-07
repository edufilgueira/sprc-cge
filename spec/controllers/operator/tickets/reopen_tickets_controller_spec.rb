require 'rails_helper'

describe Operator::Tickets::ReopenTicketsController do

  let(:user) { create(:user, :operator_call_center) }
  let(:ticket) { create(:ticket, :replied, :feedback, call_center_responsible: user, extended: true, extended_second_time: true) }
  let(:ticket_sic) { create(:ticket, :with_parent, :replied, :sic, parent: ticket, call_center_responsible: user) }
  let(:ticket_child) { create(:ticket, :with_parent, :replied, parent: ticket, call_center_responsible: user) }

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

      context 'sic' do
        before { get(:new, params: { ticket_id: ticket_sic }) }

        context 'template' do
          render_views

          it { is_expected.to respond_with(:success) }
          it { is_expected.to render_template(:new) }
        end
      end

      context 'sou' do

        context 'ticket child' do
          before { get(:new, params: { ticket_id: ticket_child }) }

          context 'template' do
            render_views

            it { is_expected.to respond_with(:success) }
            it { is_expected.to render_template(:new) }
          end

          context 'helper methods' do
            context 'ticket' do
              it { expect(controller.ticket).to eq(ticket_child) }
            end

            context 'organ' do
              it { expect(controller.organ).to eq(ticket_child.organ) }
            end
          end
        end

        context 'ticket parent' do
          let(:organ) { create(:executive_organ, acronym: 'CGE') }

          before { get(:new, params: { ticket_id: ticket }) }

          context 'template' do
            render_views

            it { is_expected.to respond_with(:success) }
            it { is_expected.to render_template(:new) }
          end

          context 'helper methods' do
            context 'ticket_log' do
              it { expect(controller.ticket_log).to be_new_record }
            end

            context 'ticket' do
              it { expect(controller.ticket).to eq(ticket) }
            end

            context 'organ' do
              before { organ }

              it { expect(controller.organ).to eq(organ) }
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
    let(:sic_valid_params) do
      {
        ticket_id: ticket_sic,
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

            expect(controller).to set_flash.now.to(I18n.t('operator.tickets.reopen_tickets.create.sou.error'))
            is_expected.to render_template(:new)
          end.to change(TicketLog, :count).by(0)
        end
      end

      context 'valid' do
        let!(:current_datetime) { DateTime.now }

        before { allow(DateTime).to receive(:now){ current_datetime } }

        context 'sic' do
          it 'saves' do
            expect do
              post(:create, params: sic_valid_params)

              ticket.reload
              ticket_sic.reload

              is_expected.to redirect_to(operator_ticket_path(ticket))
              expect(controller).to set_flash.to(I18n.t('operator.tickets.reopen_tickets.create.sic.done'))

              expect(ticket.reopened).to eq(1)
              expect(ticket.extended).to eq(false)
              expect(ticket.extended_second_time).to eq(false)
              expect(ticket.reopened_at.utc.to_i).to eq(current_datetime.utc.to_i)
              expect(ticket.sectoral_attendance?).to be_truthy
              expect(ticket.confirmed?).to be_truthy

              expect(ticket.call_center_feedback_at).to be_nil

              expect(ticket_sic.sectoral_attendance?).to be_truthy
              expect(ticket_sic.confirmed?).to be_truthy
            end.to change(TicketLog, :count).by(2)
          end
        end

        context 'sou' do

          let(:ticket_department) do
            create(:ticket_department, :answered, ticket: ticket_child)
          end

          context 'ticket child' do
            it 'saves' do
              expect do
                post(:create, params: child_valid_params)

                ticket.reload
                ticket_child.reload

                is_expected.to redirect_to(operator_ticket_path(ticket))
                expect(controller).to set_flash.to(I18n.t('operator.tickets.reopen_tickets.create.sou.done'))

                expect(ticket.reopened).to eq(1)
                expect(ticket.extended).to eq(false)
                expect(ticket.extended_second_time).to eq(false)
                expect(ticket.reopened_at.utc.to_i).to eq(current_datetime.utc.to_i)
                expect(ticket.sectoral_attendance?).to be_truthy
                expect(ticket.confirmed?).to be_truthy

                expect(ticket.call_center_feedback_at).to be_nil

                expect(ticket_child.sectoral_attendance?).to be_truthy
                expect(ticket_child.confirmed?).to be_truthy
              end.to change(TicketLog, :count).by(2)
            end

            it 'with ticket_departments' do
              ticket_department

              post(:create, params: child_valid_params)

              expect(ticket.reload.sectoral_attendance?).to be_truthy
              expect(ticket_child.reload.sectoral_attendance?).to be_truthy

              expect(ticket_department.reload).to be_not_answered
            end

            it 'without ticket_departments' do
              post(:create, params: child_valid_params)

              expect(ticket.reload.sectoral_attendance?).to be_truthy
              expect(ticket_child.reload.sectoral_attendance?).to be_truthy
            end

            it 'notify' do
              service = double

              allow(Notifier::Reopen).to receive(:delay) { service }
              allow(service).to receive(:call)

              post(:create, params: child_valid_params)

              expect(service).to have_received(:call).with(ticket_child.id)
            end

            context 'create ticket log' do
              before { post(:create, params: child_valid_params) }

              it 'for ticket_child' do
                ticket_log = TicketLog.where(ticket: ticket_child).last

                expect(ticket_log.ticket).to eq(ticket_child)
                expect(ticket_log.responsible).to eq(user)
                expect(ticket_log.action).to eq('reopen')
                expect(ticket_log.description).to eq(justification)
              end

              it 'for ticket_parent' do
                ticket_log = TicketLog.where(ticket: ticket).last

                expect(ticket_log.ticket).to eq(ticket)
                expect(ticket_log.responsible).to eq(user)
                expect(ticket_log.action).to eq('reopen')
                expect(ticket_log.description).to eq(justification)
              end
            end

            context 'sectoral_operator' do
              let(:user) { create(:user, :operator_sectoral, organ: ticket_child.organ) }
              let(:ticket) { ticket_child.parent }
              let(:ticket_child) { create(:ticket, :with_parent, :replied) }

              it 'saves' do
                expect do
                  post(:create, params: child_valid_params)

                  ticket.reload
                  ticket_child.reload

                  is_expected.to redirect_to(operator_ticket_path(ticket_child))
                  expect(controller).to set_flash.to(I18n.t('operator.tickets.reopen_tickets.create.sou.done'))

                  expect(ticket.reopened).to eq(1)
                  expect(ticket.extended).to eq(false)
                  expect(ticket.extended_second_time).to eq(false)
                  expect(ticket.reopened_at.utc.to_i).to eq(current_datetime.utc.to_i)
                  expect(ticket.sectoral_attendance?).to be_truthy
                  expect(ticket.confirmed?).to be_truthy

                  expect(ticket.call_center_feedback_at).to be_nil

                  expect(ticket_child.sectoral_attendance?).to be_truthy
                  expect(ticket_child.confirmed?).to be_truthy
                end.to change(TicketLog, :count).by(2)
              end
            end
          end

          context 'ticket parent' do
            it 'saves' do
              expect do
                post(:create, params: valid_params)

                ticket.reload

                is_expected.to redirect_to(operator_ticket_path(ticket))
                expect(controller).to set_flash.to(I18n.t('operator.tickets.reopen_tickets.create.sou.done'))

                expect(ticket.reopened).to eq(1)
                expect(ticket.reopened_at.utc.to_i).to eq(current_datetime.utc.to_i)
                expect(ticket.waiting_referral?).to be_truthy
                expect(ticket.confirmed?).to be_truthy
              end.to change(TicketLog, :count).by(1)
            end

            it 'create ticket log' do
              post(:create, params: valid_params)

              ticket_log = TicketLog.last

              expect(ticket_log.ticket).to eq(ticket)
              expect(ticket_log.responsible).to eq(user)
              expect(ticket_log.action).to eq('reopen')
              expect(ticket_log.description).to eq(justification)
            end

            context 'clear call_center_responsible' do
              let(:ticket) { create(:ticket, :replied, :with_call_center_responsible, created_by: user) }

              before { post(:create, params: valid_params) }

              it { expect(ticket.reload.call_center_responsible_id).to eq(nil) }
            end
          end

          context 'set deadline' do
            let(:ticket) { create(:ticket, :replied, :feedback, call_center_responsible: user, deadline: -1, deadline_ends_at: 1.day.ago) }
            let(:deadline) { Holiday.next_weekday(Ticket.response_deadline(:sou)) }
            let(:deadline_ends_at) { Date.today + deadline }

            before do
              post(:create, params: valid_params)
              ticket.reload
            end

            it { expect(ticket.deadline).to eq(deadline) }
            it { expect(ticket.deadline_ends_at).to eq(deadline_ends_at) }
          end

          it 'allowed params' do
            is_expected.to permit(*permitted_params).
            for(:create, params: { params: valid_params }).on(:ticket_log)
          end
        end
      end
    end
  end

end
