class Reports::Tickets::Report::Sou::DenunciationTypeService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::DenunciationTypePresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    denunciation_types = [
      :in_favor_of_the_state,
      :against_the_state,
      :without_type
    ]

    denunciation_types.each do |denunciation_type|
      total_denunciation_type = presenter.denunciation_type_count(denunciation_type)
      xls_add_row(sheet, [ presenter.denunciation_type_name(denunciation_type), total_denunciation_type, presenter.denunciation_type_percentage(total_denunciation_type) ])
    end

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [presenter.denunciation_type_name(:total), presenter.denunciation_type_count(:total)])
  end

  def sheet_type
    :denunciation_type
  end
end
