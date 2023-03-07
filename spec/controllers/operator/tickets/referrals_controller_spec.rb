require 'rails_helper'

describe Operator::Tickets::ReferralsController do

  let(:organ) { create(:executive_organ) }
  let(:user) { create(:user, :operator_sectoral, organ: organ) }
  let(:internal) { create(:user, :operator_internal) }
  let(:ticket) { create(:ticket, :confirmed, :with_parent, classified: true, organ: organ) }


  let(:permitted_params) do
    [
      ticket_departments_attributes: [
        :id,
        :department_id,
        :description,
        :deadline,
        :deadline_ends_at,
        :considerations,
        :user_id,
        protected_attachment_ids: [],
        ticket_department_sub_departments_attributes: [
          :id,
          :sub_department_id,
          :_destroy
        ],

        ticket_department_emails_attributes: [
          :id,
          :email
        ]
      ]
    ]
  end

  describe "#new" do
    context 'unauthorized' do
      before { get(:new, params: { ticket_id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new, params: { ticket_id: ticket }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
      end

    end
  end

  describe '#create' do
    context 'unauthorized' do
      before do
        post(:create, params: { ticket_id: ticket })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      let(:ticket_department) { create(:ticket_department, ticket: ticket) }
      let(:department) { ticket_department.department }
      let(:new_department) { create(:department) }
      let(:deadline_ends) { Date.today + 14.days }
      let(:ticket_params) do
        {
          ticket_id: ticket.id,

          ticket: {
            ticket_departments_attributes: {
              '1' => new_ticket_department_attributes,
              '2' => {id: ticket_department.id}
            }
          }
        }
      end

      let(:new_ticket_department_attributes) do
        {
          department_id: new_department.id,
          description: 'description',
          considerations: 'note',
          deadline_ends_at: deadline_ends
        }
      end

      before { sign_in(user) }

      render_views

      it 'permits ticket params' do
        should permit(*permitted_params).
          for(:create, params: ticket_params ).on(:ticket)
      end

      context 'valid' do

        it 'saves' do
          post(:create, params: ticket_params)

          expect(controller).to redirect_to(operator_ticket_path(ticket, anchor: 'tabs-areas'))
          expect(controller).to set_flash.to(I18n.t('operator.tickets.referrals.create.done'))
          expect(ticket.ticket_departments.count).to eq(2)
        end

        context 'when have a attachment protection' do
          it 'Adding a ticket attachment protection' do
            expect do
              ticket = create(:ticket, :confirmed, :with_parent, classified: true, organ: organ)
              attachment_1 = create(:attachment, attachmentable: ticket)
              attachment_2 = create(:attachment, attachmentable: ticket)
              ticket_params[:ticket][:ticket_departments_attributes]['1'][:protected_attachment_ids] = [attachment_1.id, attachment_2.id]

              post(:create, params: ticket_params)

              log_attach = TicketLog.where(action: 'ticket_protect_attachment')
              expect(TicketLog.count).to eq(4)
              expect(log_attach.count).to eq(2) 
                            
            end.to change(TicketProtectAttachment, :count).by(2)
          end
        end

        it 'register ticket log' do
          allow(RegisterTicketLog).to receive(:call)

          post(:create, params: ticket_params)

          data_expected = { emails: [], considerations: 'note' }

          expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :forward, { resource: new_department, data: data_expected })
          expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :forward, { resource: new_department, data: data_expected })
        end

        context 'notify' do
          let(:service) { double }

          before do
            allow(Notifier::Referral).to receive(:delay) { service }
            allow(service).to receive(:call)
          end

          it 'departments' do
            post(:create, params: ticket_params)

            department_id = ticket_params[:ticket][:ticket_departments_attributes]['1'][:department_id]
            expect(service).to have_received(:call).with(ticket.id, department_id, user.id)
          end
        end

        context 'send emails for not registred operators' do

          let(:operator_email) { 'test@example.com' }

          let(:new_ticket_department_attributes) do
            {
              department_id: new_department.id,
              description: 'description',
              considerations:'note',
              deadline_ends_at: deadline_ends,

              ticket_department_emails_attributes: [
                email: operator_email
              ]
            }
          end

          let(:created_ticket_department) { TicketDepartment.find_by(ticket_id: ticket.id, department_id: new_department.id) }
          let(:created_ticket_department_email) { created_ticket_department.ticket_department_emails.find_by(email: operator_email) }

          let(:service) { double }

          before do
            allow(Notifier::Referral::AdditionalUser).to receive(:delay) { service }
            allow(service).to receive(:call)

            allow(RegisterTicketLog).to receive(:call)

            post(:create, params: ticket_params)
          end

          it { expect(service).to have_received(:call).with(ticket.id, created_ticket_department_email.id, user.id) }

          it 'register ticket log with emails' do
            ticket_department = ticket.ticket_departments.find_by(department_id: new_department)
            data_expected = {
              emails: ticket_department.ticket_department_emails.map(&:email),
              considerations: ticket_department.considerations
            }

            expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :forward, { resource: new_department, data: data_expected })
            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :forward, { resource: new_department, data: data_expected })
          end
        end

        it 'change status' do
          post(:create, params: ticket_params)

          expect(ticket.reload.internal_attendance?).to be_truthy
        end

        context 'set deadline' do

          context 'sectoral' do

            it 'when deadline_ends_at present' do
              deadline = 5
              deadline_ends_at = Date.today + deadline

              operator_internal = create(:user, :operator_internal, organ: new_department.organ, department: new_department)

              ticket_params[:ticket][:ticket_departments_attributes]['1'][:deadline_ends_at] = deadline_ends_at

              post(:create, params: ticket_params)

              ticket_department = ticket.reload.ticket_department_by_user(operator_internal)

              expect(ticket_department.deadline).to eq(deadline)
              expect(ticket_department.deadline_ends_at).to eq(deadline_ends_at)
            end

            it 'when deadline_ends_at empty deadline must be blank' do
              operator_internal = create(:user, :operator_internal, organ: new_department.organ, department: new_department)

              ticket_params[:ticket][:ticket_departments_attributes]['1'][:deadline_ends_at] = nil

              post(:create, params: ticket_params)

              ticket_department = ticket.reload.ticket_department_by_user(operator_internal)

              expect(ticket_department.deadline).to be_blank
              expect(ticket_department.deadline_ends_at).to be_blank
            end
          end

          context 'internal' do

            before do
              create(:ticket_department, ticket: ticket, department: internal.department)
              sign_in(internal)
            end

            it 'when deadline_ends_at present' do
              ticket_internal = ticket.ticket_department_by_user(internal)
              deadline = ticket_internal.deadline
              deadline_ends_at = ticket_internal.deadline_ends_at

              operator_internal = create(:user, :operator_internal, organ: new_department.organ, department: new_department)

              post(:create, params: ticket_params)

              ticket_department = ticket.reload.ticket_department_by_user(operator_internal)

              expect(ticket_department.deadline).to eq(deadline)
              expect(ticket_department.deadline_ends_at).to eq(deadline_ends_at)
            end

            it 'when deadline_ends_at empty uses ticket.deadline_ends_at' do
              ticket_internal = ticket.ticket_department_by_user(internal)
              deadline = ticket_internal.deadline
              deadline_ends_at = ticket_internal.deadline_ends_at

              operator_internal = create(:user, :operator_internal, organ: new_department.organ, department: new_department)

              post(:create, params: ticket_params)

              ticket_department = ticket.reload.ticket_department_by_user(operator_internal)

              expect(ticket_department.deadline).to eq(deadline)
              expect(ticket_department.deadline_ends_at).to eq(deadline_ends_at)
            end
          end
        end
      end

      context 'invalid' do
        let(:invalid_params) do
          {
            ticket_departments_attributes: {
              '1' => {department_id: department.id, description: ''}
            }
          }
        end

        it 'does not saves' do
          post(:create, params: { ticket_id: ticket, ticket: invalid_params })

          expect(controller).to render_template(:new)
          expect(controller).to set_flash.now.to(I18n.t('operator.tickets.referrals.create.fail'))
          expect(ticket.ticket_departments.count).to eq(1)
        end
      end

    end
  end

  describe '#destroy' do
    before { sign_in(user) }

    let(:ticket_internal) { create(:ticket, :with_parent, :in_internal_attendance, classified: true, organ: organ) }
    let(:ticket_department) { create(:ticket_department, ticket: ticket_internal, department: internal.department) }
    let!(:email) { create(:ticket_department_email, ticket_department: ticket_department) }

    context 'destroys' do
      context 'when ticket has referral for a only department' do
        it 'ticket in internal_attendance' do
          ticket_internal
          ticket_department

          expect do
            delete(:destroy, params: { ticket_id: ticket_internal.id, id: ticket_department.id })

            ticket_internal.reload
            expected_flash = I18n.t('operator.tickets.referrals.destroy.done')

            expect(response).to redirect_to(new_operator_ticket_referral_path(ticket_internal))
            expect(controller).to set_flash.to(expected_flash)
            expect(ticket_internal.sectoral_attendance?).to be_truthy
            expect(TicketDepartmentEmail.count).to eq(0)
          end.to change(TicketDepartment, :count).by(-1)
        end

        it 'ticket not in internal_attendance' do
          ticket_internal.sectoral_attendance!
          ticket_department

          expect do
            delete(:destroy, params: { ticket_id: ticket_internal.id, id: ticket_department.id })

            ticket_internal.reload
            expected_flash = I18n.t('operator.tickets.referrals.destroy.done')

            expect(response).to redirect_to(new_operator_ticket_referral_path(ticket_internal))
            expect(controller).to set_flash.to(expected_flash)
            expect(ticket_internal.sectoral_attendance?).to be_truthy
            expect(TicketDepartmentEmail.count).to eq(0)
          end.to change(TicketDepartment, :count).by(-1)
        end
      end

      it 'when ticket has referral for more than one department' do
        ticket_internal
        ticket_department
        create(:ticket_department, ticket: ticket_internal)

        expect do
          delete(:destroy, params: { ticket_id: ticket_internal.id, id: ticket_department.id })

          ticket_internal.reload
          expected_flash = I18n.t('operator.tickets.referrals.destroy.done')

          expect(response).to redirect_to(new_operator_ticket_referral_path(ticket_internal))
          expect(controller).to set_flash.to(expected_flash)
          expect(ticket_internal.internal_attendance?).to be_truthy
        end.to change(TicketDepartment, :count).by(-1)
      end
    end

    it 'does not destroys' do
      allow_any_instance_of(TicketDepartment).to receive(:destroy).and_return(false)
      delete(:destroy, params: { ticket_id: ticket_internal.id, id: ticket_department.id })

      expected_flash = I18n.t('operator.tickets.referrals.destroy.fail')

      expect(response).to redirect_to(new_operator_ticket_referral_path(ticket_internal))
      expect(controller).to set_flash.to(expected_flash)
    end

    it 'notify' do
      service = double
      allow(Notifier::Referral::Delete).to receive(:delay) { service }
      allow(service).to receive(:call)

      delete(:destroy, params: { ticket_id: ticket_internal.id, id: ticket_department.id })

      expect(service).to have_received(:call).with(ticket_department.id, user.id)
    end

    it 'register ticket log' do
      allow(RegisterTicketLog).to receive(:call)
      ticket_department = create(:ticket_department, ticket: ticket)

      data_expected = {
        department: ticket_department.title
      }

      delete(:destroy, params: { ticket_id: ticket_internal.id, id: ticket_department.id })

      expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :delete_forward, { data: data_expected })
      expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :delete_forward, { data: data_expected })
    end
  end
end
