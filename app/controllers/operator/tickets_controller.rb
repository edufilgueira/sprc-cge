class Operator::TicketsController < OperatorController
  include Operator::Tickets::Breadcrumbs
  include Tickets::BaseController
  include ::Classifications::BaseController

  SOU_SORT_COLUMNS = [
    'tickets.confirmed_at',
    'tickets.deadline',
    'ticket_departments.deadline',
    'tickets.name',
    'tickets.parent_protocol',
    'tickets.sou_type',
    'tickets.internal_status'
  ]

  SIC_SORT_COLUMNS = [
    'tickets.confirmed_at',
    'tickets.deadline',
    'ticket_departments.deadline',
    'tickets.name',
    'tickets.parent_protocol',
    'tickets.internal_status'
  ]

  load_resource except: :create
  authorize_resource except: :index

  PERMMITED_CLASSIFICATION_PARAMS = [
    :topic_id,
    :subtopic_id,
    :department_id,
    :sub_department_id,
    :budget_program_id,
    :service_type_id,
    :other_organs
  ]

  PERMITTED_PARAMS = [
    :name,
    :email,
    :social_name,
    :gender,
    :description,
    :sou_type,
    :organ_id,
    :subnet_id,
    :unknown_organ,
    :unknown_subnet,
    :unknown_classification,
    :status,
    :used_input,
    :used_input_url,
    :priority,

    :answer_type,
    :answer_phone,
    :answer_cell_phone,

    :city_id,
    :answer_address_street,
    :answer_address_number,
    :answer_address_zipcode,
    :answer_address_neighborhood,
    :answer_address_complement,
    :answer_twitter,
    :answer_facebook,
    :answer_instagram,
    :answer_whatsapp,

    :target_address_zipcode,
    :target_city_id,
    :target_address_street,
    :target_address_number,
    :target_address_neighborhood,
    :target_address_complement,

    :document_type,
    :document,
    :person_type,

    :anonymous,

    :denunciation_organ_id,
    :denunciation_description,
    :denunciation_date,
    :denunciation_place,
    :denunciation_witness,
    :denunciation_evidence,
    :denunciation_assurance,
    :immediate_answer,

    attachments_attributes: [
      :id, :document, :_destroy
    ],

    classification_attributes: PERMMITED_CLASSIFICATION_PARAMS,
    answers_attributes: Answer::OPERATOR_PERMITTED_PARAMS
  ]

  USER_INFO_PARAMS = [
    :name,
    :social_name,
    :gender,
    :document_type,
    :document,
    :email,
    :answer_phone,
    :answer_address_street,
    :answer_address_number,
    :answer_address_zipcode,
    :answer_address_complement,
    :answer_address_neighborhood,
    :answer_cell_phone,
    :answer_twitter,
    :answer_facebook,
    :city_id,
    :answer_instagram
  ]

  helper_method [:classification, :justification]

  before_action :build_attendance_evaluation, only: :show

  before_action :can_access_index,
    only: :index

  before_action :load_clone_ticket_data, only: :new

  before_action :set_unknown_classification, only: :create

  def new
    new_ticket unless param_clone_ticket.present?
    build_answer
  end

  def create
    ticket.ticket_type = ticket_type
    ensure_immediate_answer_params

    if resource_save
      update_created_ticket_status_and_child
      set_ticket_user

      params[:from] = 'index' unless can? :read, ticket

      redirect_after_save_with_success
    else
      build_answer

      set_error_flash_now_alert
      render :new
    end
  end

  # Helper methods

  def tickets
    paginated_tickets
  end

  def paginated_tickets
    paginated(sorted_tickets(filtered_tickets))
  end

  def filtered_tickets
    scope = filtered_resources
    scope = filtered_by_subnet(scope)
    scope = filtered_by_reopened(scope)
    scope = filtered_by_rede_ouvir(scope)
    scope = filtered_by_rede_ouvir_cge(scope)
    scope = filtered_by_without_denunciation(scope)
    scope = filtered_by_coordination(scope) if current_user.coordination?
    scope = filtered_tickets_by_extension_in_progress(scope) if current_user.operator_chief? || current_user.coordination?
    scope = filtered_by_other_organs(scope) if current_user.cge? || current_user.coordination?

    scope
  end

  def filtered_count
    filtered_tickets.count
  end

  def classification
    resource.classification || resource.build_classification
  end

  def justification
    params[:justification]
  end

  def sort_columns
    excluded_head = current_user.internal? ? ['tickets.deadline'] : ['ticket_departments.deadline']
    columns = ticket_type == 'sic' ? SIC_SORT_COLUMNS : SOU_SORT_COLUMNS

    columns - excluded_head
  end

  # Private

  private

  def sorted_tickets(scope)
    scope.sorted(sort_column, sort_direction)
      .sorted('tickets.parent_protocol', sort_direction)
  end

  def default_sort_scope
    operator_tickets.from_type(ticket_type)
  end

  def operator_tickets
    current_user.operator_accessible_tickets(params[:organ_association])
  end

  def build_attendance_evaluation
    ticket.build_attendance_evaluation if ticket.attendance_evaluation.blank?
  end

  def default_sort_column
    'tickets.deadline'
  end

  def default_sort_direction
    Ticket.default_sort_direction
  end

  def can_access_index
    authorize! :read, tickets.first || new_resource
  end

  def ticket_answers
    ticket.answers
  end

  def has_answers?
    ticket_answers.any?
  end

  def answer_completed
    @answer_completed ||= ticket_answers.first
  end

  def child
    ticket.tickets.first || ticket
  end

  def ensure_immediate_answer_params
    return unless ticket.immediate_answer?

    if current_user.permission_to_answer?(child)
      answer_completed.update_attributes(final_answer_attributes)
    else
      ticket_answers.delete(answer_completed)
    end
  end

  def final_answer_attributes
    {
      status: :cge_approved,
      ticket: child,
      user: current_user
    }
  end

  def register_answer_completed_log
    RegisterTicketLog.call(ticket, current_user, :answer, { resource: answer_completed, data: create_data_log_attributes })
    RegisterTicketLog.call(child, current_user, :answer, { resource: answer_completed, data: create_data_log_attributes })
  end

  def create_data_log_attributes
    {
      responsible_user_id: current_user.id,
      responsible_organ_id: child.organ_id,
      responsible_subnet_id: child.subnet_id
    }
  end

  def redirect_to_show
    if ticket.tickets.present? && ticket.tickets.exists?(organ_id: current_user.organ_id) && first_child.not_subnet?
      redirect_to(operator_ticket_path(first_child))
    else
      redirect_to(operator_ticket_path(ticket))
    end
  end

  def first_child
    ticket.tickets.first
  end

  def load_clone_ticket_data
    return unless param_clone_ticket.present?
    @resource = resources.new(clone_ticket_attributes)
  end

  def param_clone_ticket
    params[:clone_ticket]
  end

  def clone_ticket
    operator_tickets.find(param_clone_ticket)
  end

  def clone_ticket_classification
    clone_ticket.classification
  end

  def clone_ticket_classification_attributes
    return {} if clone_ticket_classification.nil?

    clone_ticket_classification.attributes.symbolize_keys.slice(*PERMMITED_CLASSIFICATION_PARAMS)
  end

  def clone_ticket_attributes
    @attributes = clone_ticket.attributes.symbolize_keys.slice(*PERMITTED_PARAMS)
    @attributes[:classification_attributes] = clone_ticket_classification_attributes
    @attributes.merge!(clone_ticket.attributes.slice(:ticket_type.to_s))
    @attributes.except!(*USER_INFO_PARAMS) if remove_user_info?
    @attributes
  end

  def remove_user_info?
    clone_ticket.denunciation? && !current_user.denunciation_tracking?
  end

  def filtered_tickets_by_extension_in_progress(scope)
    return scope if params[:extension_status].blank?
    params[:solicitation] = '1' if params[:solicitation].blank?

    scope.joins(:extensions).where(
      extensions: { status: params[:extension_status], solicitation: params[:solicitation] }
    )
  end

  def filtered_by_coordination(scope)
    return scope if params[:extension_status].present?
    scope.where(parent_id: nil)
  end

  def filtered_by_subnet(scope)
    return scope unless params[:subnet].present?

    scope.from_subnet(params[:subnet])
  end

  def filtered_by_reopened(scope)
    return scope unless params[:reopened].present?

    scope.from_reopened
  end

  def filtered_by_rede_ouvir(scope)
    return scope unless params[:rede_ouvir].present?

    scope.with_rede_ouvir
  end

  def filtered_by_rede_ouvir_cge(scope)
    return scope unless params[:rede_ouvir_cge].present?
    scope.with_rede_ouvir_cge
  end

  def filtered_by_without_denunciation(scope)
    return scope unless params[:without_denunciation] == 'true'
    scope.not_denunciation
  end

  def filtered_by_other_organs(scope)
    return scope unless params[:other_organs].present?
    scope.left_joins(classification: [], tickets: [:classification])
      .where('classifications.other_organs = ? OR
        (tickets.parent_id is null AND classifications_tickets.other_organs = ?)', true, true)
  end

  def set_ticket_user
    SetTicketUser.delay.call(ticket.id) if ticket&.document.present?
  end

  def set_unknown_classification
    ticket.unknown_classification = false if ticket.immediate_answer?
  end

  def scope_ticket_by_department(scope)
    if current_user.cge?
      scope.from_child_ticket_department(params[:department])
    else
      scope.from_ticket_department(params[:department])
    end
  end

  def build_answer
    has_answers? || ticket.answers.build
  end
end