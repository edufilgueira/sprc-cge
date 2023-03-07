class Operator::Tickets::ClassificationsController < OperatorController
  include ::Classifications::BaseController
  include Operator::Tickets::Classifications::Breadcrumbs

  before_action :can_classify_ticket

  PERMITTED_PARAMS = [
    :topic_id,
    :subtopic_id,
    :department_id,
    :sub_department_id,
    :budget_program_id,
    :service_type_id,
    :other_organs
  ]

  helper_method [:ticket, :classification]

  before_action :set_updated_by

  def create
    if classification.save
      register_logs(:create_classification)
      redirect_to_ticket
    else
      return render_remote_form if request.xhr?

      flash.now[:alert] = t('.fail')
      render :new
    end

  end

  def update
    if classification.update_attributes(classification_params)
      register_logs(:update_classification)
      redirect_to_ticket
    else
      return render_remote_form if request.xhr?

      flash.now[:alert] = t('.fail')
      render :edit
    end
  end

  def edit
    render_remote_form if request.xhr?
  end

  def new
    render_remote_form if request.xhr?
  end

  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  def classification
    @classification ||= ticket.classification || ticket.build_classification(classification_params)
  end

  def set_updated_by
    ticket.updated_by = current_user
  end

  # Private

  private

  def classification_params
    if params[:classification]
      params.require(:classification).permit(PERMITTED_PARAMS)
    end
  end

  def can_classify_ticket
    authorize! :classify, ticket
  end

  def show_partial_view_path
    'show'
  end

  def redirect_to_ticket
    return render_remote_show if request.xhr?

    redirect_to operator_ticket_path(ticket, anchor: 'tabs-classification'), notice: t('.done')
  end

  def render_remote_form
    render partial: 'form', locals: { remote: true }
  end

  def render_remote_show
    render partial: 'show'
  end

  def register_logs(action)
    register_log(ticket, action, ticket)
    register_log(ticket.parent, action, ticket) if ticket.child?
  end

  def register_log(ticket, action, resource)
    RegisterTicketLog.call(ticket, current_user, action, { resource: resource, data: data_attributes })
  end

  def data_attributes
    {
      items: {
        topic_name: resource.topic_name,
        subtopic_name: resource.subtopic_name,
        department_name: resource.department_name,
        sub_department_name: resource.sub_department_name,
        budget_program_name: resource.budget_program_name,
        service_type_name: resource.service_type_name
      }
    }
  end

end
