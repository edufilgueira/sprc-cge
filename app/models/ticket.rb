#
# Representa um chamado do sistema (ouvidoria ou acesso à informação).
#
# Esse model também é utilizado para login com protocol/senha.
#

class Ticket < ApplicationRecord
  include ::Denunciable
  include ::Sortable
  include ::ProtectedAttachment
  include Ticket::Authentications
  include Ticket::Enumerations
  include Ticket::Scopes
  include Ticket::Search
  include Ticket::Validations
  include Ticket::TicketLogsAnswersAndComments
  include Ticket::RedeOuvirOrgan

  # Constants

  # prazo fixado para que o ouvidor responda um chamado.
  # elaborar um mecanismo que o administrador configure este prazo
  SIC_DEADLINE = 20
  SIC_EXTENSION_DAYS = 10
  SIC_EXTENSION = SIC_DEADLINE + SIC_EXTENSION_DAYS

  SOU_DEADLINE = 20
  SOU_EXTENSION_DAYS = 10
  SOU_EXTENSION = SOU_DEADLINE + SOU_EXTENSION_DAYS

  LIMIT_TO_EXTEND_DEADLINE = 30

  CGE_SHARE_DEADLINE = 5

  FILTER_DEADLINE = {
    not_expired: 0..Float::INFINITY,
    expired_can_extend: -Float::INFINITY..-1,
    expired: -Float::INFINITY..-1
  }

  INACTIVE_STATUSES = [:in_filling, :invalidated, :final_answer]

  INACTIVE_STATUS_FOR_PARTIAL_RESPONSE = INACTIVE_STATUSES + [:partial_answer]

  INACTIVE_NOT_ANSWERED_STATUSES = INACTIVE_STATUSES - [:final_answer]

  INVALIDATED_STATUSES = [ :invalidated ]

  SIC_ATTENDED = [
    :sic_attended_personal_info,
    :sic_attended_rejected_partially,
    :sic_attended_active,
    :sic_attended_passive
  ]

  STATUSES_FOR_CITIZEN = [:active, :inactive]

  # Parametros permitidos para compartilhamento.
  # Parametro precisa estar dentro do formulario para ser compartilhado por aqui
  # Customizacao se nao vier do formulario deve ser feita diretamente no servico Ticket::Sharing
  PERMITTED_PARAMS_FOR_SHARE = [
    :id,
    :rede_ouvir,
    :organ_id,
    :subnet_id,
    :unknown_subnet,
    :description,
    :sou_type,
    :denunciation_organ_id,
    :denunciation_description,
    :denunciation_date,
    :denunciation_place,
    :denunciation_witness,
    :denunciation_evidence,
    :denunciation_assurance,
    :justification,
    protected_attachment_ids: []
  ]

  PERMITTED_PARAMS_FOR_SHARE_TO_REDE_OUVIR = PERMITTED_PARAMS_FOR_SHARE - ['organ_id', 'subnet_id', 'unknown_subnet']

  # Setup

  acts_as_paranoid

  acts_as_messageable

  # Associations

  belongs_to :organ
  belongs_to :citizen_topic, class_name: :Topic
  belongs_to :subnet
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  belongs_to :call_center_responsible, class_name: 'User'
  belongs_to :parent, class_name: 'Ticket', touch: true
  belongs_to :denunciation_organ, class_name: 'Organ'
  belongs_to :city
  belongs_to :target_city, class_name: :City

  has_many :attachments, dependent: :destroy, as: :attachmentable
  has_many :tickets, dependent: :destroy, foreign_key: 'parent_id'
  has_many :ticket_departments, dependent: :destroy
  has_many :extensions, dependent: :destroy
  has_many :ticket_subscriptions, dependent: :destroy
  has_many :attendance_responses, dependent: :destroy
  has_many :ticket_subscriptions_confirmed, -> { where(confirmed_email: true) }, class_name: 'TicketSubscription', dependent: :destroy
  has_many :subscribers, through: :ticket_subscriptions_confirmed, source: :user
  has_many :ticket_protect_attachments, as: :resource, dependent: :destroy
  has_many :sou_evaluation_sample_details, class_name: 'Operator::SouEvaluationSampleDetail', dependent: :destroy

  has_one :attendance, inverse_of: :ticket, dependent: :destroy
  has_one :attendance_evaluation, dependent: :destroy
  has_one :classification, inverse_of: :ticket, dependent: :destroy
  has_one :state, through: :city
  has_one :target_state, through: :target_city, class_name: :State, source: :state

  # Attachments

  accepts_attachments_for :attachments, append: true

  # Nesteds

  accepts_nested_attributes_for :attachments, reject_if: :attachment_blank?, allow_destroy: true
  accepts_nested_attributes_for :ticket_departments
  accepts_nested_attributes_for :tickets
  accepts_nested_attributes_for :classification

  # Attributes

  attr_accessor :justification

  # Delegations

  delegate :service_type, :unknown_organ?, :completed?, to: :attendance, prefix: true, allow_nil: true
  delegate :name, :acronym, :full_acronym, :subnet?, to: :organ, prefix: true, allow_nil: true
  delegate :name, :acronym, :full_acronym, :title, to: :unit, prefix: true, allow_nil: true
  delegate :average_attendance_evaluation, to: :organ, prefix: true, allow_nil: true
  delegate :name, :acronym, to: :denunciation_organ, prefix: true, allow_nil: true
  delegate :name, to: :call_center_responsible, prefix: true, allow_nil: true
  delegate :name, :title, :state_acronym, to: :city, prefix: true, allow_nil: true
  delegate :id, to: :state, prefix: true, allow_nil: true
  delegate :other_organs, to: :classification, allow_nil: true
  delegate :ignore_cge_validation, to: :organ, prefix: true, allow_nil: true
  delegate :acronym, :full_acronym, :ignore_sectoral_validation, to: :subnet, prefix: true, allow_nil: true
  delegate :organ, :department_organ, to: :updated_by, prefix: true, allow_nil: true
  delegate :disabled_at, to: :organ, prefix: true, allow_nil: true
  delegate :title, to: :target_city, prefix: true, allow_nil: true
  delegate :public_ticket, to: :parent, prefix: true, allow_nil: true

  # Attributes


  # Callbacks

  before_validation :clear_organ_if_unknown_organ
  before_validation :clear_subnet_if_unknown_subnet
  before_validation :clear_classification_if_unknown_classification
  before_validation :set_cnpj_document_type, if: :legal?
  before_validation :set_answer_type_default, if: :anonymous?

  before_create :define_decrement_deadline

  # Atendimento pode criar uma manifestacao com resposta final já definida por isso deve ser um before_save
  before_save :update_decrement_deadline, if: -> { internal_status_changed? || reopened_changed? }
  before_create :define_marked_internal_evaluation

  after_create :create_parent_protocol
  after_create :create_pseudo_reopen_ticket_log

  after_commit :update_parent_published, if: :parent?
  after_update :update_ticket_departments_status, if: :ticket_departments_present?

  # Public

  ## Class methods

  def cge?
    organ_id == 14
  end

  def self.within_share_deadline?(reference_date)
    reference_date = reference_date.to_date
    days_to_share = Holiday.next_weekday(Ticket::CGE_SHARE_DEADLINE, reference_date)
    deadline_to_share = reference_date + days_to_share

    Date.today <= deadline_to_share
  end

  def self.default_sort_column
    'tickets.parent_protocol'
  end

  def self.default_sort_direction
    :asc
  end

  ### Helpers

  def self.response_deadline(ticket_type = :sou)
    ticket_type.to_sym == :sic ? SIC_DEADLINE : SOU_DEADLINE
  end

  def self.response_extension(ticket_type = :sou)
    ticket_type.to_sym == :sic ? SIC_EXTENSION : SOU_EXTENSION
  end

  def self.response_extension_days(ticket_type = :sou)
    ticket_type.to_sym == :sic ? SIC_EXTENSION_DAYS : SOU_EXTENSION_DAYS
  end

  ## Instance methods

  ### Scopes

  def sorted_tickets
    tickets.order(parent_protocol: :asc, confirmed_at: :asc)
  end

  def children_from_executive_power
    tickets.where.not(organ_id: nil, rede_ouvir: true)
  end

  ### Helpers

  #
  # Representação textual do usuário criador do ticket, com semântica de "autor" para usar, por
  # exemplo, quando fizer "comentários".
  # Se o usuário criador for autenticado, apoia-se em `User#as_author`, que tem a mesma semântica.
  # Senão - pois é possível criar Ticket sem "conta registrada" - usa os atributos identificadores
  # do Ticket.
  #
  def as_author
    if anonymous? # usuário não registrado e anônimo
      I18n.t('messages.comments.anonymous_user')
    elsif identified? # usuário não registrado mas identificado
      social_name.present? ? social_name : name
    elsif from_registered_user? # criado por usuário registrado -> #created_by
      created_by.as_author
    end
  end


  def unit
    subnet? ? subnet : organ
  end

  def create_ticket_child
    # Só devemos criar ticket filho se estiver relacionado a um órgão com
    # subrede e com department. Se o órgão selecionado for subrede, o ticket
    # associado a ele é considerado o pai.
    return unless organ.present?

    ticket_child = self.dup
    ticket_child.protocol = nil
    ticket_child.created_by = nil

    ticket_child.internal_status = :subnet_attendance if subnet.present? && sectoral_attendance?

    ticket_child.classification = self.classification
    ticket_child.unknown_classification = self.classification.blank?
    ticket_child.parent = self
    ticket_child.public_ticket = false

    if self.immediate_answer?
      immediate_answer = self.answers.first
      ticket_child.answers << immediate_answer
    end

    ticket_child.save

    register_child_creation_logs(ticket_child)

    create_immediate_answer_for_child(ticket_child)

    self.update_attributes(default_parent_attributes_after_create_child)
  end

  def register_child_creation_logs(child)
    created_by = self.created_by || self
    register_priority_log(child, created_by)
    register_share_log(self, child, created_by)
    register_classification_log(child, created_by)
  end

  def register_share_log(parent, child, created_by)
    RegisterTicketLog.call(parent, created_by, :share, { resource: child.organ })
  end

  def register_classification_log(ticket, created_by)
    return unless ticket.classified?
    RegisterTicketLog.call(ticket, created_by, :create_classification, { resource: ticket })
    RegisterTicketLog.call(ticket.parent, created_by, :create_classification, { resource: ticket }) if ticket.child?
  end

  def register_priority_log(ticket, created_by)
    return unless ticket.priority?
    RegisterTicketLog.call(ticket, created_by, :priority, { resource: ticket })
  end

  def create_immediate_answer_for_child(ticket_child)
    return unless ticket_child.immediate_answer?
    answer = ticket_child.answers.first
    Answer::CreationService.call(answer, created_by)
  end

  def title
    I18n.t("ticket.protocol_title.#{ticket_type}", protocol: parent_protocol)
  end

  # data limite para que o ouvidor responda o chamado
  def response_deadline
    in_progress? ? '-' : I18n.l(deadline_ends_at)
  end

  # número de dias restantes para o ouvidor responder o chamado
  def remaining_days_to_deadline
    deadline_ends_at ? (deadline_ends_at - Date.today).to_i : '-'
  end

  def child?
    parent_id?
  end

  # Verifica se o ticket é pai
  def parent?
    parent_id.blank?
  end

  def shared?
    parent = self.parent || self
    tickets = parent.tickets.not_invalidated
    tickets.present? && tickets.count > 1
  end

  def no_active_children?
    active_tickets.blank?
  end

  def all_active_children_classified?
    parent = parent || self

    return parent.classified? if parent.no_active_children?
    parent.tickets.active.all?(&:classified)
  end

  def any_children_classified?
    tickets.exists?(classified: true)
  end

  def no_children?
    tickets.blank?
  end

  def no_answers?
    answers.blank?
  end

  # Ticket foi criado por um usuário não registrado mas que se identificou?
  # - Ou pode ter sido criado por um Operador, representando o usuário (Ex: Atendimento 155)
  def identified?
    !anonymous? && (created_by.blank? || created_by&.operator?)
  end

  # Ticket foi criado por um usuário registrado?
  def from_registered_user?
    created_by&.user?
  end

  def access_type
    anonymous? ? 'anonymous' : 'identified'
  end

  def mailboxer_email(_object)
    email
  end

  def elegible_to_answer?(user = nil)
    not_blocked = ! statuses_blocked_for_answer?

    (classified? || free_user_classification(user)) && not_blocked
  end

  def parent_no_active_children?
    parent? && no_active_children?
  end

  def parent_no_children?
    parent? && no_children?
  end

  # Verifica se o ticket está em um status que pode ser respondido
  def statuses_blocked_for_answer?
    parent_statuses_blocked_for_answer? || child_statuses_blocked_for_answer?
  end

  def ticket_department_by_user(user)
    ticket_departments.find_by(department: user.department)
  end

  def elegible_organ_to_second_extension?
    tickets_organ_extension_approved.present? &&
    tickets_organ_extension_in_progress(2).empty? &&
    tickets_organ_extension_approved(2).empty?
  end

  def elegible_organ_to_extension?
    tickets_organ_extension_approved.empty? && tickets_organ_extension_in_progress.empty?
  end

  def elegible_organ_to_cancel_extension?
    tickets_organ_extension_approved.empty? && tickets_organ_extension_in_progress.present?
  end

  def elegible_organ_to_approve_reject_or_cancel_second_extension?
    tickets_organ_extension_approved(2).empty? && tickets_organ_extension_in_progress(2).present?
  end

  def elegible_to_approve_extension?
    tickets_organ_extension_approved.empty?
  end

  def elegible_to_reject_extension?
    elegible_to_approve_extension?
  end

  def has_extension_organ_in_progress?
    extension_organ_in_progress.present?
  end

  def extension_organ_in_progress(solicitation=1)
    tickets_organ_extension_in_progress(solicitation).last&.extensions&.last
  end

  def tickets_organ_extension_approved(solicitation=1)
    tickets_organ_extensions.where(extensions: { status: :approved, solicitation: solicitation })
  end

  def tickets_organ_extension_in_progress(solicitation=1)
    tickets_organ_extensions.where(organ: organ, extensions: { status: :in_progress, solicitation: solicitation })
  end

  def tickets_organ_extensions
    base_date = reopened_at || confirmed_at
    joins_tickets_extensions.where("extensions.updated_at > ?", base_date)
  end

  def ticket_logs_reopened_by_range date_range=nil
    if date_range.present?
      ticket_logs.where(action: [:reopen, :pseudo_reopen], created_at: date_range)
    else
      ticket_logs.where(action: [:reopen, :pseudo_reopen])
    end
  end

  def average_days_spent_to_answer date_range=nil
    return 0 if confirmed_at.blank?

    if reopened_at.present?
      ticket_logs_reopeneds = ticket_logs_reopened_by_range(date_range)
      average_ticket_time_with_reopening = 0

      total_reopening_answered = 0
      ticket_logs_reopeneds.each do |ticket_log_reopened|
        reopening_answer = answers.where(version: ticket_log_reopened.data[:count]).approved_for_citizen.first

        next if reopening_answer.blank?
        total_reopening_answered += 1
        average_ticket_time_with_reopening += (reopening_answer.created_at.to_date - ticket_log_reopened.created_at.to_date).to_i
      end

      total_of_versions = total_reopening_answered
      total_of_versions += 1 if first_version_answer.present?
      total_of_versions += 1 if pseudo_reopen?

      return first_version_time_in_days_count if total_of_versions.zero?

      (first_version_time_in_days_count + average_ticket_time_with_reopening + reopen_pseudo_time_in_days) / total_of_versions

    elsif final_answer? || partial_answer?
      # date_range ja foi filtrado pelo filtro de escopo nos relatorios
      first_version_time_in_days_count
    else
      0
    end
  end

  def reopened_without_organ?
    reopened? && parent? && no_children?
  end

  # Retorna a quantidade de dias que durou uma pseudo reabertura
  # Pseudo reabertura trata de uma manifestacao compartilhada com um orgao somente apos a reabertura dessa manifestacao
  # O ticket com pseudo reabertura nao vem com ticket_log :reopen, mas com :pseudo_reopen
  # Esse metodo se faz necessario para conseguir calcular corretamente o tempo gasto de um ticket
  # So ha uma pseudo reabertura por ticket
  def reopen_pseudo_time_in_days
    ticket_logs_reopened_versions = ticket_logs.reopen.pluck(:data).pluck(:count).uniq

    answers.approved_for_citizen.where.not(version: 0).each do |answer|
      if ticket_logs_reopened_versions.exclude? answer.version
        return (answer.created_at.to_date - confirmed_at.to_date).to_i
      end
    end

    # Se o ticket nao tem pseudo reabertura ira retornar 0 dias de pseudo reabertura
    0
  end

  def first_version_answer
    answers.where(version: 0).approved_for_citizen.allowing_final_answer_scope.first
  end

  def first_version_time_in_days_count
    if first_version_answer.present?
      (first_version_answer.created_at.to_date - confirmed_at.to_date).to_i
    else
      0
    end
  end

  def joins_tickets_extensions
    parent? ? tickets.joins(:extensions) : parent.tickets.joins(:extensions)
  end

  def expired?
    deadline.present? && deadline < 0
  end

  # Somente SIC estão liberados para ser públicos até a decisão da CGE
  def eligible_to_publish?
    # !anonymous? && !denunciation?
    sic?
  end

  def subnet?
    (organ_subnet? && subnet.present?)
  end

  def next_extension_number
    if extended?
      2
    else
      1
    end
  end

  def not_subnet?
    subnet.blank?
  end

  def reset_deadline
    self.confirmed_at = DateTime.now
    set_deadline
  end

  def set_deadline
    deadline = Ticket.response_deadline(ticket_type)
    weekday = Holiday.next_weekday(deadline)

    self.deadline = weekday
    self.deadline_ends_at = Date.today + weekday
  end

  def organ_can_be_evaluated?
    replied? && final_answer? && no_children? && organ.present?
  end

  def open?
    !self.final_answer? && !self.invalidated?
  end

  def active?
    return false if self.internal_status.nil?

    ! INACTIVE_STATUSES.include?(self.internal_status.to_sym)
  end

  def last_evaluation_average
    last_answer = answers.user_evaluated.last

    return if last_answer.blank?

    last_answer.evaluation_average
  end

  def can_ignore_cge_validation?
    !denunciation? && organ_ignore_cge_validation
  end

  # Checa se a manifestação já passou da data limite de prorrogação
  def can_extend_deadline?
    base_date = reopened_at || confirmed_at
    return false unless base_date.present?

    timeout_to_request_extension = Holiday.next_weekday(LIMIT_TO_EXTEND_DEADLINE, base_date)

    (Date.today - base_date.to_date ).to_i <= timeout_to_request_extension
  end

  def is_attendance_with_no_characteristic?
    Ticket.with_attendances_no_characteristic.present?
  end

  # Private

  private

  ## Callbacks

  def define_marked_internal_evaluation
    self.marked_internal_evaluation = false
  end

  def clear_organ_if_unknown_organ
    self.organ = nil if unknown_organ?
  end

  def clear_subnet_if_unknown_subnet
    self.subnet = nil if unknown_subnet?
  end

  def clear_classification_if_unknown_classification
    self.classification = nil if unknown_classification? && !classified?
  end

  def define_decrement_deadline
    # Quando uma manifestação é criada por um atendimento através do serviço sic_completed o decrement_deadline 
    # vem setado no filho atraves da função .dup e é criado com o internal_status setado como finalizado.
    self.decrement_deadline = true if self.decrement_deadline.nil?
  end

  def update_decrement_deadline
    if internal_status.to_sym.in? INTERNAL_STATUSES_TO_LOCK_DEADLINE
      self.decrement_deadline = false
    elsif internal_status.to_sym.in?(INTERNAL_STATUSES_TO_ACTIVE_DEADLINE) || reopened_changed?
      self.decrement_deadline = true
    end
  end

  def create_pseudo_reopen_ticket_log
    if parent.blank? || parent.reopened.zero?
      pseudo_reopen = false
    else
      ticket_logs.create(
        action: :pseudo_reopen, description: justification,
        responsible: created_by, data: { count: reopened }
      )

      pseudo_reopen = true
    end

    self.update_column(:pseudo_reopen, pseudo_reopen)
  end

  def create_parent_protocol
    parent = self.parent || self

    self.update_column(:parent_protocol, parent.reload.protocol)
  end

  def update_parent_published
    self.update_column(:published, can_be_published?)
  end

  def update_ticket_departments_status
    if self.final_answer?
      self.ticket_departments.each do |ticket_department|
        ticket_department.answered! if ticket_department.not_answered?
      end
    end
  end

  ## attributes nested reject_if custom method

  def attachment_blank?(attributes)
    attributes['document'] == '{}'
  end

  ## validates invalid parent association

  def valid_parent_association
    errors.add(:parent, :parent_association) if self.id == self.parent_id
  end

  def valid_child_association
    errors.add(:parent, :child_association) unless self.tickets.blank?
  end

  def valid_public_ticket
    errors.add(:public_ticket, :invalid) unless eligible_to_publish?
  end

  def parent_attendance_service_type
    parent? ? attendance_service_type : parent.attendance_service_type
  end

  def attendance_sic_completed?
    parent_attendance_service_type.present? && parent_attendance_service_type.to_sym == :sic_completed
  end

  def attendance_sou_forward?
    parent_attendance_service_type.present? && parent_attendance_service_type.to_sym == :sou_forward
  end

  def free_user_classification(user = nil)
    user.present? && (user.internal? || user.cge?)
  end

  def parent_statuses_blocked_for_answer?
    parent? && (final_answer? || cge_validation?)
  end

  def child_statuses_blocked_for_answer?
    child? && !sectoral_attendance? && !internal_attendance? &&
    child_sectoral_validation_blocked? && !partial_answer? && !subnet_attendance? && !subnet_validation?
  end

  def child_sectoral_validation_blocked?
    !sectoral_validation? || (sectoral_validation? && subnet?)
  end

  def active_tickets
    tickets.where.not(internal_status: INACTIVE_STATUSES)
  end

  def set_cnpj_document_type
    self.document_type = :cnpj
  end

  def set_answer_type_default
    self.answer_type = :default
  end

  def parent_classified_not_other_organs
    parent? && classified? && !other_organs
  end

  def can_be_published?
    public_ticket && (parent_classified_not_other_organs || tickets.exists?(public_ticket: true))
  end

  def default_parent_attributes_after_create_child
    {
      classification: nil,
      denunciation_type: nil,
      classified: false,
      organ_id: nil,
      unknown_organ: true,
      subnet_id: nil,
      unknown_subnet: true
    }
  end
end