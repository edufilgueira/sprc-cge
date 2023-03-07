class Operator::Tickets::InvalidationsController < OperatorController
  include Operator::Tickets::Invalidations::Breadcrumbs

  before_action :can_invalidate_ticket, only: :create
  before_action :can_approve_invalidation_ticket, only: :approve
  before_action :can_reject_invalidation_ticket, only: :reject

  helper_method [:ticket, :new_comment]

  after_action :update_ticket_parent_status, only: :approve
  after_action :update_children_status, only: :create


  def create
    if justification_param.present?
      update_internal_status
      status = current_user.cge? || current_user.coordination? ? :approved : :waiting
      register_log(status, ticket) && notify
      redirect_to operator_ticket_path(ticket), notice: create_notice
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  def approve
    ticket.invalidated! 
    ticket_parent.invalidated!
    register_log(:approved, ticket)
    redirect_to operator_ticket_path(ticket_parent), notice: t('.done')
  end

  def reject
    if justification_reject.present?
      build_new_comment
      ticket.sectoral_attendance!
      register_log(:rejected, ticket)
      redirect_to operator_ticket_path(ticket_parent), notice: t('.done')
    else
      flash[:alert] = t('.fail')
      redirect_to operator_ticket_path(ticket_parent)
    end
  end


  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def justification_param
    params[:justification]
  end

  def new_comment
    @new_comment ||= Comment.new(commentable: ticket)
  end

  def justification_reject
    params[:comment][:description] if params[:comment].present?
  end

  private

  def build_new_comment
    params = { author: current_user, description: justification_reject, scope: :internal}

    new_comment.update_attributes(params)
  end

  def update_internal_status
    if current_user.cge? || current_user.coordination? || ticket.organ.id ==75
      ticket.invalidated!
      ticket_parent.invalidated!
    else
      ticket.awaiting_invalidation!
    end
  end

  def register_log(status, ticket)
    justification = justification_param || justification_reject
    data = { status: status, target_ticket_id: ticket.id }
    log_params = { description: justification , data: data}

    RegisterTicketLog.call(ticket, current_user, :invalidate, log_params) unless ticket.parent?
    RegisterTicketLog.call(ticket_parent, current_user, :invalidate, log_params)
  end

  def notify
    Notifier::Invalidate.delay.call(ticket.id, current_user.id)
  end

  def can_invalidate_ticket
    authorize! :invalidate, ticket
  end

  def can_approve_invalidation_ticket
    authorize! :approve_invalidation, ticket
  end

  def can_reject_invalidation_ticket
    authorize! :reject_invalidation, ticket
  end

  def update_ticket_parent_status
    return unless all_children_invalidated?

    ticket_parent.invalidated!
    register_log(:approved, ticket_parent)
  end

  def update_children_status
    return unless parent_cge_or_coordination?

    ticket_parent.tickets.each do |child|
      child.invalidated!

      register_log(:approved, child)
    end
  end

  def ticket_parent
    ticket.parent || ticket
  end

  def all_children_invalidated?
    ticket_parent.reload.tickets.all?(&:invalidated?)
  end

  def parent_cge_or_coordination?
    ticket.parent? && (current_user.cge? || current_user.coordination?)
  end

  def create_notice
    parent_cge_or_coordination? ? t('.done') : t('.request_done')
  end

end
