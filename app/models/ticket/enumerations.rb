module Ticket::Enumerations
  extend ActiveSupport::Concern

  included do

    SIC_ANSWER_CLASSIFICATION_MAP = {
      "sic_attended_personal_info"=>0,
      "sic_attended_rejected_partially"=>1,
      "sic_rejected_secret"=>2,
      "sic_rejected_need_work"=>3,
      # "sic_rejected_reserved"=>4,
      "sic_rejected_personal_info"=>5,
      "sic_not_attended_info_unclear"=>6,
      "sic_not_attended_info_nonexistent"=>7,
      "sic_rejected_ultrasecret"=>8,
      "sic_rejected_generic"=>9,
      "sic_not_attended_other_organs"=>10,
      "sic_attended_active"=>11,
      "sic_attended_passive"=>12
    }

    APPEAL_ANSWER_CLASSIFICATION_MAP = {
      "appeal_deferred"=>13,
      "appeal_rejected"=>14,
      "appeal_deferred_partially"=>15,
      "appeal_loss_object"=>16,
      "appeal_loss_object_partially"=>17,
      "appeal_not_allowed"=>18
    }

    SOU_ANSWER_CLASSIFICATION_MAP = {
      "sou_demand_well_founded"=>19,
      "sou_demand_unfounded"=>20,
      "sou_well_founded_partially"=>21,
      "sou_could_not_verify"=>22,
      "sou_waitting_determination_result"=>23,
      "other_organs"=>24
    }

    # Para select na aba de respostas, item Percepcao apos o procedimento de apuracao preliminar
    SIC_ANSWER_CLASSIFICATION = SIC_ANSWER_CLASSIFICATION_MAP.keys

    # Para select na aba de respostas, item Percepcao apos o procedimento de apuracao preliminar
    SOU_ANSWER_CLASSIFICATION = SOU_ANSWER_CLASSIFICATION_MAP.keys

    # Para select na aba de respostas, item Percepcao apos o procedimento de apuracao preliminar
    APPEAL_ANSWER_CLASSIFICATION = APPEAL_ANSWER_CLASSIFICATION_MAP.keys

    ANSWER_CLASSIFICATION = SIC_ANSWER_CLASSIFICATION + APPEAL_ANSWER_CLASSIFICATION +
      SOU_ANSWER_CLASSIFICATION

    ANSWER_CLASSIFICATION_MAP = SIC_ANSWER_CLASSIFICATION_MAP
      .merge(APPEAL_ANSWER_CLASSIFICATION_MAP)
      .merge(SOU_ANSWER_CLASSIFICATION_MAP)
      .merge({'legacy_classification'=> -1})

    # tipo da resposta que o usuário deseja receber
    enum answer_type: [
      :default,
      :phone,
      :letter,
      :email,
      :twitter,
      :facebook,
      :instagram,
      :presential,
      :whatsapp
    ]

    # tipo do chamado: sou ou sic
    enum ticket_type: [:sic, :sou]

    # tipo do chamado de ouvidoria (sou): reclamação, denúncia, elogio, ...
    enum sou_type: [
      :complaint, :denunciation, :compliment, :suggestion, :request
    ]

    enum status: [:in_progress, :confirmed, :replied]

    INTERNAL_STATUSES_TO_LOCK_DEADLINE = [:partial_answer, :final_answer, :in_filling, :invalidated]
    INTERNAL_STATUSES_TO_ACTIVE_DEADLINE = [:waiting_referral, :appeal]

    enum internal_status: {
      # Em preenchimento
      in_filling: 0,
      # Aguardando confirmação
      waiting_confirmation: 1,
      # Aguardando encaminhamento
      waiting_referral: 2,
      # Em atendimento - setorial
      sectoral_attendance: 3,
      # Em atendimento - área interna
      internal_attendance: 4,
      # Em validação - setorial
      sectoral_validation: 5,
      # Em validação - CGE
      cge_validation: 6,
      # Finalizado Parcialmente
      partial_answer: 7,
      # Finalizado
      final_answer: 8,
      # Invalidado
      invalidated: 9,
      # completed: 10,
      # Recurso
      appeal: 11,
      # Em pedido de invalidação
      awaiting_invalidation: 12,
      # Em validação - sub-rede
      subnet_validation: 13,
      # Em atendimento - sub-rede
      subnet_attendance: 14
    }

    enum document_type: {
      cpf: 0,
      rg: 2,
      cnh: 3,
      ctps: 4,
      passport: 5,
      voter_registration: 6,
      cnpj: 7,
      other: 1
    }

    enum person_type: [:individual, :legal]

    enum used_input: {
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
      ceara_app: 13,
      whatsapp: 14

    }, _suffix: :input

    enum answer_classification: ANSWER_CLASSIFICATION_MAP

    enum gender: [:not_informed_gender, :female, :male, :other_gender]
    enum denunciation_type: [:in_favor_of_the_state, :against_the_state]


    enum call_center_status: [
      :waiting_allocation,
      :waiting_feedback,
      :with_feedback
    ]

    # Class methods

    def self.available_used_inputs
      used_inputs.reject { |_, value| value < 0 }
    end

    def self.available_answer_classifications
      answer_classifications.reject { |_, value| value < 0 }
    end

    # Helpers

    def status_str
      return "" unless status.present?

      I18n.t("ticket.statuses.#{status}")
    end

    def internal_status_str
      return "" unless internal_status.present?

      return Ticket.human_attribute_name("internal_status.#{internal_status}.#{appeals}") if appeal?

      reopened_internal_status_str(internal_status)
    end

    def reopened_internal_status_str(internal_status)
      reopened_str + Ticket.human_attribute_name("internal_status.#{internal_status}")
    end

    def sou_type_str
      return "" unless sou_type.present?

      I18n.t("ticket.sou_types.#{sou_type}")
    end

    def answer_type_str
      return "" unless answer_type.present?

      I18n.t("ticket.answer_types.#{answer_type}")
    end

    def document_type_str
      return "" unless document_type.present?

      I18n.t("ticket.document_types.#{document_type}")
    end

    def person_type_str
      return "" unless person_type.present?

      Ticket.human_attribute_name("person_type.#{person_type}")
    end

    def used_input_str
      return "" unless used_input.present?

      Ticket.human_attribute_name("used_input.#{used_input}")
    end

    def ticket_type_str
      return "" unless ticket_type.present?

      Ticket.human_attribute_name("ticket_type.#{ticket_type}")
    end

    def denunciation_assurance_str
      return "" unless denunciation_assurance.present?

      Ticket.human_attribute_name("denunciation_assurance.#{denunciation_assurance}")
    end

    def answer_classification_str
      return "" unless answer_classification.present?

      I18n.t("ticket.answer_classifications.#{answer_classification}")
    end

    def gender_str
      return "" unless gender.present?

      I18n.t("ticket.genders.#{gender}")
    end

    def reopened_str
      reopened? ?  "[#{Ticket.human_attribute_name("reopened")}] " : ""
    end
  end
end
