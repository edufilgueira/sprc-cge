module User::Validations
  extend ActiveSupport::Concern

  # Regex constant
  REGEX_EMAIL_FORMAT = /\A[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-?\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+\z/
  REGEX_PASSWORD = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

  included do

    #  Validations

    ## Devise validatable override
    validates_presence_of   :email
    validates_uniqueness_of :email, allow_blank: true, conditions: -> { enabled }

    validates_presence_of     :password, if: :password_required?
    validates_confirmation_of :password, if: :password_required?
    validates_length_of       :password, within: Devise.password_length, allow_blank: true
    ## END Devise validatable override

    ## Presence

    validates :name,
      :user_type,
      :person_type,
      presence: true

    validates :document_type,
      presence: true,
      unless: -> { legal? || user_facebook? }

    validates :document,
      presence: true,
      unless: :user_facebook?

    validates :state,
      presence: true,
      if: -> { user? && !user_facebook? }

    validates :city,
      presence: true,
      if: -> { user? && !user_facebook? }

    ## Email confirmation

    validates :email,
      confirmation: true, if: -> { email_confirmation.present? }

    validates :email_confirmation,
      presence: true, if: :email_changed?

    ## Format

    validates :document,
      cpf: true, unless: :legal?, if: :cpf?

    validates :document,
      cnpj: true, if: :legal?

    validates_format_of :email, with: REGEX_EMAIL_FORMAT

    ## Operators

    validates :operator_type,
      presence: true,
      if: :operator?

    validates :organ,
      presence: true,
      if: -> { sectoral? || chief? }

    validates :department,
      presence: true,
      if: :internal?

    validates :subnet,
      presence: true,
      if: :subnet_operator?

    validates_presence_of :department, if: :sub_department_id?
    validates_presence_of :organ, if: -> { department_id? || subnet_id? }

    validate :validate_organ_department_association
    validate :validate_subnet_department_association
    validate :validate_deparment_subdepartment_association
    validate :validate_rede_ouvir,
      unless: -> { operator? && sou_sectoral? }

    validate :validate_organ_from_rede_ouvir, if: :rede_ouvir?

    validate :password_complexity

    validate :coordinator_always_in_couvi, if: :coordination?

  end

  private

  # Devise validatable override
  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
  ## END Devise validatable override

  def validate_organ_department_association
    return true if subnet_id.present? || department_id.blank? || organ_id.blank?
    errors.add(:department_id, :invalid_organ_association) unless department.organ_id == organ_id
  end

  def validate_deparment_subdepartment_association
    return true unless sub_department_id && department_id.present? && organ_id.present?

    errors.add(:sub_department_id, :invalid_department_association) unless sub_department.department_id == department_id
  end

  def validate_subnet_department_association
    return true if subnet_id.blank? || department_id.blank?

    errors.add(:department_id, :invalid_subnet_association) unless department.subnet_id == subnet_id
  end

  def validate_rede_ouvir
    errors.add(:rede_ouvir, :operator_type_sou) if rede_ouvir?
  end

  def validate_organ_from_rede_ouvir
    errors.add(:rede_ouvir, :executive_organ) unless organ.is_a?(::RedeOuvirOrgan)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ REGEX_PASSWORD
    errors.add :password, :password_complexity
  end

  def coordinator_always_in_couvi
    errors.add(:organ, :coordination_couvi_organ) unless organ_id == ExecutiveOrgan.ombudsman_coordination.id
  end
end