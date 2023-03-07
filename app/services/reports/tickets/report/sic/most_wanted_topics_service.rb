class Reports::Tickets::Report::Sic::MostWantedTopicsService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::MostWantedTopicsPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.most_wanted_topics.call_center_topic_demand_count') ])
    presenter.call_center_topic_demand_count.each do |topic, demand|
      xls_add_row(sheet, [ topic, demand ]) if topic.present?
    end

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.most_wanted_topics.topics_by_organs_demand_count') ])
    presenter.topics_by_organs_demand_count.each do |result|
      xls_add_row(sheet, [ result[:organ_acronym], result[:organ_demand] , result[:topics]])
    end
  end

  def sheet_type
    :most_wanted_topics
  end
end
