require 'rails_helper'

describe Answer::CreationService do
    let(:service) { Answer::CreationService.new(answer, user) }
    let(:answer) { create(:answer, :cge_approved, :child_ticket) }
    let(:ticket) { answer.ticket }
    let(:parent) { ticket.parent }
    let(:user) { create(:user, :operator_cge) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      creation_service = double

      allow(Answer::CreationService).to receive(:new) { creation_service }
      allow(creation_service).to receive(:call)

      Answer::CreationService.call(answer, user)

      expect(Answer::CreationService).to have_received(:new).with(answer, user)
      expect(creation_service).to have_received(:call)
    end
  end

  describe 'initialization' do
    it 'responds to answer' do
      expect(service.answer).to eq(answer)
    end
    it 'responds to ticket' do
      expect(service.ticket).to eq(ticket)
    end
    it 'responds to parent_ticket' do
      expect(service.parent_ticket).to eq(parent)
    end
    it 'responds to user' do
      expect(service.responsible).to eq(user)
    end

    context 'responds to ticket_department_email' do
      let(:ticket_department_email) { create(:ticket_department_email) }
      let(:service) { Answer::CreationService.new(answer, ticket_department_email) }

      it { expect(service.responsible).to eq(ticket_department_email) }
    end

  end

  describe 'call' do
    context 'ticket status' do

      let!(:current_datetime) { DateTime.now }

      before { allow(DateTime).to receive(:now).and_return(current_datetime) }

      context 'when operator sectoral' do
        let(:user) { create(:user, :operator_sectoral) }

        before { answer.sectoral! }

        context 'final_answer' do
          context 'when ticket_type sou' do
            it 'change to cge_validation' do
              service.call

              ticket.reload

              expect(ticket.cge_validation?).to eq(true)
              expect(ticket.parent.cge_validation?).to eq(true)
              expect(answer.reload).to be_awaiting
            end

            context 'when organ.ignore_cge_validation == true' do
              let(:organ) { create(:executive_organ, ignore_cge_validation: true) }

              before { ticket.update_attribute(:organ, organ) }

              it 'change to final_answer' do
                service.call

                ticket.reload

                expect(ticket.final_answer?).to be_truthy
                expect(ticket.parent.final_answer?).to be_truthy
                expect(ticket.parent.call_center_status).to eq(nil)
                expect(answer.cge_approved?).to be_truthy
              end

              it 'change to waiting_allocation when anwer_type phone' do
                parent.answer_phone = "(11) 91111-1111"
                parent.phone!

                service.call
                parent.reload

                expect(ticket.parent).to be_waiting_allocation
              end

              context 'with other organ' do
                let(:other_ticket) { create(:ticket, :with_parent, parent: parent, internal_status: :sectoral_attendance) }
                it 'change to final_answer' do
                  other_ticket

                  status_parent = parent.internal_status
                  service.call

                  ticket.reload

                  expect(ticket.final_answer?).to be_truthy
                  expect(ticket.parent.internal_status).to eq(status_parent)
                  expect(ticket.parent.call_center_status).to eq(nil)
                  expect(answer.cge_approved?).to be_truthy
                end

                it 'and partial_answer' do
                  other_ticket.partial_answer!

                  service.call

                  ticket.reload

                  expect(ticket.final_answer?).to be_truthy
                  expect(ticket.parent.partial_answer?).to be_truthy
                  expect(ticket.parent.call_center_status).to eq(nil)
                  expect(answer.cge_approved?).to be_truthy
                end
              end
            end

            context 'and belongs_to subnet' do
              let(:subnet) { create(:subnet) }
              let(:organ) { subnet.organ }

              before { ticket.update_attributes(subnet: subnet, organ: organ) }

              it 'change to final_answer' do
                service.call

                ticket.reload

                expect(ticket.final_answer?).to be_truthy
                expect(ticket.parent.final_answer?).to be_truthy
                expect(ticket.parent.call_center_status).to eq(nil)
                expect(answer.cge_approved?).to be_truthy
              end

              it 'change to waiting_allocation when anwer_type phone' do
                parent.answer_phone = "(11) 91111-1111"
                parent.phone!

                service.call
                parent.reload

                expect(ticket.parent).to be_waiting_allocation
              end

              context 'with other organ' do
                let(:other_ticket) { create(:ticket, :with_parent, parent: parent, internal_status: :sectoral_attendance) }
                it 'change to final_answer' do
                  other_ticket

                  status_parent = parent.internal_status
                  service.call

                  ticket.reload

                  expect(ticket.final_answer?).to be_truthy
                  expect(ticket.parent.internal_status).to eq(status_parent)
                  expect(ticket.parent.call_center_status).to eq(nil)
                  expect(answer.cge_approved?).to be_truthy
                end

                it 'and partial_answer' do
                  other_ticket.partial_answer!

                  service.call

                  ticket.reload

                  expect(ticket.final_answer?).to be_truthy
                  expect(ticket.parent.partial_answer?).to be_truthy
                  expect(ticket.parent.call_center_status).to eq(nil)
                  expect(answer.cge_approved?).to be_truthy
                end
              end
            end
          end

          context 'when ticket_type sic' do
            it 'change to cge_approved' do
              ticket.sic!
              service.call

              ticket.reload

              expect(ticket.final_answer?).to eq(true)
              expect(ticket.parent.final_answer?).to eq(true)
              expect(answer.reload).to be_cge_approved
              expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
            end

            it 'change to waiting_allocation when anwer_type phone' do
              ticket.sic!
              parent.answer_phone = "(11) 91111-1111"
              parent.phone!

              service.call
              parent.reload

              expect(parent).to be_waiting_allocation
            end

            context 'when has another ticket inactive' do
              let(:invalidated_ticket) { create(:ticket, :sic, :with_parent, :invalidated, parent: parent) }

              before do
                ticket.sic!
                invalidated_ticket
                service.call

                ticket.reload
                answer.reload
              end

              it 'change to cge_approved' do
                expect(ticket.final_answer?).to eq(true)
                expect(ticket.parent.final_answer?).to eq(true)
                expect(answer).to be_cge_approved
                expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
              end
            end
          end
        end

        context 'partial_answer' do
          before { answer.partial! }

          context 'when ticket_type sou' do

            it 'change to cge_validation' do
              service.call

              ticket.reload

              expect(ticket.cge_validation?).to eq(true)
              expect(ticket.parent.cge_validation?).to eq(true)
              expect(ticket.parent.call_center_status).to eq(nil)
              expect(answer.reload).to be_awaiting
            end

            context 'with other ticket child' do
              let(:other_ticket) { create(:ticket, :with_parent, parent: parent) }

              it 'change to cge_validation' do
                ticket.parent.cge_validation!
                other_ticket

                service.call

                ticket.reload

                expect(ticket.cge_validation?).to be_truthy
                expect(ticket.parent.cge_validation?).to be_truthy
                expect(ticket.parent.call_center_status).to eq(nil)
                expect(answer.awaiting?).to be_truthy
              end
            end

            context 'when organ.ignore_cge_validation == true' do
              let(:organ) { create(:executive_organ, ignore_cge_validation: true) }
              before { ticket.update_attribute(:organ, organ) }

              it 'change to partial_answer' do
                service.call

                ticket.reload

                expect(ticket.partial_answer?).to be_truthy
                expect(ticket.parent.partial_answer?).to be_truthy
                expect(answer.cge_approved?).to be_truthy
              end
            end
          end
        end

        context 'positioning' do
          let(:department) { create(:department, organ: user.organ) }

          before do
            answer.department_id = department.id
            answer.department!
            answer.awaiting!
            create(:ticket_department, ticket: ticket,
              department: department)
          end

          describe 'when any department answered' do
            it 'change to sectoral_validation' do
              ticket.internal_attendance!

              create(:ticket_department, ticket: ticket)

              service.call

              expect(ticket.reload).to be_sectoral_validation
              expect(answer.reload).to be_sectoral_approved
              expect(answer.reload).to be_final
            end
          end
        end

        context 'ticket.immediate_answer = true' do
          before do
            create(:classification, ticket: ticket)
            ticket.immediate_answer = true

            ticket.save
          end

          it 'change to final_answer' do
            service.call

            ticket.reload

            expect(ticket.final_answer?).to be_truthy
            expect(ticket.parent.final_answer?).to be_truthy
            expect(answer).to be_sectoral
            expect(answer).to be_cge_approved
          end
        end
      end

      context 'when operator subnet' do
        let(:user) { create(:user, :operator_subnet) }
        let(:subnet) { user.subnet }
        let(:organ) { user.organ }
        let(:ticket) { create(:ticket, :with_parent, :with_subnet, subnet: subnet, organ: organ) }
        let(:answer) { create(:answer, answer_scope: :subnet, ticket: ticket) }

        context 'final_answer' do
          context 'when ticket_type sou' do
            it 'change to sectoral_validation' do
              service.call

              ticket.reload

              expect(ticket.sectoral_validation?).to eq(true)
              expect(ticket.parent.sectoral_validation?).to eq(true)
              expect(answer.reload).to be_awaiting
            end

            context 'when subnet.ignore_sectoral_validation == true' do
              before { subnet.update_attribute(:ignore_sectoral_validation, true) }

              it 'change to cge_validation' do
                service.call

                ticket.reload

                expect(ticket.final_answer?).to eq(true)
                expect(ticket.parent.final_answer?).to eq(true)
                expect(answer.reload).to be_cge_approved
              end

              context 'and organ.ignore_cge_validation == true' do

                before { organ.update_attribute(:ignore_cge_validation, true) }

                it 'change to final_answer' do
                  service.call

                  ticket.reload

                  expect(ticket.final_answer?).to be_truthy
                  expect(ticket.parent.final_answer?).to be_truthy
                  expect(ticket.parent.call_center_status).to eq(nil)
                  expect(answer.cge_approved?).to be_truthy
                end

                it 'change to waiting_allocation when anwer_type phone' do
                  parent.answer_phone = "(11) 91111-1111"
                  parent.phone!

                  service.call
                  parent.reload

                  expect(ticket.parent).to be_waiting_allocation
                end

                context 'with other organ' do
                  let(:other_ticket) { create(:ticket, :with_parent, parent: parent, internal_status: :sectoral_attendance) }
                  it 'change to final_answer' do
                    other_ticket

                    status_parent = parent.internal_status
                    service.call

                    ticket.reload

                    expect(ticket.final_answer?).to be_truthy
                    expect(ticket.parent.internal_status).to eq(status_parent)
                    expect(ticket.parent.call_center_status).to eq(nil)
                    expect(answer.cge_approved?).to be_truthy
                  end

                  it 'and partial_answer' do
                    other_ticket.partial_answer!

                    service.call

                    ticket.reload

                    expect(ticket.final_answer?).to be_truthy
                    expect(ticket.parent.partial_answer?).to be_truthy
                    expect(ticket.parent.call_center_status).to eq(nil)
                    expect(answer.cge_approved?).to be_truthy
                  end
                end
              end
            end
          end
        end

        context 'ticket.immediate_answer = true' do
          before do
            answer
            create(:classification, ticket: ticket)
            ticket.immediate_answer = true
            ticket.save
          end

          it 'change to final_answer' do
            service.call

            ticket.reload

            expect(ticket).to be_final_answer
            expect(ticket.parent).to be_final_answer
            expect(answer).to be_subnet
            expect(answer).to be_cge_approved
          end
        end
      end

      context 'when operator subnet internal' do
        let(:user) { create(:user, :operator_subnet_internal) }

        before do
          answer.subnet_department!
          answer.awaiting!
          create(:ticket_department, ticket: ticket,
            department: user.department)
        end

        describe 'when any department answered' do
          it 'change to subnet_validation' do
            ticket.internal_attendance!

            create(:ticket_department, ticket: ticket)

            service.call

            expect(ticket.reload).to be_subnet_validation
            expect(answer.reload).to be_awaiting
          end
        end
      end

      context 'when operator internal' do
        let(:user) { create(:user, :operator_internal) }

        before do
          answer.department!
          answer.awaiting!
          create(:ticket_department, ticket: ticket,
            department: user.department)
        end

        describe 'when nany department answered' do
          it 'change to sectoral_validation' do
            ticket.internal_attendance!

            create(:ticket_department, ticket: ticket)

            service.call

            expect(ticket.reload).to be_sectoral_validation
            expect(answer.reload).to be_awaiting
          end
        end
      end

      context 'when positioning by email' do
        let(:ticket_department) { create(:ticket_department, ticket: ticket) }
        let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }

        let(:service) { Answer::CreationService.new(answer, ticket_department_email) }

        before do
          answer.department!
          answer.awaiting!
        end

        context 'when any department answered' do
          it 'change to sectoral_validation' do
            ticket.internal_attendance!

            create(:ticket_department, ticket: ticket)

            service.call

            expect(ticket.reload).to be_sectoral_validation
            expect(answer.reload).to be_awaiting
          end
        end
      end

      context 'when positioning subnet by email' do
        let(:ticket_department) { create(:ticket_department, ticket: ticket) }
        let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }

        let(:service) { Answer::CreationService.new(answer, ticket_department_email) }

        before do
          answer.subnet_department!
          answer.awaiting!
        end

        describe 'when any department answered' do
          it 'change to subnet_validation' do
            ticket.internal_attendance!

            create(:ticket_department, ticket: ticket)

            service.call

            expect(ticket.reload).to be_subnet_validation
            expect(answer.reload).to be_awaiting
          end
        end
      end

      context 'when operator cge' do
        let!(:organ_cge) { create(:executive_organ, acronym: 'CGE') }
        let(:inactive_child) { create(:ticket, :with_parent, :invalidated, parent: ticket) }

        context 'when ticket parent' do
          let(:answer) { create(:answer) }

          it 'change to final_answer' do
            service.call

            ticket.reload

            expect(ticket.final_answer?).to eq(true)
            expect(ticket.replied?).to eq(true)
            expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
          end

          it 'change to waiting_allocation when anwer_type phone' do
            ticket.answer_phone = "(11) 91111-1111"
            ticket.phone!

            service.call
            ticket.reload

            expect(ticket).to be_waiting_allocation
          end

          context 'change active children to final_answer' do
            let(:active_child) { create(:ticket, :with_parent, :in_sectoral_attendance, parent: ticket) }

            before do
              active_child
              inactive_child

              service.call

              active_child.reload
              inactive_child.reload
            end

            it { expect(active_child.final_answer?).to eq(true) }
            it { expect(active_child.replied?).to eq(true) }

            it { expect(inactive_child.invalidated?).to eq(true) }
            it { expect(inactive_child.confirmed?).to eq(true) }
          end

          context 'partial_answer' do
            before { answer.partial! }

            context 'when ticket_type sou' do

              it 'change to partial_answer' do
                service.call

                ticket.reload

                expect(ticket.partial_answer?).to be_truthy
                expect(answer.cge_approved?).to be_truthy
              end
            end
          end
        end

        context 'when ticket child' do
          it 'change to final_answer' do
            service.call

            ticket.reload
            inactive_child.reload
            parent.reload

            expect(ticket.final_answer?).to eq(true)
            expect(ticket.replied?).to eq(true)

            expect(inactive_child.final_answer?).to eq(false)
            expect(inactive_child.replied?).to eq(false)

            expect(parent.final_answer?).to eq(true)
            expect(parent.replied?).to eq(true)
            expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
            expect(parent.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
          end


          context 'partial_answer' do
            before { answer.partial! }

            context 'when ticket_type sou' do

              it 'change to partial_answer' do
                service.call

                ticket.reload

                expect(ticket.partial_answer?).to be_truthy
                expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
                expect(ticket.parent.partial_answer?).to be_truthy
                expect(ticket.parent.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
                expect(ticket.parent.call_center_status).to eq(nil)
                expect(answer.cge_approved?).to be_truthy
              end

              context 'with other organ' do
                let(:other_ticket) { create(:ticket, :with_parent, parent: parent) }
                it 'change to partial_answer' do
                  ticket.parent.cge_validation!
                  other_ticket

                  service.call

                  ticket.reload

                  expect(ticket.partial_answer?).to be_truthy
                  expect(ticket.responded_at.utc.to_i).to eq(current_datetime.utc.to_i)
                  expect(ticket.parent.cge_validation?).to be_truthy
                  expect(ticket.parent.responded_at).to eq(nil)
                  expect(ticket.parent.call_center_status).to eq(nil)
                  expect(answer.cge_approved?).to be_truthy
                end
              end
            end
          end
        end
      end
    end

    it 'update ticket classification' do

      expect(ticket.answer_classification).to be_nil

      service.call

      expect(ticket.reload).to be_sou_demand_well_founded
      expect(answer.reload).to be_sou_demand_well_founded
    end

    context 'register ticket log' do
      let(:attachment) { create(:attachment, attachmentable: answer) }

      it 'for answer' do
        expected_attributes = {
          resource: answer,
          data: {
            responsible_user_id: user.id,
            responsible_organ_id: ticket.organ_id,
            responsible_department_id: nil,
            responsible_subnet_id: nil
          }
        }

        allow(RegisterTicketLog).to receive(:call)
        service.call
        expect(RegisterTicketLog).to have_received(:call).with(parent, user, :answer, expected_attributes)
        expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :answer, expected_attributes)
      end

      it 'for attachments' do
        allow(RegisterTicketLog).to receive(:call).with(anything, user, :answer, anything)
        allow(RegisterTicketLog).to receive(:call).with(anything, user, :create_attachment, anything)

        attachment

        service.call

        expect(RegisterTicketLog).to have_received(:call).with(parent, user, :create_attachment, { resource: attachment })
        expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :create_attachment, { resource: attachment })
      end

      context 'when positioning by email' do

        let(:ticket_department) { create(:ticket_department, ticket: ticket) }
        let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }

        let(:service) { Answer::CreationService.new(answer, ticket_department_email) }

        let(:expected_attributes) do
          {
            resource: answer,
            data: {
              responsible_user_id: nil,
              responsible_organ_id: ticket.organ_id,
              responsible_department_id: ticket_department.department_id,
              responsible_subnet_id: nil
            }
          }
        end

        before do
          answer.department!
          answer.awaiting!

          allow(RegisterTicketLog).to receive(:call)
          service.call
        end

        it { expect(RegisterTicketLog).to have_received(:call).with(parent, ticket_department_email, :answer, expected_attributes) }
        it { expect(RegisterTicketLog).to have_received(:call).with(ticket, ticket_department_email, :answer, expected_attributes) }
      end
    end

    context 'notify' do
      let(:notifier) { double }

      before do
        allow(Notifier::Answer).to receive(:delay) { notifier }
        allow(notifier).to receive(:call)

        service.call
      end

      context 'when authenticated as operator' do
        it { expect(notifier).to have_received(:call).with(answer.id, user.id) }
      end

      context 'when positioning by email' do
        let(:ticket_department) { create(:ticket_department, ticket: ticket) }
        let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }

        let(:service) { Answer::CreationService.new(answer, ticket_department_email) }

        it { expect(notifier).to have_received(:call).with(answer.id, nil) }
      end
    end
  end
end
