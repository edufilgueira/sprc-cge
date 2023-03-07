#
# Validações de Ticket
#

module Ticket::Validations
  extend ActiveSupport::Concern

  included do

    # Validations

    ## Presence

    validates :answer_phone,
      presence: true,
      if: :phone?

    validates :city,
      :answer_address_street,
      :answer_address_number,
      :answer_address_zipcode,
      :answer_address_neighborhood,
      presence: true,
      if: :letter?

    validates :city,
      :state,
      presence: true,
      if: -> { letter? || created_by_user? || sic_presential? },
      unless: :anonymous?

    validates :answer_twitter,
      presence: true,
      if: :twitter?

    validates :answer_facebook,
      presence: true,
      if: :facebook?

    validates :answer_instagram,
      presence: true,
      if: :instagram?

    validates :answer_whatsapp,
      presence: true,
      if: :whatsapp?

    validates :ticket_type,
      :reopened,
      :appeals,
      presence: true

    validates :answer_type,
      presence: true,
      unless: :anonymous?

    validates :description,
      presence: true,
      unless: :denunciation?

    validates :denunciation_description,
      presence: true,
      if: -> { denunciation? && !attendance_sou_forward? }

    validates :denunciation_date,
      :denunciation_place,
      :denunciation_assurance,
      :denunciation_witness,
      :denunciation_evidence,
      presence: true,
      if: :denunciation?

    validates :sou_type,
      presence: true,
      if: :sou?

    validates :person_type,
      presence: true,
      if: :identified?

    validates :organ,
      presence: true,
      unless: -> { unknown_organ? || attendance_unknown_organ? || denunciation? }

    validates :organ,
      presence: true,
      if: -> { (parent_id? || immediate_answer_for_child_or_parent_no_children?) && !is_attendance_with_no_characteristic? }

    validates :answers,
      presence: true,
      if: :immediate_answer_for_child_or_parent_no_children?

    validates :classification,
      presence: true,
      if: -> { classification_required }

    validates :subnet,
      presence: true,
      if: -> { organ_subnet? && (! unknown_subnet?) && (! denunciation?) }

    validates :name,
      presence: true,
      unless: -> { anonymous? || attendance_sic_completed? }

    validates :email,
      presence: true,
      if: :email?

    validates :document,
      presence: true,
      if: :sic?,
      unless: -> { anonymous? || attendance_sic_completed? }

    validates :deadline,
      :deadline_ends_at,
      presence: true,
      unless: :in_progress?

    #
    # Quando o campo justification está presente no form ele é
    # preenchido com '' ao invés de nil, assim é possível validar sua presença
    #
    validates :justification,
    presence: true,
    unless: -> { justification.nil? }

    ## Format

    validates :document,
      cpf: true, if: :valid_cpf?

    validates :document,
      cnpj: true, if: :valid_cnpj?

    validates_format_of :email, with: User::REGEX_EMAIL_FORMAT, allow_blank: true


    ## Uniqueness

    validates :protocol,
      uniqueness: true

    #
    # Validação para não haver tickets filhos com órgãos iguais
    #
    # 06/09/2018: Removendo :internal_status do scope pois isso permite
    # ter um filho com status :internal_attendance e outro
    # com :sectoral_attendance, ambos com o mesmo órgão.
    #
    validates_uniqueness_of :organ_id,
      scope: [:parent_id, :subnet_id],
      if: :parent_id?

    ## Parent id

    # validação para um ticket não ser pai dele mesmo e para um ticket filho não
    # possuir filhos
    validate :valid_parent_association,
      :valid_child_association,
      if: :parent_id?


    ## public ticket
    validate :valid_public_ticket,
      if: -> { public_ticket? && parent? }


    validate :sic_cannot_be_anonymous

    validate :subnet_has_valid_organ

    # Callbacks

    after_validation :ensure_ticket_department_uniqueness

    private

    def ensure_ticket_department_uniqueness
      return unless ticket_departments_present_and_not_subnet?

      ticket_departments.each do |ticket_department|
        next if ticket_department_persisted_or_not_repeated?(ticket_department)
        department_id = ticket_department.department_id

        errors['ticket_departments.department_id'] << { error: :taken, value: department_id }
        ticket_department.errors.add(:department_id, :taken)
      end
    end

    def ticket_department_persisted_or_not_repeated?(ticket_department)
      ticket_department.persisted? || !repeated_ticket_department?(ticket_department)
    end

    def repeated_ticket_department?(ticket_department)
      ticket_departments.any? do |td|
        td != ticket_department && td.department_id == ticket_department.department_id
      end
    end

    def ticket_departments_present_and_not_subnet?
      ticket_departments.present? && not_subnet?
    end

    def ticket_departments_present?
      ticket_departments.present?
    end

    def valid_cpf?
      individual? && cpf? && document.present?
    end

    def valid_cnpj?
      legal? && document.present?
    end

    def sic_cannot_be_anonymous
      # ticket SIC ou gerado de um atendimento 155 que informa SIC (encaminhado ou finalizado)
      return unless sic? || attendance&.sic?

      # XXX por ser um atributo boolean, estamos usando ':invalid' para evitar confusões de blank/present
      errors.add(:anonymous, :invalid) if anonymous?
    end

    def subnet_has_valid_organ
      errors.add(:subnet, :invalid) if subnet.present? and self.subnet.organ_id != self.organ_id
    end

    def immediate_answer_for_child_or_parent_no_children?
      immediate_answer? && (parent_no_children? || child?)
    end

    # Atendimento do tipo registro sic finalizado e sem caracteristica normalmente não possuem classificação
    def classification_required
      immediate_answer_for_child_or_parent_no_children? && !attendance_sic_completed?
    end

    def created_by_user?
      created_by.try(:user?)
    end

    def sic_presential?
      sic? && presential?
    end
  end

end
