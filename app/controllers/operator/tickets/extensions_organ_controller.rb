#
# Controller responsável por solicitação, cancelar, aprovar ou rejeitar prorrogações de prazo
# - Operadores setoriais podem solicitar e cancelar prorrogações
# - Operadores dirigentes podem aprovar ou reprovar estas solicitações
#
class Operator::Tickets::ExtensionsOrganController < OperatorController
  include Operator::Tickets::ExtensionsOrgan::Breadcrumbs
  include Extensions::BaseController

  before_action :can_approve, only: :approve
  before_action :can_reject, only: :reject

  FIND_ACTIONS = FIND_ACTIONS + ['approve', 'reject']

  PERMITTED_PARAMS = [ :description ]


  # Helpers

  helper_method [:ticket, :extension]


  # Actions

  def create
    if start_extension
      register_log && notify
      redirect_to operator_ticket_path(ticket), notice: t('.done')
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  def update
    extension.cancelled!
    register_log

    redirect_to operator_ticket_path(ticket), notice: t('.done')
  end

  def approve
    ApplicationRecord.transaction do
      extension.approved!
      extension.extend_deadline
      register_log
    end

    set_flash_notice_and_render_nothing
  end

  def reject
    if ensure_justification_and_save
      register_log

      set_flash_notice_and_render_nothing
    else
      render partial: 'operator/tickets/extension_alert'
    end
  end

  # Helpers methods

  def extension
    resource
  end

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end


  # Privates

  private

  def start_extension
    if resource_params.present?
      if ticket.extended?
        create_coordination_relation
        params = resource_params.merge(status: :in_progress, solicitation: 2)
      else
        create_chief_relation
        params = resource_params.merge(status: :in_progress)
      end

      extension.update_attributes(params)
    end
  end

  def create_chief_relation
    chiefs.each{ |chief| extension.extension_users.build(user: chief) }
  end

  def create_coordination_relation
    User.coordination.enabled.each do |coordination|
      extension.extension_users.build(user: coordination)
    end
  end

  def chiefs
    if ticket.subnet?
      User.subnet_chief.where(subnet: ticket.subnet)
    else
      User.chief.where(organ: ticket.organ)
    end.enabled
  end

  def resource_params
    if params[:extension]
      params.require(:extension).permit(PERMITTED_PARAMS)
    end
  end

  def resource_klass
    ticket.extensions
  end

  def can_approve
    authorize!(:approve_extension, ticket)
  end

  def can_reject
    authorize!(:reject_extension, ticket)
  end

  def notify
    Notifier::Extension.delay.call(extension.id, current_user.id)
    Notifier::Extension::Chief.delay.call(extension.id, current_user.id)
  end

  def set_flash_notice_and_render_nothing
    flash[:notice] = t('.done')
    head :ok
  end

end
