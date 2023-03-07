require 'rails_helper'

describe Attendance::CloneService do

  let(:user) { create(:user, :operator_call_center) }
  let(:ticket) { create(:ticket, :for_clone) }
  let(:attendance) { create(:attendance, :with_ticket, ticket: ticket) }
  let(:new_attendance) { Attendance.create(service_type: :incorrect_click) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Attendance::CloneService).to receive(:new) { service }
      allow(service).to receive(:call)

      Attendance::CloneService.call(user, attendance.id, new_attendance.id)

      expect(Attendance::CloneService).to have_received(:new)
      expect(service).to have_received(:call).with(user, attendance.id, new_attendance.id)
    end
  end

  describe 'call' do
    let(:clone) { Attendance::CloneService.call(user, attendance.id, new_attendance.id) }

    before { attendance }

    context 'clone attendace' do
      it 'default attendance created' do
        clone
        created_attendance = Attendance.last

        expect(created_attendance.service_type).to eq('incorrect_click')
      end

      it 'default' do
        attendance.reload
        expect do
          expect(clone.id).not_to eq(attendance.id)
          expect(clone.protocol).not_to eq(attendance.protocol)

          expect(clone.service_type).to eq(attendance.service_type)
          expect(clone.description).to eq(attendance.description)
          expect(clone.created_by).to eq(user)
          expect(clone.answer).to eq(attendance.answer)


          expect(clone.unknown_organ).to eq(attendance.unknown_organ)
        end.to change(Attendance, :count).by(1)
      end

      context 'without ticket' do
        let(:attendance) { create(:attendance, :with_ticket) }

        it 'attributes' do
          expect do
            expect(clone.ticket_id).to eq(nil)
          end.to change(Attendance, :count).by(1)
        end
      end
    end

    context 'clone ticket' do
      let(:cloned_ticket) { clone.ticket }

      it 'default' do
        expect do
          # atributos que NÃO DEVEM ser copiados
          expect(cloned_ticket.id).not_to eq(ticket.id)
          expect(cloned_ticket.protocol).not_to eq(ticket.protocol)

          # atributos que DEVEM ser copiados
          expect(cloned_ticket.answer_type).to eq(ticket.answer_type)
          expect(cloned_ticket.used_input).to eq(ticket.used_input)
          expect(cloned_ticket.internal_status).to eq('in_filling')
          expect(cloned_ticket.description).to eq(ticket.description)
          expect(cloned_ticket.ticket_type).to eq(ticket.ticket_type)
          expect(cloned_ticket.sou_type).to eq(ticket.sou_type)
          expect(cloned_ticket.answer_type).to eq(ticket.answer_type)
          expect(cloned_ticket.city_id).to eq(ticket.city_id)
          expect(cloned_ticket.used_input).to eq(ticket.used_input)
          expect(cloned_ticket.person_type).to eq(ticket.person_type)

          # atributos default
          expect(cloned_ticket).to be_parent
          expect(cloned_ticket).to be_no_children
          expect(cloned_ticket).to be_in_progress
          expect(cloned_ticket.tickets.count).to eq(0)
        end.to change(Ticket, :count).by(0)
      end

      context 'denunciation' do
        let(:ticket) { create(:ticket, :denunciation) }

         it 'attributes' do
          expect(cloned_ticket.denunciation_organ_id).to eq(ticket.denunciation_organ_id)
          expect(cloned_ticket.denunciation_description).to eq(ticket.denunciation_description)
          expect(cloned_ticket.denunciation_date).to eq(ticket.denunciation_date)
          expect(cloned_ticket.denunciation_place).to eq(ticket.denunciation_place)
          expect(cloned_ticket.denunciation_assurance).to eq(ticket.denunciation_assurance)
          expect(cloned_ticket.denunciation_witness).to eq(ticket.denunciation_witness)
          expect(cloned_ticket.denunciation_evidence).to eq(ticket.denunciation_evidence)
          expect(cloned_ticket.denunciation_against_operator).to eq(ticket.denunciation_against_operator)
        end
      end
    end
  end
end
