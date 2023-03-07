require 'rails_helper'

describe ChangeTicketType do

  let(:sou_ticket) { create(:ticket, ticket_type: :sou, sou_type: :complaint, confirmed_at: Date.today - 2.days, reopened_at: Date.today) }
  let(:sic_ticket) { create(:ticket, ticket_type: :sic, confirmed_at: Date.today - 2.days) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(ChangeTicketType).to receive(:new) { service }
      allow(service).to receive(:call)

      ChangeTicketType.call(sou_ticket)

      expect(ChangeTicketType).to have_received(:new)
      expect(service).to have_received(:call).with(sou_ticket, {})
    end
  end

  describe 'call' do
    context 'changes sou to sic' do

      context 'ticket parent' do
        it ' and clears sou_type' do

          child_ticket = create(:ticket, ticket_type: :sou, parent: sou_ticket, sou_type: :complaint, unknown_organ: false, organ: create(:executive_organ), confirmed_at: Date.today - 2.days)

          reopened_at = sou_ticket.reopened_at
          deadline = Ticket.response_deadline(:sic)
          weekday = Holiday.next_weekday(deadline, reopened_at)

          Timecop.freeze(DateTime.now) do

            result = ChangeTicketType.call(sou_ticket)

            sou_ticket.reload
            child_ticket.reload

            expect(result).to eq(true)
            expect(sou_ticket).to be_sic
            expect(sou_ticket.sou_type).to be_nil
            expect(sou_ticket.reopened_at).to eq(reopened_at)
            expect(sou_ticket.deadline).to eq(weekday)

            expect(child_ticket).to be_sic
            expect(child_ticket.sou_type).to be_nil
          end
        end

        it 'update sic document' do
          sou_ticket = create(:ticket, :confirmed, unknown_organ: true, document: '')

          result = ChangeTicketType.call(sou_ticket)

          sou_ticket.reload

          expect(sou_ticket).to be_sic
          expect(sou_ticket.document).to eq('0')
          expect(sou_ticket.document_type).to eq('other')
        end

        it 'update sic anonymous' do
          name = 'name'
          sou_ticket = create(:ticket, :confirmed, :anonymous, unknown_organ: true, name: name)

          result = ChangeTicketType.call(sou_ticket)

          sou_ticket.reload

          expect(sou_ticket).to be_sic
          expect(sou_ticket.name).to eq(name)
        end

        it 'update sic anonymous without name' do
          sou_ticket = create(:ticket, :confirmed, :anonymous, unknown_organ: true)

          result = ChangeTicketType.call(sou_ticket)

          sou_ticket.reload

          expect(sou_ticket).to be_sic
          expect(sou_ticket.name).to eq('0')
        end

        it 'when sou_type denunciation' do
          sou_ticket = create(:ticket, :denunciation, unknown_organ: true)

          result = ChangeTicketType.call(sou_ticket)

          sou_ticket.reload

          expect(result).to eq(true)
          expect(sou_ticket).to be_sic
          expect(sou_ticket.sou_type).to be_nil
        end
      end

      it 'ticket child' do
        ticket_sou_child = create(:ticket, :with_parent)
        ticket_parent = ticket_sou_child.parent

        ChangeTicketType.call(ticket_sou_child)

        ticket_sou_child.reload
        ticket_parent.reload

        expect(ticket_sou_child).to be_sic
        expect(ticket_parent).to be_sic
      end
    end

    describe 'changes sic to sou' do

      context 'ticket parent' do
        it 'and changes deadline' do
          confirmed_at = sic_ticket.confirmed_at
          deadline = Ticket.response_deadline(:sou)
          weekday = Holiday.next_weekday(deadline, confirmed_at)

          ChangeTicketType.call(sic_ticket, { sou_type: 'complaint' })

          sic_ticket.reload

          expect(sic_ticket.deadline).to eq(weekday - 2)
          expect(sic_ticket.deadline_ends_at).to eq(confirmed_at.to_date + weekday)
        end

        context 'and sets sou_type' do
          it 'complaint' do
            sou_type = 'complaint'

            ChangeTicketType.call(sic_ticket, { sou_type: sou_type })
            sic_ticket.reload

            expect(sic_ticket).to be_sou
            expect(sic_ticket.sou_type).to eq(sou_type)
          end

          it 'compliment' do
            sou_type = 'compliment'

            ChangeTicketType.call(sic_ticket, { sou_type: sou_type })
            sic_ticket.reload

            expect(sic_ticket).to be_sou
            expect(sic_ticket.sou_type).to eq(sou_type)
          end

          it 'suggestion' do
            sou_type = 'suggestion'

            ChangeTicketType.call(sic_ticket, { sou_type: sou_type })
            sic_ticket.reload

            expect(sic_ticket).to be_sou
            expect(sic_ticket.sou_type).to eq(sou_type)
          end

          it 'request' do
            sou_type = 'request'

            ChangeTicketType.call(sic_ticket, { sou_type: sou_type })
            sic_ticket.reload

            expect(sic_ticket).to be_sou
            expect(sic_ticket.sou_type).to eq(sou_type)
          end

          it 'denunciation' do
            sou_type = 'denunciation'
            organ = create(:executive_organ)

            ticket_attributes = {
              sou_type: sou_type,
              denunciation_organ_id: organ.id,
              denunciation_description: '123',
              denunciation_date: 'last week',
              denunciation_place: 'street 4',
              denunciation_witness: 'Joao',
              denunciation_evidence: 'yes',
              denunciation_assurance: 'rumor'
            }

            ChangeTicketType.call(sic_ticket, ticket_attributes)
            sic_ticket.reload

            expect(sic_ticket).to be_sou
            expect(sic_ticket.sou_type).to eq(sou_type)
          end
        end

        it 'and set public_ticket = false' do
          sic_ticket = create(:ticket, :public_ticket)
          sou_type = 'complaint'

          ChangeTicketType.call(sic_ticket, { sou_type: sou_type })
          sic_ticket.reload

          expect(sic_ticket).to be_sou
          expect(sic_ticket).not_to be_public_ticket
        end
      end

      it 'ticket child' do
        ticket_parent = create(:ticket, :sic, :confirmed, internal_status: :sectoral_attendance, confirmed_at: Date.today - 2.days)
        ticket_sic_child = create(:ticket, :with_organ, :sic, parent: ticket_parent, confirmed_at: Date.today - 2.days)
        ticket_parent.tickets << ticket_sic_child
        ticket_parent.save

        sou_type = 'complaint'

        ChangeTicketType.call(ticket_sic_child, { sou_type: sou_type })

        ticket_sic_child.reload
        ticket_parent.reload

        expect(ticket_sic_child).to be_sou
        expect(ticket_sic_child.sou_type).to eq(sou_type)
        expect(ticket_parent).to be_sou
        expect(ticket_parent.sou_type).to eq(sou_type)
      end
    end

    describe 'with extended deadline' do
      it 'change deadline to 30 days' do

        ticket_parent = create(:ticket, :sic, :confirmed, internal_status: :sectoral_attendance, confirmed_at: Date.today - 2.days, extended: true)
        ticket_sic_child = create(:ticket, :with_organ, :sic, parent: ticket_parent, confirmed_at: Date.today - 2.days, extended: true)
        ticket_parent.tickets << ticket_sic_child

        confirmed_at = ticket_parent.confirmed_at
        deadline = Ticket.response_extension(:sic)
        weekday = Holiday.next_weekday(deadline, confirmed_at)

        deadline_ends_at = confirmed_at.to_date +  weekday

        ticket_sic_child.deadline_ends_at = deadline_ends_at
        ticket_sic_child.deadline = (deadline_ends_at - Date.today).to_i
        ticket_sic_child.save
        ticket_parent.save

        sou_type = 'complaint'

        create(:extension, ticket: ticket_sic_child, status: :approved)

        ChangeTicketType.call(ticket_sic_child, { sou_type: sou_type })

        ticket_sic_child.reload
        ticket_parent.reload

        expect(ticket_sic_child).to be_sou
        expect(ticket_sic_child.sou_type).to eq(sou_type)
        expect(ticket_sic_child.deadline_ends_at).to eq(deadline_ends_at)
        expect(ticket_parent).to be_sou
        expect(ticket_parent.sou_type).to eq(sou_type)
      end
    end
  end
end
