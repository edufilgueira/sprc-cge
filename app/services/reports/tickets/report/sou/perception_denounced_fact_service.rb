class Reports::Tickets::Report::Sou::PerceptionDenouncedFactService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::PerceptionDenouncedFactPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    list_generate(sheet)

    label = I18n.t("services.reports.tickets.sou.perception_denounced_fact.total")
    xls_add_row(sheet, [ label, presenter.total_count ])
  end

  def sheet_type
    :perception_denounced_fact
  end

  def list_generate(sheet)
    denunciation_assurance_keys.each do |denunciation_assurance|
      title   = presenter.denunciation_assurance_str(denunciation_assurance)
      count   = presenter.denunciation_assurance_count(denunciation_assurance)
      percent = presenter.denunciation_assurance_percentage(denunciation_assurance)
      xls_add_row(sheet, [title , count, percent])
    end
  end

  def denunciation_assurance_keys
    Ticket.available_denunciation_assurances.keys
  end
end
