#
# Controller compartilhado entre 3 áreas da plataforma:
#
# 1) abertura de chamado anonimo (tickets_controller e ticket/tickets_controller)
# 2) abertura de chamado logado (platform/tickets_controller)
# 3) abertura de chamado no operator (operator/tickets_controller)
#

module Tickets::BaseController
  extend ActiveSupport::Concern
  include PaginatedController
  include SortedController
  include FilteredController

  FIND_ACTIONS = ['show', 'edit', 'update', 'destroy', 'import', 'history']

  PER_PAGE = 20

  VISIBLE_CHANGED_ATTRIBUTES = Ticket.column_names - ['updated_by_id']

  PERMITTED_TICKET_USER_PARAMS = [
    :name,
    :social_name,
    :gender,
    :document_type,
    :document,
    :email,
    :answer_phone,
    :answer_cell_phone,
    :city_id,
    :answer_address_street,
    :answer_address_number,
    :answer_address_neighborhood,
    :answer_address_complement,
    :answer_address_zipcode,
    :answer_twitter,
    :answer_facebook,
    :answer_instagram,
    :answer_whatsapp
  ]

  PERMITTED_TICKET_PARAMS = [
    :description,
    :sou_type,
    :organ_id,
    :unknown_organ,
    :subnet_id,
    :unknown_subnet,
    :status,
    :used_input,
    :public_ticket,

    :answer_type,
    :person_type,

    :anonymous,

    :denunciation_organ_id,
    :denunciation_description,
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
    :citizen_topic_id,

    attachments_attributes: [
      :id, :document, :_destroy
    ]
  ]

  PERMITTED_PARAMS = PERMITTED_TICKET_PARAMS + PERMITTED_TICKET_USER_PARAMS

  VALID_TICKET_TYPES = ['sic', 'sou']

  DEFAULT_TICKET_TYPE = 'sou'

  included do

    helper_method [
      :title,
      :tickets,
      :ticket,
      :ticket_type,
      :new_comment,
      :new_answer,
      :new_evaluation,
      :anonymous_param,
      :ticket_children,
      :readonly?,
      :all_ticket_departments,
      :ticket_department_by_user_department
    ]

    # Callbacks

    before_action :set_created_by,
      :set_default_denunciation,
      :set_deadline,
      only: :create

    before_action :set_updated_by, only: :update

    # Actions

    def new
      new_ticket
    end

    def create
      ticket.ticket_type = ticket_type
      ticket.anonymous = anonymous_param

      super
    end

    def history
      render partial: 'shared/tickets/ticket_logs/history'
    end

    def show
      create_ticket_password

      render template: 'shared/tickets/print', layout: 'print' if print?
    end

    def update
      resource.assign_attributes(resource_params)

      # obtem os atributos alterados antes de salvar para registrar no log
      changes = resource.changes

      if resource.save
        register_update_log(changes)
        redirect_after_save_with_success
      else
        set_error_flash_now_alert
        render :edit
      end
    end

    # Helper methods

    def tickets
      resources
    end

    def ticket
      resource
    end

    def ticket_type
      ticket_type = params[:ticket_type] || ticket.ticket_type

      # garante que o ticket_type é válido (:sic ou :sou) pois esse parâmetro
      # será usado por diversas partes, como definir o título das páginas e
      # dos breadcrumbs por ex., e precisamos garantir que seu valor seja um
      # dos permitidos (:sic ou :sou)

      (VALID_TICKET_TYPES.include?(ticket_type) ? ticket_type : default_ticket_type)
    end

    def title
      # título das páginas é definido de acordo com o ticket_type.
      t(".#{ticket_type}.title")
    end

    def new_comment
      # buildamos um novo comentário para ser usado no form do show.

      @new_comment ||= Comment.new(commentable: ticket)
    end

    def new_answer
      # buildamos uma nova resposta/posicionamento para ser usado no form do show.

      @new_answer ||= Answer.new(ticket: ticket)
    end

    def new_evaluation
      # buildamos uma nova avaliação para ser usado no form do show.

      @new_evaluation ||= Evaluation.new(evaluation_type: evaluation_type)
    end

    def new_ticket
      ticket.ticket_type = ticket_type
      ticket.anonymous = anonymous_param

      # Somente para cge essa opção vem selecionada por padrão
      ticket.unknown_classification = current_user&.cge?

      if current_user.present?
        ticket.email = current_user.email if current_user&.user?
        ticket.answer_facebook = current_user.facebook_profile_link
      end
    end

    def all_ticket_departments
      return resource.ticket_departments if resource.child?
      TicketDepartment.where(ticket_id: resource.sorted_tickets)
    end

    def ticket_department_by_user_department
      all_ticket_departments.find_by(department_id: current_user.department_id)
    end

    def ticket_children
      resource.child? ? resource.parent.sorted_tickets : resource.sorted_tickets
    end

    def anonymous_param
      ticket.anonymous || params[:anonymous] == 'true'
    end

    def readonly?
      current_user.blank? && current_ticket.blank?
    end

    # Private

    private

    def resource_klass
      Ticket
    end

    def resource_params
      params.require(:ticket).permit(self.class::PERMITTED_PARAMS) if params[:ticket]
    end

    def paginated_tickets
      paginated_resources
    end

    def sorted_tickets
      sorted_resources
    end

    def filtered_resources

      return filtered_partial_answer_expired if params[:expired].present?

      scope = sorted_resources
      
      return scope.where(parent_protocol: params[:parent_protocol]) if params[:parent_protocol].present?
      
      filtered = scope
      
      filtered = filtered_tickets_by_internal_status(filtered)
      filtered = filtered_tickets_by_organ(filtered)
      filtered = filtered_tickets_by_department(filtered)
      filtered = filtered_tickets_by_budget_program(filtered)
      filtered = filtered_tickets_by_priority(filtered)
      filtered = filtered.search(params[:search]) if params[:search].present?
      filtered = filtered_tickets_by_deadline(filtered)
      filtered = filtered_tickets_by_ticket_departments_deadline(filtered)
      filtered = filtered_tickets_finalized(filtered)
      filtered = filtered_tickets_by_answer_type(filtered)
      filtered = filtered_tickets_denunciation(filtered)
      filtered = filtered_tickets_by_sou_type(filtered)
      filtered = filtered_tickets_by_confirmed_at(filtered)
      filtered = filtered_tickets_by_sub_department(filtered)
      filtered = filtered_tickets_by_topic(filtered)
      filtered = filtered_tickets_by_service_type(filtered)
      filtered = filtered_tickets_by_percentage(filtered) if params[:percentage].present?
      filtered = filtered_tickets_with_answer_pending_research(filtered) if params[:pending_research].present?
      filtered
    end

    def filtered_tickets_by_percentage(scope)
      return scope unless params[:percentage].present?

      limit = ((scope.count * params[:percentage].to_i) / 100)
      ticket_ids = scope.limit(limit).ids
      scope.where(id: ticket_ids)
    end

    def filtered_tickets_by_internal_status(scope)
      return scope unless params[:internal_status].present?

      return scope.with_answers_awaiting_cge_validation if params[:internal_status] == 'cge_validation'

      return scope.leafs_with_internal_status(params[:internal_status]) if internal_status_scoped_by_parent?

      scope.with_internal_status(params[:internal_status])
    end

    def awaiting_invalidation
      Ticket.internal_statuses[:awaiting_invalidation]
    end

    def filtered_tickets_by_organ(scope)
      return scope unless params[:organ].present?
      filtered = scope.with_organ(params[:organ])
      filtered_tickets_by_topic(filtered)
    end

    def filtered_tickets_by_department(scope)
      return scope unless params[:department].present?
      scope_ticket_by_department(scope)
    end

    def filtered_tickets_by_sub_department(scope)
      return scope unless params[:sub_department].present?
      scope.with_sub_department(params[:sub_department])
    end

    def filtered_tickets_by_topic(scope)
      return scope unless params[:topic].present?
      filtered = scope.with_topic(params[:topic])
      filtered_tickets_by_subtopic(filtered)
    end

    def filtered_tickets_by_subtopic(scope)
      return scope unless params[:subtopic].present?
      scope.with_subtopic(params[:subtopic])
    end

    def filtered_tickets_by_service_type(scope)
      return scope unless params[:service_type].present?
      scope.with_service_type(params[:service_type])
    end

    def filtered_tickets_by_budget_program(scope)
      return scope unless params[:budget_program].present?
      scope.with_budget_program(params[:budget_program])
    end

    def filtered_tickets_by_priority(scope)
      return scope unless params[:priority].present?

      scope.priority
    end

    def filtered_tickets_by_deadline(scope)
      return scope unless params[:deadline].present?

      if (current_user.present? && current_user.internal?)
        scope.with_ticket_department_deadline(params[:deadline])
      else
        scope.with_deadline(params[:deadline])
      end
    end

    def filtered_partial_answer_expired

      if current_user.operator_denunciation? || current_user.cge?
        scope = partial_answer_expire_scope(ticket_type)
      else
        scope = current_user.operator_accessible_tickets
      end

      scope.with_internal_status_expired(params[:internal_status], current_user)

    end

    def partial_answer_expire_scope(ticket_type)
      den = current_user.operator_denunciation?
      den ? Ticket.from_type(ticket_type).active : Ticket.from_type(ticket_type).active.not_denunciation
    end

    def filtered_tickets_by_ticket_departments_deadline(scope)
      return scope unless params[:ticket_departments_deadline].present?
      scope.with_ticket_department_deadline(params[:ticket_departments_deadline])
    end

    def filtered_tickets_finalized(scope)
      return scope if param_finalized || params[:internal_status].present?

      scope.active
    end

    def filtered_tickets_by_answer_type(scope)
      return scope unless params[:answer_type].present?

      scope.with_answer_type(params[:answer_type])
    end

    def filtered_tickets_denunciation(scope)
      if params[:denunciation] == '1' && ticket_type == 'sou' && current_user&.operator_denunciation?
        scope.parent_tickets.denunciation
      else
        scope
      end
    end

    def filtered_tickets_by_sou_type(scope)
      return scope unless params[:sou_type].present?
      scope.with_sou_type(params[:sou_type])
    end

    def filtered_tickets_by_confirmed_at(scope)
      return scope unless params[:confirmed_at].present?
      scope.where(confirmed_at: start_date_filter..end_date_filter)
    end

    def filtered_tickets_by_theme(scope)
      return scope unless params[:theme].present?

      scope.with_theme(params[:theme])
    end

    def start_date_filter
      return Ticket.first_confirmed_date.to_date unless params[:confirmed_at][:start].present?

      Date.parse(params[:confirmed_at][:start])
    end

    def end_date_filter
      return Date.today.end_of_day unless params[:confirmed_at][:end].present?

      Date.parse(params[:confirmed_at][:end]).end_of_day
    end

    def set_success_flash_notice
      # Os controllers de API não têm flash
      return unless  respond_to?(:flash)

      # o :create não seta o flash pois ainda vai passar por confirmação
      flash[:notice] = t(".#{ticket.ticket_type}.done", title: resource_notice_title) if action_name != 'create'
    end

    def set_error_flash_alert
      # Os controllers de API não têm flash
      return unless  respond_to?(:flash)

      flash[:alert] = t(".#{ticket.ticket_type}.error", title: resource_notice_title)
    end

    def set_error_flash_now_alert
      # Os controllers de API não têm flash
      return unless  respond_to?(:flash)

      flash.now[:alert] = t(".#{ticket.ticket_type}.error", title: resource_notice_title)
    end

    def resource_notice_title
      ticket.parent_protocol
    end

    def set_created_by
      resource.created_by = current_user
    end

    def set_updated_by
      resource.updated_by = current_user
    end

    def set_default_denunciation
      return unless ticket.denunciation?

      ticket.unknown_organ = true
      ticket.organ_id = nil
    end

    def set_confirmed_at
      resource.status = :confirmed
      resource.confirmed_at = DateTime.now
    end

    def set_deadline
      resource.set_deadline
    end

    # Indica que o usuário está na página de confirmação e é usado para
    # setar a flash[:from_confirmation] = true para ser usado no show do Ticket
    # e podermos exibir a mensagem completa de 'sucesso'
    def confirmation?
      params[:confirmation] == 'true'
    end

    def register_ticket_log(status, attributes = {})
      RegisterTicketLog.call(resource, current_user_or_ticket, status, attributes)
    end

    def notify
      Notifier::NewTicket.delay.call(parent_ticket.id)
    end

    def update_created_ticket_status_and_child
      # importante dar o reload para que o ticket.title apareça corretamente
      # no flash[:notice]
      ticket.reload if ticket.persisted?

      set_confirmed_at
      ticket.parent_unknown_organ = ticket.unknown_organ
      ticket.waiting_allocation! if ticket.phone? || ticket.whatsapp?

      register_creation_logs

      set_deadline

      set_ticket_organ_attributes(ticket)

      set_confirmation_flash
    end

    def default_ticket_type
      return DEFAULT_TICKET_TYPE unless current_user&.operator?
      return 'sic' if current_user.sic_sectoral?

      DEFAULT_TICKET_TYPE
    end

    def set_ticket_organ_attributes(ticket)
      if ticket.unknown_organ?
        ticket.waiting_referral!
      else
        ticket.sectoral_attendance!

        # Quando o chamado possuir Órgão, será criado um chamado "filho"
        # com as informações do chamado que passará a ser o "pai" sem Órgão
        #
        # Quando o órgão selecionado for do tipo sub-rede, será criado um
        # chamado filho no caso de department estiver selecionado.
        ticket.create_ticket_child
      end
    end

    def set_confirmation_flash
      # o flash é usado para exibir a mensagem específica avisando ao usuário
      # que sua manifestação foi recebida!
      flash[:from_confirmation] = true
    end

    def param_finalized
      params[:finalized].present? && ActiveModel::Type::Boolean.new.cast(params[:finalized])
    end

    def scope_ticket_by_department(scope)
      scope.from_ticket_department(params[:department])
    end

    def evaluation_type
      current_user&.call_center? ? :call_center : ticket.ticket_type
    end

    def register_creation_logs
      data = as_author_operator
      register_ticket_log(:confirm, data)
      register_priority_log
      register_attachments_log
    end

    def register_update_log(changes)
      return if changes.slice(*self.class::VISIBLE_CHANGED_ATTRIBUTES) == {}

      data_attributes = {
        responsible_as_author: current_user_or_ticket.as_author,
        ticket_changes: changes
      }

      RegisterTicketLog.call(ticket_parent, current_user_or_ticket, :update_ticket, data: data_attributes)
    end

    def ticket_parent
      resource.parent || resource
    end

    def register_attachments_log
      ticket.attachments.each do |attachment|
        register_ticket_log(:create_attachment, { resource: attachment })
      end
    end

    def register_priority_log
      return unless ticket.priority?
      register_ticket_log(:priority, { resource: ticket })
    end

    def user_scoped_by_parent_tickets?(user)
      user.cge? || user.call_center? || user.call_center_supervisor?
    end

    def as_author_operator
      return {} unless current_user&.operator?

      { data: { responsible_as_author: current_user.as_author }}
    end

    def internal_status_scoped_by_parent?
      (user_scoped_by_parent_tickets?(current_user) && params[:internal_status] != 'appeal') || params[:internal_status] == 'awaiting_invalidation'
    end

    def parent_ticket
      ticket.parent || ticket
    end

    def create_ticket_password
      if parent_ticket.create_password?
        parent_ticket.create_password
        notify
      end
    end

    def current_user_or_ticket
      current_user || current_ticket
    end

    # atualiza o filho e seu pai
    def update_sou_evaluation_in_ticket(ticket, action = true)
      Ticket.where(id: [ticket.id, ticket.parent.id]).update(marked_internal_evaluation: action)
    end

  end
end
