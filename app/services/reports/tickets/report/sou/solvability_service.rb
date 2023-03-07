class Reports::Tickets::Report::Sou::SolvabilityService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::SolvabilityPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    solubilities = [
      :final_answers_in_deadline,
      :final_answers_out_deadline,
      :attendance_in_deadline,
      :attendance_out_deadline
    ]

    solubilities.each do |solvability|
      total_solvability = presenter.solvability_count(solvability)
      xls_add_row(sheet, [ presenter.solvability_name(solvability), total_solvability, presenter.solvability_percentage(total_solvability) ])
    end

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [ presenter.solvability_name(:total), presenter.solvability_count(:total), presenter.resolubility ])
  end

  def sheet_type
    :solvability
  end
end
