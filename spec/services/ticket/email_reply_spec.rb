require 'rails_helper'

describe Ticket::EmailReply do

  let(:ticket) { create(:ticket, :with_parent) }

  let(:service) { Ticket::EmailReply.new(ticket.id) }

  it 'self.call' do
    service = double
    allow(Ticket::EmailReply).to receive(:new).with(ticket.id) { service }
    allow(service).to receive(:call)

    Ticket::EmailReply.call(ticket.id)

    expect(Ticket::EmailReply).to have_received(:new).with(ticket.id)
    expect(service).to have_received(:call)
  end

  it 'initialization' do
    expect(service.ticket).to be_an_instance_of(Ticket)
  end

  describe '#send_email' do
    let(:service) { double }

    before do
      allow(TicketMailer).to receive(:email_reply) { service }
      allow(service).to receive(:deliver)
    end

    context 'answer' do

      context 'with answer_type :final' do

        context 'only approved answers' do
          let!(:answer_awaiting) { create(:answer, answer_type: :final, status: :awaiting, ticket: ticket) }
          let!(:answer_sectoral_rejected) { create(:answer, answer_type: :final, status: :sectoral_rejected, ticket: ticket) }
          let!(:answer_sectoral_approved) { create(:answer, answer_type: :final, status: :sectoral_approved, ticket: ticket) }
          let!(:answer_cge_rejected) { create(:answer, answer_type: :final, status: :cge_rejected, ticket: ticket) }
          let!(:answer_cge_approved) { create(:answer, answer_type: :final, status: :cge_approved, ticket: ticket) }
          let!(:answer_user_evaluated) { create(:answer, answer_type: :final, status: :user_evaluated, ticket: ticket) }
          let!(:answer_call_center_approved) { create(:answer, answer_type: :final, status: :call_center_approved, ticket: ticket) }
          let!(:answer_subnet_rejected) { create(:answer, answer_type: :final, status: :subnet_rejected, ticket: ticket) }
          let!(:answer_subnet_approved) { create(:answer, answer_type: :final, status: :subnet_approved, ticket: ticket) }

          let(:approved_answers) { [answer_sectoral_approved, answer_cge_approved, answer_user_evaluated, answer_call_center_approved] }

          before { Ticket::EmailReply.call(ticket.id) }

          it 'call mailer' do
            expect(TicketMailer).to have_received(:email_reply).with(ticket.parent, match_array(approved_answers))
            expect(service).to have_received(:deliver)
          end
        end

        context 'when ticket' do
          let(:answer) { create(:answer, :cge_approved, ticket: ticket) }

          before do
            answer
            Ticket::EmailReply.call(ticket.id)
          end

          context 'parent' do
            let(:ticket) { create(:ticket) }

            it 'call mailer' do
              expect(TicketMailer).to have_received(:email_reply).with(ticket, [answer])
              expect(service).to have_received(:deliver)
            end
          end

          context 'child' do
            it 'call mailer' do
              expect(TicketMailer).to have_received(:email_reply).with(ticket.parent, [answer])
              expect(service).to have_received(:deliver)
            end
          end
        end
      end
    end

    it 'simple comment' do
      comments = [create(:comment, commentable: ticket)]

      service = double
      allow(TicketMailer).to receive(:email_reply) { service }
      allow(service).to receive(:deliver)

      Ticket::EmailReply.call(ticket.id)

      expect(TicketMailer).not_to have_received(:email_reply).with(ticket, comments)
      expect(service).not_to have_received(:deliver)
    end
  end

end
