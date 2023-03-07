#
# Representa um usuário do sistema.
#
# Tipos de usuários:
#
#   - admin: usuário administrador geral da plataforma;
#
#   - user: usuário de ouvidoria/acesso a informação (cidadão cadastrado);
#
#   - operator: usuários das diversas ouvidorias e CGE, responsáveis por
#       responder e gerenciar os chamados;
#

require 'securerandom'

class User < ApplicationRecord
  include User::Scopes
  include User::Search
  include User::Validations
  include User::NotificationRoles
  include ::Sortable
  include ::Disableable

  # Setup

  acts_as_paranoid

  acts_as_messageable

  devise :database_authenticatable,
    :confirmable,
    :registerable,
    :recoverable,
    :rememberable,
    :token_authenticatable,
    :trackable,
    :omniauthable,
    omniauth_providers: [:facebook]

  attribute :internal_subnet, :boolean, default: false


  OPERATOR_TYPES_FOR_SOU_OPERATORS = [
    :sou_sectoral, :sic_sectoral, :internal, :subnet_sectoral
  ]

  OPERATOR_TYPES_FOR_SOU_OPERATORS_REDE_OUVIR = [
    :sou_sectoral
  ]

  OPERATOR_TYPES_FOR_SIC_OPERATORS = [
    :sic_sectoral, :internal
  ]

  OPERATOR_TYPES_FOR_CGE_OPERATORS = [
    :internal, :sou_sectoral, :sic_sectoral, :cge, :chief, :subnet_sectoral, :subnet_chief, :coordination
  ]

  OPERATOR_TYPES_FOR_SUBNET_OPERATORS = [
    :internal, :subnet_sectoral
  ]

  OPERATOR_TYPES_FOR_SECURITY_ORGANS = [
    :security_organ
  ]

  OPERATOR_TYPES_WITH_SUBNET = [
    :internal, :subnet_sectoral, :subnet_chief
  ]

  OPERATOR_TYPES_WITHOUT_DEPARTMENT = [
    :chief, :subnet_chief, :sou_sectoral, :sic_sectoral, :subnet_sectoral, :coordination
  ]

  OPERATOR_TYPES_WITHOUT_ORGAN = [
    :cge, :call_center, :call_center_supervisor
  ]

  # Associations

  belongs_to :organ
  belongs_to :department
  belongs_to :sub_department
  belongs_to :subnet
  belongs_to :city

  has_one :state, through: :city

  has_many :authentication_tokens
  has_many :tickets, foreign_key: :created_by_id, dependent: :destroy
  has_many :call_center_tickets, foreign_key: :call_center_responsible_id, class_name: 'Ticket'
  has_many :gross_exports, dependent: :destroy
  has_many :ticket_reports, dependent: :destroy
  has_many :solvability_reports, dependent: :destroy
  has_many :evaluation_exports, dependent: :destroy
  has_many :answer_templates, dependent: :destroy

  # PPA
  #
  has_many :ppa_proposals, class_name: 'PPA::Proposal'


  with_options dependent: :destroy do
    has_many :ppa_likes, class_name: 'PPA::Like'
    has_many :ppa_dislikes, class_name: 'PPA::Dislike'
    has_many :ppa_votes, class_name: 'PPA::Vote'
  end
  # PPA

  # Delegation

  delegate :name, :acronym, :subnet?, to: :organ, prefix: true, allow_nil: true
  delegate :name, :acronym, :organ_acronym, :organ, to: :department, prefix: true, allow_nil: true
  delegate :name, :acronym, to: :sub_department, prefix: true, allow_nil: true
  delegate :name, :acronym, :full_acronym, to: :subnet, prefix: true, allow_nil: true
  delegate :name, :title, :state_acronym, to: :city, prefix: true, allow_nil: true
  delegate :id, to: :state, prefix: true, allow_nil: true

  # Enums

  enum document_type: {
    cpf: 0,
    rg: 2,
    cnh: 3,
    ctps: 4,
    passport: 5,
    voter_registration: 6,
    cnpj: 7,
    other: 1,
    registration: 8
  }

  enum user_type: [:admin, :operator, :user]

  enum operator_type: {
    cge: 0,
    call_center_supervisor: 1,
    sou_sectoral: 2,
    internal: 3,
    call_center: 4,
    sic_sectoral: 5,
    # sic_internal: 6,
    chief: 7,
    subnet_sectoral: 8,
    subnet_chief: 9,
    coordination: 10,
    security_organ: 11

  }

  enum person_type: [:individual, :legal]

  enum gender: [:not_informed_gender, :female, :male, :other_gender]

  enum education_level: {
    # :incomplete_primary_school,
    primary_school: 1,
    # :imcomplete_high_school,
    high_school: 3,
    # :imcomplete_bachelors_degree,
    bachelors_degree: 5,
    # :imcomplete_postgraduate,
    postgraduate: 7
  }

  # Callback

  before_validation :coordination_without_denunciation_tracking, if: proc { |user|
    user.coordination? && !user.denunciation_tracking?
  }

  before_validation :set_cnpj_document_type, if: :legal?

  before_validation :ensure_rede_ouvir_or_executive, if: :organ_id_changed?

  before_validation :ensure_acts_as_sic

  before_validation :set_operator_type_cge, if: proc { |user|
    !user.coordination? && user.denunciation_tracking?
  }

  before_validation :set_user_type_operator, if: :denunciation_tracking?

  before_validation :set_nil_to_operator_type, if: proc { |user|
    user.admin? && user.user_type_was == 'operator'
  }

  before_validation :set_nil_to_organ, if: proc { |user|
    user.check_operator_on_list(OPERATOR_TYPES_WITHOUT_ORGAN)
  }

  before_validation :set_nil_to_department, if: proc { |user|
    user.check_operator_on_list(OPERATOR_TYPES_WITHOUT_DEPARTMENT)
  }

  before_validation :set_nil_to_subnet, unless: proc { |user|
    user.check_operator_on_list(OPERATOR_TYPES_WITH_SUBNET)
  }

  before_save :set_password_changed_at, if: proc { |user|
    user.password.present?
  }

  # Serializers

  serialize :notification_roles, Hash

  # Public

  ## Class methods

  # Sobreescrevendo o método de autenticação do Devise
  # para considerar apenas os usuários habilitados
  def self.find_for_authentication(tainted_conditions)
    find_first_by_auth_conditions(tainted_conditions, disabled_at: nil)
  end

  def self.default_sort_column
    'users.name'
  end

  def self.default_sort_direction
    :asc
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      if data.present?
        user.email = data["email"] if user.email.blank?
        user.name = data['name'] if user.name.blank?
      end
    end
  end

  ## Instance methods

  ### Password

  #
  # Um password seguro, randômico e indedutível para criações de usuário sem definição de senha.
  # Isso deve apoiar a criação de usuários administrativos, dado que, ao "confirmar" sua conta,
  # uma nova senha será requisitada a eles.
  #
  def assign_secure_random_password
    self.password = self.password_confirmation = SecureRandom.hex + "Aa1!"
  end

  def mailboxer_email(_object)
    email
  end

  ### Helpers

  def title
    return social_name unless social_name.blank?

    name
  end

  #
  # Representação textual do usuário para uso com semântica de "autor". Assim, além do "nome" que
  # o identifica, pode-se adicionar outras informações (como "perfil" e "órgão associado" para Operadores).
  #
  def as_author
    return nil if user_type.blank?

    # isolando construções por tipo de usuário
    send("#{user_type}_as_author")
    # Isso é o mesmo que:
    # ```ruby
    # case user_type&.to_sym
    # when :admin    then admin_as_author
    # when :operator then operator_as_author
    # when :user     then user_as_author
    # end
    # ```
  end

  def operator_type_str
    return "" unless operator_type.present?

    return I18n.t('user.operator_types.cge_denunciation_tracking') if denunciation_tracking? && !coordination?

    I18n.t("user.operator_types.#{operator_type}")
  end

  def document_type_str
    return "" unless document_type.present?

    I18n.t("user.document_types.#{document_type}")
  end

  def gender_str
    return "" unless gender.present?

    I18n.t("user.genders.#{gender}")
  end

  def education_level_str
    return "" unless education_level.present?

    I18n.t("user.education_levels.#{education_level}")
  end

  def sectoral?
    sou_sectoral? || sic_sectoral?
  end

  def sou_operator?
    sou_sectoral? || internal?
  end

  def sic_operator?
    sic_sectoral? || internal?
  end

  def operator_cge_or_sectoral_or_chief_or_coordination?
    cge? || sectoral? || chief? || coordination?
  end

  def operator_subnet_or_sectoral_or_chief_or_coordination?
    sectoral? || chief? || subnet_operator? || coordination?
  end

  def sectoral_or_internal?
    sectoral? || internal?
  end

  def subnet_operator?
    subnet_sectoral? || subnet_chief?
  end

  def subnet_internal?
    internal? && internal_subnet
  end

  def operator_chief?
    chief? || subnet_chief?
  end

  def call_center_operator?
    call_center? || call_center_supervisor?
  end

  def sectoral_rede_ouvir?
    rede_ouvir?
  end

  def operator_coordination?
    coordination?
  end

  def operator_security_organ?
    security_organ?
  end

  def ombudsman?
    # Se é Ouvidor (operador sic/sou) ou operador subrede
    sectoral? || subnet_sectoral?
  end

  def namespace
    case user_type.to_sym
    when :user
      :platform
    when :operator
      :operator
    when :admin
      :admin
    end
  end

  def user_facebook?
    provider == 'facebook'
  end

  def operator_denunciation?
    (cge? || coordination?) && denunciation_tracking?
  end

  def organ_or_department_organ_acronym
    if department.present?
      subnet.present? ? organ_subnet_and_department : organ_and_department
    elsif subnet.present?
      organ_and_subnet
    else
      organ_acronym
    end
  end


  # mecanismo para forçar a necessidade de preenchimento de senha
  def require_password!
    @force_password_required = true
  end

  def force_password_required?
    @force_password_required
  end

  def permission_to_answer?(ticket)
    cge? || coordination? || (sectoral? && organ_id == ticket.organ_id) || (subnet_sectoral? && subnet_id == ticket.subnet_id)
  end

  def permission_to_show_organs_on_reports?
    coordination? || cge? || call_center_operator?
  end

  protected

  # override
  # Devise method
  def password_required?
    force_password_required? || super
  end

  # override
  # Devise mailer method
  def devise_mailer
    DeviseUserMailer
  end

  def check_operator_on_list list_of_operator_types
    operator? && operator_type.try(:to_sym).in?(list_of_operator_types)
  end

  # Private

  private

  # Representação textual de usuário para Administradores
  # => "[Administrador] Maria da Penha"
  def admin_as_author
    "[#{user_type_str}] #{title}"
  end

  #
  # Representação textual do "perfil" e órgão/departamento do Operador
  #
  # ex:
  #   - #cge?          => "[Operador CGE] João da Silva"
  #   - #call_center?  => "[Atendente 155] João da Silva"
  #   - #sic_sectoral? => "[ADAGRI - Operador setorial SIC] João da Silva"
  def operator_as_author
    return nil unless operator?

    # casos como #cge? e #call_center*? não têm #organ, então vamos rejeitar blanks.
    role_description = [organ_or_department_organ_acronym, operator_type_str].reject(&:blank?).join(' - ')

    "[#{role_description}] #{title}"
  end

  # Representação textual de usuário para Cidadãos
  # => "João dos Santos"
  def user_as_author
    title
  end

  def organ_and_department
    "#{department.organ_acronym} - #{department_acronym}"
  end

  def organ_and_subnet
    "#{organ_acronym} - #{subnet_acronym}"
  end

  def organ_subnet_and_department
    "#{organ_acronym} - #{subnet_acronym} - #{department_acronym}"
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def set_cnpj_document_type
    self.document_type = :cnpj
  end

  def ensure_acts_as_sic
    self.acts_as_sic = false unless sou_sectoral?
  end

  def ensure_rede_ouvir_or_executive
    self.rede_ouvir = from_rede_ouvir? && operator_types_rede_ouvir?
  end

  def from_rede_ouvir?
    organ.is_a?(::RedeOuvirOrgan)
  end

  def operator_types_rede_ouvir?
    sou_sectoral? || chief?
  end

  def set_user_type_operator
    self.user_type = :operator
  end

  def set_operator_type_cge
    self.operator_type = :cge
    set_nil_to_organ
  end

  def set_nil_to_operator_type
    self.operator_type = nil
  end

  def set_nil_to_organ
    self.organ_id = nil
    set_nil_to_department
  end

  def set_nil_to_department
    self.department_id = nil
    self.sub_department_id = nil
  end

  def set_nil_to_subnet
    self.subnet_id = nil
  end

  def set_password_changed_at
    self.password_changed_at = Time.current
  end

  def coordination_without_denunciation_tracking
    self.denunciation_tracking = true
  end
end
