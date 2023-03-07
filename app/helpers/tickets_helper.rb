module TicketsHelper

  SOU_EVALUATION_HEADERS = [
    :confirmed_at,
    :parent_protocol,
    :sou_type,
    :description
  ]


  SOU_HEADERS = [
    :confirmed_at,
    :deadline,
    :ticket_departments_deadline,
    :name,
    :parent_protocol,
    :sou_type,
    :internal_status,
    :organs,
    :departments,
    :description
  ]

  SIC_HEADERS = [
    :confirmed_at,
    :deadline,
    :ticket_departments_deadline,
    :name,
    :parent_protocol,
    :internal_status,
    :organs,
    :departments,
    :description
  ]

  OTHER_FILTERS_PARAMS = [
    :search,
    :parent_protocol,
    :internal_status,
    :budget_program,
    :priority,
    :deadline,
    :ticket_departments_deadline,
    :organ,
    :status_for_citizen,
    :answer_type,
    :sou_type,
    :department,
    :sub_department,
    :topic,
    :service_type,
    :subnet,
    :reopened
  ]

  def ticket_department_text_button
    all_ticket_departments.present? ? t('.transfer_departments.share') : t('.referrals.edit')
  end

  def tickets_elegible_share_with_rede_ouvir?(ticket, user)
    ticket.sou? && !user.sectoral_rede_ouvir?
  end

  def tickets_change_ticket_type_message(data_attributes)
    from = data_attributes[:from]
    to = data_attributes[:to]

    if from.blank?
      #
      # data_attributes de registros da estrutura anterio não mantinha sou_type e sim apenas 'sou'
      #
      to == 'sic' ? to : 'sou'
      return I18n.t("shared.ticket_logs.change_ticket_type.#{to}.title")
    end

    if from == 'sic'
      to_str = Ticket.human_attribute_name("sou_type.#{to}")
      from_str = Ticket.human_attribute_name("ticket_type.#{from}")
    else
      from_str = Ticket.human_attribute_name("sou_type.#{from}")
      to_str = Ticket.human_attribute_name("ticket_type.#{to}")
    end

    I18n.t('shared.ticket_logs.change_ticket_type.title', from: from_str, to: to_str)
  end

  def tickets_operator_link_cards_params(current_user, user_ticket_type, organ_association=nil, other_params = {})
    {
      ticket_type: user_ticket_type,
      without_denunciation: !current_user.sectoral_denunciation?,
      organ_association: organ_association
    }.merge(other_params)
  end

  def ticket_answer_types_for_toggle
    ticket_answer_types_keys
  end

  def ticket_answer_types_for_select
    ticket_answer_types_keys.map do |answer_type|
      [ I18n.t("ticket.answer_types.#{answer_type}"), answer_type ]
    end
  end

  def ticket_call_center_answer_types_for_select
    [:phone, :whatsapp].map do |answer_type|
      [ I18n.t("ticket.answer_types.#{answer_type}"), answer_type ]
    end
  end

  def ticket_answer_type_selected(answer_type)
    answer_type.present? ? answer_type : default_answer_type
  end

  # intervalos "chumbados". elaborar um mecanisno dinâmico no futuro
  def remaining_days_to_deadline_class(days)
    case days
    when '-' then ''
    when 10..Float::INFINITY then 'text-success'
    when 5..9 then 'text-warning'
    else 'text-danger'
    end
  end

  def status_for_operator(ticket)
    rede_ouvir_str = ticket.rede_ouvir? ? RedeOuvirOrgan.model_name.human : ''

    [ticket.organ_acronym, ticket.subnet_acronym, ticket.internal_status_str, rede_ouvir_str].reject(&:blank?).join(' - ')
  end

  def description_for_operator(user, ticket)
    if user.internal? && ticket.created_by_id != user.id && !ticket.created_by_id.nil?
      ticket_department = ticket.ticket_department_by_user(user)
      ticket_department.description
    else
      ticket.denunciation? ? ticket.denunciation_description : ticket.description
    end
  end

  def ticket_document_types_for_select
    document_types_keys.map do |document_type|
      [document_type_title(document_type), document_type]
    end
  end

  def ticket_denunciation_assurances_for_select
    Ticket.available_denunciation_assurances.keys.map do |denunciation_assurance|
      [denunciation_assurance_title(denunciation_assurance), denunciation_assurance]
    end
  end

  def ticket_used_input_for_select
    used_input_keys.map do |used_input|
      [used_input_title(used_input), used_input]
    end
  end

  def ticket_types_for_select
    ticket_type_keys.map do |ticket_type|
      [I18n.t("ticket.ticket_types.#{ticket_type}"), ticket_type]
    end
  end

  def sou_types_for_select(user=nil)
    sou_type_keys(user).map do |sou_type|
      [I18n.t("ticket.sou_types.#{sou_type}"), sou_type]
    end
  end

  def ticket_sou_types_report_for_select(user)
    sou_type_keys_report(user).map do |sou_type|
      [I18n.t("ticket.sou_types.#{sou_type}"), sou_type]
    end
  end

  def used_inputs_for_select
    used_input_keys.map do |used_input|
      [I18n.t("ticket.used_inputs.#{used_input}"), used_input]
    end
  end

  def ticket_answer_classifications_for_select(ticket)
    answer_classification_keys(ticket).map do |answer_classification|
      [I18n.t("ticket.answer_classifications.#{answer_classification}"), answer_classification]
    end.sort { |x, y| x[0] <=> y[0] }
  end

  def ticket_internal_status_for_select(ticket_type = 'sou', user = nil)
    return [] if user.blank? || user.user?

    internal_statuses = ticket_internal_status_scoped_by_ticket_type_user(ticket_type, user)

    internal_statuses.keys.map do |status|
      [Ticket.human_attribute_name("internal_status.#{status}"), status]
    end
  end

  def ticket_all_internal_status
    Ticket.internal_statuses.keys.map do |status|
      [Ticket.human_attribute_name("internal_status.#{status}"), status]
    end
  end

  def ticket_statuses_for_citizen
    Ticket::STATUSES_FOR_CITIZEN.map do |status|
      [Ticket.human_attribute_name("statuses_for_citizen.#{status}"), status]
    end
  end

  def ticket_deadlines_for_select
    Ticket::FILTER_DEADLINE.keys.map do |filter|
      [Ticket.human_attribute_name("deadline.#{filter}"), filter]
    end
  end

  def ticket_call_center_status_for_select
    call_center_status_keys.map do |call_center_status|
      [I18n.t("ticket.call_center_statuses.#{call_center_status}"), call_center_status]
    end
  end

  def info_details(ticket)
    return '' if ticket.anonymous?

    [ticket.document, ticket.email, ticket.name].reject(&:blank?).join(' - ')
  end

  def ticket_highlight_row(ticket)
    return 'highlight-background-red' if ticket_expired?(ticket) || ticket_rejected_validation?(ticket)

    'highlight-background-yellow' if ticket_priority?(ticket)
  end

  def ticket_sou_types(anonymous = false, only_denunciation = false)
    sou_types =
      if only_denunciation
        ["denunciation"]
      elsif anonymous
        Ticket.sou_types.keys - ["compliment"]
      else
        Ticket.sou_types.keys
      end

    sou_types
  end

  def ticket_last_log_invalidate(ticket)
    ticket.ticket_logs.invalidate.order('created_at').last
  end

  def tickets_invalidate_log_protocol(ticket_log)
    ticket = Ticket.find_by_id(ticket_log.data[:target_ticket_id])
    ticket&.parent_protocol
  end

  def ticket_existent_answer_attachments(ticket, user)
    return answer_attachments_for_child(ticket, user) if ticket.child?
    answer_attachments_for_parent(ticket)
  end

  def tickets_operator_tabs(user, ticket)
    tabs = [:infos, :classification, :areas, :comments]

    tabs_by_user(tabs, user)

    tabs << :history

    tabs << :attendance_evaluations if (ticket.organ_can_be_evaluated? && ticket.sic?)

    tabs << :internal_evaluation if (operator_coordination_or_cge?(user) || operator_denunciation?(user)) &&
                                    ticket.sou? &&
                                    ticket.organ_can_be_evaluated?

    tabs.delete(:classification) if ticket.rede_ouvir?

    tabs
  end

  def tabs_by_user(tabs, user)
    case user.operator_type
    when 'internal'
      tabs << :internal_replies
      tabs.delete(:classification)
    when 'cge'
      tabs.delete(:classification)
      tabs.insert(2, *[:classification])
    end

    tabs << :replies unless user.internal?

    tabs
  end

  def children_except(ticket)
    return [] if ticket.parent?

    ticket.parent.tickets.sorted.where.not(id: ticket)
  end

  def ticket_children_can_answer_count(ticket)
    ticket.reopened + ticket.appeals +
      if ticket.tickets.blank?
        1
      else
        ticket.tickets.active_not_answered.count
      end
  end

  def ticket_table_columns_for_operator(ticket_type, user, sou_evaluation_samples = nil)
    if sou_evaluation_samples
      SOU_EVALUATION_HEADERS
    else
      headers_by_ticket_type(ticket_type) - excluded_headers(user)
    end
  end

  def ticket_alert_deadline?(ticket, user)
    ticket_extension_inprogress?(ticket, user)
  end

  def ticket_alert_waiting?(ticket)
    ticket_sectoral_validation?(ticket) || ticket_waiting_invalidated?(ticket) || ticket_cge_validation?(ticket)
  end

  def ticket_alert_reopen_appeal?(ticket)
    ticket_reopened?(ticket) || ticket.appeals?
  end

  def ticket_internal_status_str(ticket)
    ticket_rejected_validation?(ticket) ? status_str_rejected_validation(ticket) : ticket.internal_status_str
  end

  def ticket_filter_params?(params)
    range_created_filtered = has_range_param(params[:created_at])
    range_confirmed_filtered = has_range_param(params[:confirmed_at])

    filtered_checkbox = checked_filter?(params)

    other_filters = OTHER_FILTERS_PARAMS.any? { |key| params[key].present? }

    range_created_filtered || range_confirmed_filtered || other_filters || filtered_checkbox
  end

  def operator_ticket_transfer_department ticket
    edit_operator_ticket_transfer_department_path(ticket, ticket_department_by_user_department)
  end

  # privates

  private

  def has_range_param(param)
    param.present? && (param[:start].present? || param[:end].present?)
  end

  def checked_filter?(params)
    params[:extension_in_progress] == '1' || params[:denunciation] == '1' ||
      params[:finalized] == '1' || params[:rede_ouvir_cge] == '1' ||
      params[:rede_ouvir] == '1' || params[:without_denunciation] == '1' ||
      params[:priority] == '1' || params[:other_organs] == '1'
  end

  def status_str_rejected_validation(ticket)
    "[#{Answer.human_attribute_name("status.#{ticket.ticket_type}.cge_rejected")}] #{ticket.internal_status_str}"
  end

  def ticket_rejected_validation?(ticket)
    return false unless (ticket.subnet_attendance? || ticket.sectoral_attendance?) && ticket.answers.present?

    last_answer = ticket.answers.last

    last_answer.cge_rejected? || last_answer.subnet_rejected?
  end

  def children_awaiting_invalidation?(ticket)
    ticket.tickets.exists?(internal_status: :awaiting_invalidation)
  end

  def answer_attachments_for_child(ticket, user)
    answer_attachments_for_user(ticket, user).sort
  end

  def answer_attachments_for_user(ticket, user)
    return ticket.answer_attachments unless user.internal?
    answer_attachments_for_internal(ticket, user)
  end

  def answer_attachments_for_internal(ticket, user)
    ticket.answer_attachments.where(answers: { user_id: user.id })
  end

  def answer_attachments_for_parent(ticket)
    answer_attachments = ticket.answer_attachments
    ticket.tickets.each do |child|
      answer_attachments += child.answer_attachments
    end

    answer_attachments.sort
  end

  def ticket_internal_status_scoped_by_ticket_type_user(ticket_type, user)
    internal_statuses = Ticket.internal_statuses

    internal_statuses = internal_status_scoped_for_operator(internal_statuses, user)

    internal_status_scoped_by_ticket_type(ticket_type, internal_statuses)
  end

  def internal_status_scoped_for_operator(internal_statuses, user)
    return internal_statuses.slice(:internal_attendance, :partial_answer, :final_answer) if user.internal?
    internal_statuses = internal_statuses.except(:in_filling) unless user.call_center_supervisor? || user.call_center?
    internal_statuses = internal_statuses.except(:awaiting_invalidation) unless user.cge?
    internal_statuses
  end

  def internal_status_scoped_by_ticket_type(ticket_type, internal_statuses)
    return internal_statuses.except(:cge_validation) if ticket_type == 'sic'

    internal_statuses.except(:appeal)
  end

  def document_types_keys
    Ticket.document_types.keys
  end

  def ticket_type_keys
    Ticket.ticket_types.keys
  end

  def used_input_keys
    Ticket.available_used_inputs.keys
  end

  def call_center_status_keys
    Ticket.call_center_statuses.keys
  end

  def sou_type_keys(user=nil)
    sou_types = Ticket.sou_types
    sou_types = sou_types.except(:denunciation) unless can_view_denunciation?(user)
    sou_types.keys
  end

  def sou_type_keys_report(user)
    sou_types = Ticket.sou_types
    sou_types = sou_types.except(:denunciation) unless user.cge? || user.operator_denunciation? || user.sectoral?
    sou_types.keys
  end

  def denunciation_types
    Ticket.denunciation_types.keys.map do |denunciation_type|
      [I18n.t("ticket.denunciation_types.#{denunciation_type}"), denunciation_type]
    end
  end

  def answer_classification_keys(ticket)
    Ticket.answer_classifications.slice(*answer_classification_filtered(ticket)).keys
  end

  def answer_classification_filtered(ticket)
    return Ticket::SOU_ANSWER_CLASSIFICATION if ticket.sou?

    ticket.appeal? ? Ticket::APPEAL_ANSWER_CLASSIFICATION : Ticket::SIC_ANSWER_CLASSIFICATION
  end

  def ticket_answer_types_keys
    Ticket.answer_types.keys
  end

  def denunciation_assurance_title(denunciation_assurance)
    Ticket.human_attribute_name("denunciation_assurance.#{denunciation_assurance}")
  end

  def used_input_title(used_input)
    Ticket.human_attribute_name("used_input.#{used_input}")
  end

  def default_answer_type
    ticket_answer_types_for_select[0]
  end

  def document_type_title(document_type)
    I18n.t("ticket.document_types.#{document_type}")
  end

  def ticket_extension_inprogress?(ticket, user)
    user&.chief? && ticket.has_extension_organ_in_progress?
  end

  def checked_extension_in_progress?(extension_status, solicitation)
    extension_status == 'in_progress' && solicitation.in?([nil, '1'])
  end

  def ticket_log_detail_to_extension(extension)
    path = 'shared.ticket_logs.extension.in_progress'
    if extension.solicitation == 1
      I18n.t("#{path}.chief_responsible", organ: extension.organ_acronym)
    else
      I18n.t("#{path}.coordination_responsible")
    end
  end

  def ticket_expired?(ticket)
    ticket.expired?
  end

  def ticket_reopened?(ticket)
    ticket.reopened? || ticket.tickets.exists?(["reopened > ?", 0])
  end

  def ticket_sectoral_validation?(ticket)
    ticket.sectoral_validation? || ticket.tickets.exists?(internal_status: :sectoral_validation)
  end

  def ticket_cge_validation?(ticket)
    ticket.cge_validation? || ticket.tickets.exists?(internal_status: :cge_validation)
  end

  def ticket_waiting_invalidated?(ticket)
    ticket.parent? && children_awaiting_invalidation?(ticket)
  end

  def ticket_priority?(ticket)
    ticket.priority?
  end

  def headers_by_ticket_type(ticket_type)
    ticket_type == 'sic' ? SIC_HEADERS : SOU_HEADERS
  end

  def excluded_headers(user)
    case user.operator_type
    when 'cge', 'call_center', 'call_center_supervisor'
      [:organs, :ticket_departments_deadline, :departments]
    when 'sou_sectoral', 'sic_sectoral'
      [:ticket_departments_deadline, :organs]
    when 'internal'
      [:deadline, :name, :departments]
    else
      [:ticket_departments_deadline, :departments]
    end
  end

  def can_view_denunciation?(user)
    user.present? &&
      (user.operator_denunciation? || user.call_center_operator? || user.sectoral?)
  end

  def array_for_simple_form
    if is_ceara_app?
      [:ceara_app, ticket]
    else
      [ticket]
    end
  end

  def link_to_new_ticket(ticket_params)
    ceara_app = is_ceara_app? ? 'ceara_app_' : ''
    platform = is_platform? ? 'platform_' : ''
    send("new_#{ceara_app}#{platform}ticket_path", ticket_params)
  end

  def is_platform?
    controller.class.parent.to_s.include? 'Platform'
  end

  def url_for_ticket_area_login
    if is_ceara_app?
      ceara_app_ticket_session_path
    else
      session_path(resource_name)
    end
  end

  def show_tab?(tab, ticket)
    tab != :internal_evaluation || can?(:view_ticket_attendance_evaluation, ticket)
  end

  def controller_name_sou_evaluation_samples?
      controller_name.to_sym == :sou_evaluation_samples
  end

  def filter_label
    controller_name_sou_evaluation_samples? ? I18n.t('operator.tickets.index.sample_filters') : I18n.t('operator.tickets.index.filters')
  end

  def get_parent(ticket)
    return ticket if ticket.parent?

    ticket.parent
  end

  def internally_evaluated?(ticket)
    return ticket.internal_evaluation? if ticket.sou?

    # no caso do SIC não temos um controle específico se foi ou não avaliado internamente,
    # pois boa parte do fluxo da avaliação é feita de forma manual pelo operador SIC, por
    # isso verificamos em cima do ticket.attendance_evaluation.average
    return ticket.attendance_evaluation.average.present? if ticket.sic?
  end
end
