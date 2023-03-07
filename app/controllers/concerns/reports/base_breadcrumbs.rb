module ::Reports::BaseBreadcrumbs

  protected

  def index_breadcrumbs
    [
      home_breadcrumb,
      reports_home_breadcrumb,
      [ t("operator.reports.#{report_type}.index.title"), "" ]
    ]
  end

  def new_create_breadcrumbs
    [
      home_breadcrumb,
      reports_home_breadcrumb,
      report_type_index_breadcrumb,
      [ t("operator.reports.#{report_type}.new.title"), "" ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      reports_home_breadcrumb,
      report_type_index_breadcrumb,
      [ report_title, "" ]
    ]
  end

  private

  def home_breadcrumb
    [ t("operator.home.index.title"), operator_root_path ]
  end

  def reports_home_breadcrumb
    [ t("operator.reports.home.index.title"), operator_reports_root_path ]
  end

  def report_type_index_breadcrumb
    [ t("operator.reports.#{report_type}.index.title"), reports_type_index_path ]
  end

  def reports_type_index_path
    url_for([:operator, :reports, report_type, only_path: true])
  end

  def report_title
    # usado para :ticket_reports e :gross_exports. ticket_stats tem uma
    # index próprio e definida em seu próprio breadcrumb.

    report.title
  end
end
