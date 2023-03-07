require 'rails_helper'

describe EvaluateTicketDeadline do

  describe 'self.call' do
    it 'invoke call method' do
      service = double
      allow(EvaluateTicketDeadline).to receive(:new) { service }
      allow(service).to receive(:call)

      EvaluateTicketDeadline.call

      expect(EvaluateTicketDeadline).to have_received(:new)
      expect(service).to have_received(:call)
    end

  end

  describe 'call' do
    let(:service) { EvaluateTicketDeadline.new }

    it 'notify' do
      ticket = create(:ticket, :with_parent, :confirmed, internal_status: :waiting_referral)
      service_notifier = double
      allow(Notifier::Deadline).to receive(:delay) { service_notifier }
      allow(service_notifier).to receive(:call)

      service.call

      expect(service_notifier).to have_received(:call).with(ticket.id)
    end

    context 'ticket with status in_progress' do
      let(:ticket) { create(:ticket, :in_progress) }

      context 'not update deadline' do
        before do
          ticket
          service.call
          ticket.reload
        end

        it { expect(ticket.deadline).to eq(nil) }
      end
    end

    context 'ticket with status confirmed' do
      let(:deadline_ends_at) { Date.today + 5.days }
      let(:ticket) { create(:ticket, :with_parent, :confirmed, internal_status: :waiting_referral, deadline_ends_at: deadline_ends_at, deadline: 0) }

      context 'update deadline' do
        before do
          ticket
          service.call
          ticket.reload
        end

        it {
          expect(ticket.deadline).to eq(5)
        }
      end
    end

     context 'ticket with status appeald' do
      let(:deadline_ends_at) { Date.today + 5.days }
      let(:ticket) { create(:ticket, :confirmed, internal_status: :appeal, deadline_ends_at: deadline_ends_at, deadline: 0) }

      context 'update deadline' do
        before do
          ticket
          service.call
          ticket.reload
        end

        it {
            expect(ticket.deadline).to eq(5)
        }
      end
    end


    context 'ticket with status in_progress' do
      let(:ticket) { create(:ticket, :replied, deadline_ends_at: Date.today + 5.days, deadline: -1) }

      context 'not update deadline' do
        before do
          ticket
          service.call
          ticket.reload
        end

        it { expect(ticket.deadline).to eq(-1) }
      end
    end

    context 'update ticket_department deadline' do

      let(:ticket_deadline) { 5 }
      let(:ticket_deadline_ends_at) { Date.today + ticket_deadline }
      let(:ticket) { create(:ticket, :with_parent, :confirmed, internal_status: :internal_attendance, deadline_ends_at: ticket_deadline_ends_at, deadline: ticket_deadline) }

      let(:ticket_department_deadline) { 2 }
      let(:ticket_department_deadline_ends_at) { Date.today + ticket_department_deadline }
      let(:ticket_department) { create(:ticket_department, ticket: ticket, deadline_ends_at: ticket_department_deadline_ends_at, deadline: 0) }

      before do
        ticket_department

        service.call
        ticket_department.reload
      end

      it { expect(ticket_department.deadline).to eq(ticket_department_deadline) }
    end

    context 'ignore when ticket_department.deadline_ends_at nil' do

      let(:ticket) { create(:ticket, :confirmed, internal_status: :internal_attendance) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket, deadline_ends_at: nil, deadline: nil) }

      before do
        ticket_department

        service.call

        ticket_department.reload
      end

      it { expect(ticket_department.deadline).to eq(nil) }
    end

  end

end
