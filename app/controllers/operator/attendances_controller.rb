class Operator::AttendancesController < OperatorController
  include Operator::Attendances::Breadcrumbs
  include ::FilteredController
  include Operator::Attendances::Filters
  include ::PaginatedController
  include ::SortedController

  SORT_COLUMNS = [
    'attendances.created_at',
    'attendances.protocol',
    'attendances.service_type'
  ]

  PER_PAGE = 20

  PERMITTED_PARAMS = [
    :id,
    :protocol,
    :description,
    :service_type,
    :answer,
    :unknown_organ,

    attendance_organ_subnets_attributes: [
      :id,
      :organ_id,
      :subnet_id,
      :unknown_subnet,
      :_destroy
    ],

    ticket_attributes: [
      :id,
      :name,
      :social_name,
      :gender,
      :email,
      :sou_type,
      :status,
      :priority,

      :answer_type,
      :answer_phone,
      :answer_cell_phone,
      :answer_whatsapp,

      :city_id,
      :answer_address_street,
      :answer_address_number,
      :answer_address_zipcode,
      :answer_address_neighborhood,
      :answer_address_complement,
      :answer_twitter,
      :answer_facebook,
      :answer_instagram,

      :document_type,
      :document,
      :person_type,
      :used_input,
      :used_input_url,
      :anonymous,

      :denunciation_description,
      :denunciation_organ_id,
      :denunciation_date,
      :denunciation_place,
      :denunciation_witness,
      :denunciation_evidence,
      :denunciation_assurance,

      :target_address_zipcode,
      :target_city_id,
      :target_address_street,
      :target_address_number,
      :target_address_neighborhood,
      :target_address_complement,


      classification_attributes: [
        :other_organs
      ]
    ]
  ]

  helper_method [
    :attendances,
    :attendance,
    :ticket,
    :occurrences,
    :new_occurrence,
    :new_comment,
    :readonly?,
    :new_evaluation
  ]

  before_action :build_ticket, only: :edit

  before_action :assign_attributes,
    :default_ticket_attributes,
    :set_updated_by,
    :clear_classification_if_not_other_organs,
    :ticket_changes,
    only: :update

  after_action :set_classification_no_characteristic,
    only: :update

  before_action :set_deadline,
    if: :confirmation?

  before_action :build_occurrence,
    :attendance_attributes,
    only: :new

  before_action :load_clone_attendance_data,
    only: :edit,
    if: -> { param_clone_attendance.present? }


  # Action

  def new
    attendance.save(validate: false)

    redirect_to edit_operator_attendance_path(attendance, clone_id: param_clone_attendance)
  end

  def update
    if resource.save
      confirm_or_redirect
    else
      build_ticket_and_render_error
    end
  end

  def show
    if ticket.present? && ticket.create_password?
      ticket.create_password
      notify
    end
  end

  # Helpers

  def attendances
    paginated_attendances
  end

  def attendance
    resource
  end

  def ticket
    @ticket ||= attendance.ticket
  end

  def occurrences
    attendance.occurrences
  end

  def new_occurrence
    @occurrence ||= occurrences.build
  end

  def new_comment
    @new_comment ||= Comment.new(commentable: ticket)
  end

  def readonly?
    false
  end

  def new_evaluation
    @new_evaluation ||= Evaluation.new(evaluation_type: :call_center)
  end

  private

  def load_clone_attendance_data
    @resource = Attendance::CloneService.call(current_user, param_clone_attendance, attendance.id)
    flash[:notice] = t('.clone.done')
  end

  def param_clone_attendance
    params[:clone_id]
  end

  def create_answer
    if attendance.completed? && !attendance.answered?

      ticket_parent = ticket

      tickets_for_answer.each do |ticket_child|
        answer = answer_comment(ticket_child)

        attributes = { resource: answer, data: ticket_log_data(ticket_child) }

        register_ticket_log(ticket_parent, :answer, attributes)
        register_ticket_log(ticket_child, :answer, attributes) if ticket_child.child?
      end

      set_ticket_immediate_answer

      attendance.update(answered: true)
    end
  end

  def set_ticket_immediate_answer
    return unless attendance.sic_completed?

    ticket.update(immediate_answer: true)
    ticket.tickets.update_all(immediate_answer: true)
  end

  def answer_comment(ticket)
    Answer.create(
      ticket: ticket,
      user: current_user,
      description: attendance.answer,
      deadline: ticket.deadline,
      answer_type: :final,
      answer_scope: :call_center,
      status: :call_center_approved
    )
  end

  def ticket_log_data(ticket)
    {
      responsible_user_id: current_user.id,
      responsible_organ_id: ticket.organ_id,
      responsible_subnet_id: ticket.subnet_id
    }
  end

  def tickets_for_answer
    children_tickets.present? ? children_tickets : [ticket]
  end

  def children_tickets
    ticket.tickets
  end

  def paginated_attendances
    paginated_resources
  end

  def confirm_or_redirect
    if confirmation?
      attendance.confirmed? ? redirect_to_show : confirm_ticket
    else
      share_or_set_waiting_confirmation
      redirect_to_show_with_success

      # Notificando apenas edição de atendimento quando há ticket confirmado
      notify_update
      set_ticket_user
    end
  end

  def share_or_set_waiting_confirmation
    if attendance.confirmed?
      create_ticket_children
      delete_ticket_children
    else
      ticket&.waiting_confirmation!
    end
  end

  def notify_update
    if attendance.confirmed?
      register_ticket_log(ticket, :attendance_updated, { resource: attendance, data: notify_update_data })
    else
      register_ticket_log(ticket, :occurrence, { resource: create_occurrence, data: notify_update_data })
    end
  end

  def notify_update_data
    {
      responsible_as_author: current_user.as_author
    }
  end

  def confirm_ticket
    set_confirmed_at
    set_created_by
    set_ticket_statuses
    ticket.parent_unknown_organ = resource.unknown_organ
    ticket.save

    register_ticket_log(ticket, :confirm, data_as_author)

    # Quando o chamado possuir órgão, será criado um chamado "filho"
    # com as informações do chamado que passará a ser o "pai" sem órgão
    create_ticket_children

    register_priority_log if ticket.priority?

    create_answer

    # o flash é usado para exibir a mensagem específica avisando ao usuário
    # que sua manifestação foi recebida!
    flash[:from_confirmation] = true

    redirect_to_show
  end

  def set_created_by
    ticket.created_by = current_user unless ticket.created_by.present?
  end

  def without_organs?
    resource.attendance_organ_subnets.empty?
  end

  def register_priority_log
    RegisterTicketLog.call(ticket, current_user, :priority, { resource: ticket })
  end

  # atualizar o created_at do ticket pelo documento do ticket
  def set_ticket_user
    SetTicketUser.delay.call(ticket.id) if ticket&.document.present?
  end

  def set_ticket_statuses
    if resource.completed?
      ticket.attributes = { status: :replied, internal_status: :final_answer, call_center_status: :with_feedback, responded_at: DateTime.now }
    elsif resource.unknown_organ?
      ticket.internal_status = :waiting_referral
    else
      ticket.internal_status = :sectoral_attendance
    end
  end

  def create_ticket_children
    return if resource.unknown_organ? || ticket.blank?

    resource.attendance_organ_subnets.each do |attendance_organ_subnet|
      organ_id = attendance_organ_subnet.organ_id
      subnet_id = attendance_organ_subnet.subnet_id

      if ticket.tickets.exists?(organ_id: organ_id, subnet_id: subnet_id)
        update_child(organ_id, subnet_id)
      else
        create_child(attendance_organ_subnet)
      end
    end
  end

  def create_child(attendance_organ_subnet)
    ticket.unknown_organ = false
    ticket.organ_id = attendance_organ_subnet.organ_id
    ticket.unknown_subnet = attendance_organ_subnet.unknown_subnet
    ticket.subnet_id = attendance_organ_subnet.subnet_id

    ticket.sectoral_attendance! unless resource.completed?

    ticket.create_ticket_child
  end

  def update_child(organ_id, subnet_id)
    child = ticket.tickets.find_by(organ_id: organ_id, subnet_id: subnet_id)
    child.update(child_attributes)
  end

  def delete_ticket_children
    resource_params[:attendance_organ_subnets_attributes]&.each do |_, aos|
      next unless aos[:_destroy] == '1'

      child_ticket = ticket.tickets.find_by(organ_id: aos[:organ_id], subnet_id: aos[:subnet_id])

      Ticket::DeleteSharing.call(child_ticket.id, current_user.id) if child_ticket.present?
    end
  end

  def assign_attributes
    resource.assign_attributes(resource_params)
    resource.unknown_organ = true if without_organs?
  end

  def default_ticket_attributes
    unless resource.reject_ticket?
      set_ticket_protocol
      set_ticket_description
      set_ticket_ticket_type
      set_ticket_unknown_organ
    end
  end

  def set_classification_no_characteristic
    if resource.service_type.to_sym == :no_characteristic
      new_classification_to_no_characteristic
      register_ticket_log(ticket, :confirm, data_as_author)

      register_priority_log if ticket.priority?

      create_answer
      set_ticket_final_answer_to_no_characteristic
    end
  end

  def new_classification_to_no_characteristic
    Classification.create(
      ticket_id: ticket.id,
      topic_id: Topic.only_no_characteristic.id,
      department_id: Department.only_no_characteristic.id,
      budget_program_id: BudgetProgram.only_no_characteristic.id,
      service_type_id: ServiceType.only_no_characteristic.id
    )
  end

  def set_ticket_final_answer_to_no_characteristic
    set_confirmed_at
    set_deadline
    set_created_by
    set_ticket_statuses
    ticket.immediate_answer = true
    ticket.save
  end

  def set_ticket_protocol
    ticket.protocol = resource.protocol
  end

  def set_ticket_description
    if ticket.denunciation?
      ticket.denunciation_description = resource.description
    else
      ticket.description = resource.description
    end
  end

  def set_ticket_ticket_type
    ticket.ticket_type = :sic if resource.sic?
    ticket.ticket_type = :sou if resource.sou?
  end

  def set_ticket_unknown_organ
    ticket.unknown_organ = true
  end

  def set_confirmed_at
    ticket.confirmed_at = DateTime.now
  end

  def set_deadline
    ticket.set_deadline
  end

  # Indica que o usuário está na página de confirmação e é usado para
  # setar a flash[:from_confirmation] = true para ser usado no show do Ticket
  # e podermos exibir a mensagem completa de 'sucesso'
  def confirmation?
    params[:confirmation] == 'true'
  end

  def register_ticket_log(ticket, status, attributes = {})
    RegisterTicketLog.call(ticket, current_user, status, attributes)
  end

  def build_ticket
    resource.build_ticket(answer_type: :phone, used_input: :phone_155) unless resource.ticket.present?
    resource.ticket.build_classification unless resource.ticket.classification.present?

    ticket.person_type = nil if ticket.anonymous?
    ticket.internal_status = :in_filling
  end

  def build_ticket_and_render_error
    build_ticket
    set_error_flash_now_alert
    render :edit
  end

  def notify
    Notifier::NewTicket.delay.call(ticket.id) unless ticket.nil?
  end

  def build_occurrence
    attendance.occurrences.build(
      description: I18n.t('occurrences.default_occurrence'),
      created_by: current_user
    )
  end

  def create_occurrence
    occurrence = build_occurrence

    occurrence.save

    occurrence
  end

  def attendance_attributes
    attendance.service_type = :incorrect_click
    attendance.created_by = current_user
  end

  def set_updated_by
    attendance.updated_by = current_user
  end

  def ticket_classification
    ticket&.classification
  end

  def clear_classification_if_not_other_organs
    return if ticket_classification.blank? || ticket_classification.other_organs?
    resource.ticket.classification = nil
  end

  def data_as_author
    { data: { responsible_as_author: current_user.as_author }}
  end

  def resource_klass
    Attendance
  end

  def ticket_changes
    @ticket_changes ||= resource.ticket&.changed
  end

  def child_attributes
    ticket.attributes.slice(*ticket_changes)
  end
end
