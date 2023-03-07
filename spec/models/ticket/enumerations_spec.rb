require 'rails_helper'

describe Ticket::Enumerations do

  subject(:ticket) { build(:ticket) }

  describe 'enums' do

    # tipo da resposta que o usuário deseja receber

    it 'answer_type' do
      answer_types = [:default, :phone, :letter, :email, :twitter, :facebook, :instagram, :presential, :whatsapp]

      is_expected.to define_enum_for(:answer_type).with_values(answer_types)
    end

    it 'denunciation_type' do
      denunciation_types = [:in_favor_of_the_state, :against_the_state]

      is_expected.to define_enum_for(:denunciation_type).with_values(denunciation_types)
    end

    # tipo do chamado: sou ou sic

    it 'ticket_type' do
      ticket_types = [:sic, :sou]

      is_expected.to define_enum_for(:ticket_type).with_values(ticket_types)
    end

    # tipo do chamado de ouvidoria (sou): reclamação, denúncia, elogio, ...

    it 'sou_type' do
      sou_types = [:complaint, :denunciation, :compliment, :suggestion, :request]

      is_expected.to define_enum_for(:sou_type).with_values(sou_types)
    end

    it 'status' do
      statuses = [:in_progress, :confirmed, :replied]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end

    it 'internal status' do
      statuses = {
        in_filling: 0,
        waiting_confirmation: 1,
        waiting_referral: 2,
        sectoral_attendance: 3,
        internal_attendance: 4,
        sectoral_validation: 5,
        cge_validation: 6,
        partial_answer: 7,
        final_answer: 8,
        invalidated: 9,
        # completed: 10,
        appeal: 11,
        awaiting_invalidation: 12,
        subnet_validation: 13,
        subnet_attendance: 14
      }

      is_expected.to define_enum_for(:internal_status).with_values(statuses)
    end

    it 'document_type' do
      document_types = {
        cpf: 0,
        rg: 2,
        cnh: 3,
        ctps: 4,
        passport: 5,
        voter_registration: 6,
        cnpj: 7,
        other: 1
      }

      is_expected.to define_enum_for(:document_type).with_values(document_types)
    end

    it 'person_type' do
      person_types = [:individual, :legal]

      is_expected.to define_enum_for(:person_type).with_values(person_types)
    end

    it 'denunciation_assurance' do
      assurances = {
        assured: 0,
        suspicion: 1,
        rumor: 2,
        legacy_assurance: -1
      }

      is_expected.to define_enum_for(:denunciation_assurance).with_values(assurances)
    end

    context 'used_inputs' do
      let(:used_inputs) do
        {
          phone: 0,
          system: 1,
          presential: 2,
          email: 3,
          facebook: 4,
          letter: 5,
          phone_155: 6,
          complaint_here: 7,
          consumer_gov: 8,
          instagram: 9,
          traveling_government: 10,
          suggestions_box: 11,
          legacy: -1,
          twitter: 12,
          ceara_app: 13
        }
      end

      it {
        is_expected.to define_enum_for(:used_input).with_values(used_inputs).with_suffix(:input)
      }

      context 'available_used_inputs' do
        let(:available_used_inputs) do
          used_inputs.reject { |_, value| value < 0 }.stringify_keys
        end

        it { expect(Ticket.available_used_inputs).to eq(available_used_inputs) }
      end
    end

    context 'answer_classification' do
      let(:answer_classifications) do
        {
          'sic_attended_personal_info'=>0,
          'sic_attended_rejected_partially'=>1,
          'sic_rejected_secret'=>2,
          'sic_rejected_need_work'=>3,
          # 'sic_rejected_reserved'=>4,
          'sic_rejected_personal_info'=>5,
          'sic_not_attended_info_unclear'=>6,
          'sic_not_attended_info_nonexistent'=>7,
          'sic_rejected_ultrasecret'=>8,
          'sic_rejected_generic'=>9,
          'sic_not_attended_other_organs'=>10,
          'sic_attended_active'=>11,
          'sic_attended_passive'=>12,
          'appeal_deferred'=>13,
          'appeal_rejected'=>14,
          'appeal_deferred_partially'=>15,
          'appeal_loss_object'=>16,
          'appeal_loss_object_partially'=>17,
          'appeal_not_allowed'=>18,
          'sou_demand_well_founded'=>19,
          'sou_demand_unfounded'=>20,
          'sou_well_founded_partially'=>21,
          'sou_could_not_verify'=>22,
          'sou_waitting_determination_result'=>23,
          'other_organs'=>24,
          'legacy_classification'=>-1
        }
      end

      it { is_expected.to define_enum_for(:answer_classification).with_values(answer_classifications) }

      context 'available_answer_classifications' do
        let(:available_answer_classifications) do
          answer_classifications.reject { |_, value| value < 0 }.stringify_keys
        end

        it { expect(Ticket.available_answer_classifications).to eq(available_answer_classifications) }
      end
    end

    it 'gender' do
      genders = [:not_informed_gender, :female, :male, :other_gender]

      is_expected.to define_enum_for(:gender).with_values(genders)
    end


    it 'call_center_status' do
      call_center_statuses = [
        :waiting_allocation,
        :waiting_feedback,
        :with_feedback
      ]

      is_expected.to define_enum_for(:call_center_status).with_values(call_center_statuses)
    end
  end

  describe 'helpers' do

    let(:ticket_denunciation) { build(:ticket, :denunciation) }
    let(:ticket_call_center) { build(:ticket, :call_center) }
    let(:ticket_sic) { build(:ticket, :sic) }

    context 'status_str' do
      it 'when nil' do
        ticket.status = nil
        expect(ticket.status_str).to eq('')
      end

      it 'when present' do
        expected = I18n.t("ticket.statuses.#{ticket.status}")
        expect(ticket.status_str).to eq(expected)
      end
    end

    context 'internal_status_str' do
      it 'when nil' do
        ticket.internal_status = nil
        expect(ticket.internal_status_str).to eq('')
      end

      it 'default behavior' do

        ticket.internal_status = :in_filling
        expected = Ticket.human_attribute_name("internal_status.#{ticket.internal_status}")
        expect(ticket.internal_status_str).to eq(expected)
      end

      it 'when :appeal' do
        ticket.internal_status = :appeal
        ticket.appeals = 1

        expected = Ticket.human_attribute_name("internal_status.appeal.1")
        expect(ticket.internal_status_str).to eq(expected)
      end

      it 'when sou reopened' do
        ticket.ticket_type = :sou
        ticket.internal_status = :sectoral_attendance
        ticket.reopened = 1

        expected = "[#{Ticket.human_attribute_name("reopened")}] #{Ticket.human_attribute_name("internal_status.sectoral_attendance")}"
        expect(ticket.internal_status_str).to eq(expected)
      end
    end

    context 'sou_type_str' do
      it 'when nil' do
        ticket.sou_type = nil
        expect(ticket.sou_type_str).to eq('')
      end

      it 'when present' do

        expected = I18n.t("ticket.sou_types.#{ticket.sou_type}")
        expect(ticket.sou_type_str).to eq(expected)
      end
    end

    context 'answer_type_str' do
      it 'when nil' do
        ticket.answer_type = nil
        expect(ticket.answer_type_str).to eq('')
      end

      it 'when present' do

        expected = I18n.t("ticket.answer_types.#{ticket.answer_type}")
        expect(ticket.answer_type_str).to eq(expected)
      end
    end

    context 'document_type_str' do
      it 'when nil' do
        ticket.document_type = nil
        expect(ticket.document_type_str).to eq('')
      end

      it 'when present' do

        ticket.document_type = :cpf
        expected = I18n.t("ticket.document_types.#{ticket.document_type}")
        expect(ticket.document_type_str).to eq(expected)
      end
    end

    context 'used_input_str' do
      it 'when nil' do
        ticket.used_input = nil
        expect(ticket.used_input_str).to eq('')
      end

      it 'when present' do

        expected = Ticket.human_attribute_name("used_input.#{ticket_call_center.used_input}")
        expect(ticket_call_center.used_input_str).to eq(expected)
      end
    end

    context 'person_type_str' do
      it 'when nil' do
        ticket.person_type = nil
        expect(ticket.person_type_str).to eq('')
      end

      it 'when present' do

        expected = Ticket.human_attribute_name("person_type.#{ticket_call_center.person_type}")
        expect(ticket_call_center.person_type_str).to eq(expected)
      end
    end

    context 'ticket_type_str' do
      it 'when nil' do
        ticket.ticket_type = nil
        expect(ticket.ticket_type_str).to eq('')
      end

      it 'when present' do

        expected = Ticket.human_attribute_name("ticket_type.#{ticket_call_center.ticket_type}")
        expect(ticket_call_center.ticket_type_str).to eq(expected)
      end
    end

    context 'answer_classification_str' do
      it 'when nil' do
        ticket.answer_classification = nil
        expect(ticket.answer_classification_str).to eq('')
      end

      it 'when present' do

        expected = I18n.t("ticket.answer_classifications.#{ticket_sic.answer_classification}")
        expect(ticket_sic.answer_classification_str).to eq(expected)
      end
    end

    context 'gender_str' do
      it 'when nil' do
        ticket.gender = nil
        expect(ticket.gender_str).to eq('')
      end

      it 'when present' do

        expected = I18n.t("ticket.genders.#{ticket.gender}")
        expect(ticket.gender_str).to eq(expected)
      end
    end
  end

end
