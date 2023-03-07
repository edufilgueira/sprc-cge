class Operator::Reports::EvaluationExportsController < OperatorController
  include ::PaginatedController
  include ::FilteredController
  include Operator::Reports::EvaluationExports::Breadcrumbs
  include ::Operator::BaseTicketSpreadsheetController

  PERMITTED_PARAMS = [
    :title,
    filters: [
      :sou_type,
      :used_input,
      :ticket_type,
      :organ,
      :subnet,
      confirmed_at: [
        :start,
        :end
      ]
    ]
  ]

  helper_method [:evaluation_exports, :evaluation_export]

  before_action :can_create_export, only: :create

  # Actions

  def create
    evaluation_export.status = :preparing
    ensure_confirmed_at_presence
    ensure_organ_presence

    super

    generate_spreadsheet
  end


  # Helper methods

  def evaluation_exports
    paginated(filtered_resources)
  end

  def evaluation_export
    resource
  end

  private

  def resources
    @resources ||= current_user.evaluation_exports
  end

  def new_resource
    @new_resource = resources.new(resource_params)
    ensure_ticket_type_presence
    @new_resource.user = current_user
    @new_resource
  end

  def generate_spreadsheet
    if evaluation_export.persisted? && evaluation_export.valid?
      Reports::Tickets::EvaluationsService.delay.call(evaluation_export.id)
    end
  end

  def can_create_export
    authorize! :create, evaluation_export
  end

  def ensure_ticket_type_presence
    if current_user.sic_sectoral?
      @new_resource.filters[:ticket_type] = :sic
    elsif current_user.sou_sectoral? && !current_user.acts_as_sic?
      @new_resource.filters[:ticket_type] = :sou
    end
  end

  def ensure_organ_presence
    evaluation_export.filters[:organ] = current_user.organ.id if current_user.sectoral?
    evaluation_export.filters[:subnet] = current_user.subnet.id if current_user.subnet_operator?
  end

  def ensure_confirmed_at_presence
    evaluation_export.filters[:confirmed_at] = {} unless evaluation_export.filters[:confirmed_at].present?

    unless evaluation_export.filters[:confirmed_at][:start].present?
      evaluation_export.filters[:confirmed_at][:start] = Ticket.first_confirmed_date
    end

    unless evaluation_export.filters[:confirmed_at][:end].present?
      evaluation_export.filters[:confirmed_at][:end] = Date.today
    end
  end
end
