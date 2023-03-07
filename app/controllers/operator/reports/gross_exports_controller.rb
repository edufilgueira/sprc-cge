class Operator::Reports::GrossExportsController < OperatorController
  include ::FilteredController
  include ::PaginatedController

  include ::Operator::BaseTicketSpreadsheetController
  include Operator::Reports::GrossExports::Breadcrumbs

  PERMITTED_PARAMS = [
    :title,
    :load_creator_info,
    :load_description,
    :load_answers,
    filters: [
      :ticket_type,
      :expired,
      :organ,
      :subnet,
      :budget_program,
      :topic,
      :subtopic,
      :deadline,
      :rede_ouvir_scope,
      :departments_deadline,
      :priority,
      :internal_status,
      :search,
      :parent_protocol,
      :department,
      :sub_department,
      :service_type,
      :denunciation,
      :sou_type,

      confirmed_at: [
        :start,
        :end
      ]
    ]
  ]

  FILTERED_ENUMS = [ :status ]

  helper_method [:gross_exports, :gross_export]

  # Actions

  # index e show são implementadas em:
  # ::Operator::BaseTicketSpreadsheetController

  def create
    gross_export.status = :preparing
    gross_export.user = current_user
    ensure_ticket_type_presence
    ensure_confirmed_at_presence

    if validate_gross_export
      super
      generate_spreadsheet
    else
      gross_export.errors.add(:base, :big_range)
      render :new
    end
  end

  # Helper methods

  def gross_exports
    @gross_exports ||= paginated_gross_exports
  end

  def gross_export
    resource
  end

  private

  def validate_gross_export
    final_date = gross_export.filters[:confirmed_at][:end].to_date
    initial_date = gross_export.filters[:confirmed_at][:start].to_date
    interval_in_days = (final_date - initial_date).to_i.days

    interval_in_days <= 366.days
  end

  def paginated_gross_exports
    paginated(sorted_gross_exports)
  end

  def sorted_gross_exports
    current_user.gross_exports.sorted
  end

  def ensure_ticket_type_presence
    gross_export.filters[:ticket_type] ||= :sic
  end

  def ensure_confirmed_at_presence
    gross_export.filters[:confirmed_at] = {} unless gross_export.filters[:confirmed_at].present?

    unless gross_export.filters[:confirmed_at][:start].present?
      gross_export.filters[:confirmed_at][:start] = Ticket.first_confirmed_date
    end

    unless gross_export.filters[:confirmed_at][:end].present?
      gross_export.filters[:confirmed_at][:end] = Date.today
    end
  end

  def generate_spreadsheet
    if gross_export.persisted? && gross_export.valid?
      CreateGrossExportSpreadsheet.call(gross_export.id)
    end
  end
end
