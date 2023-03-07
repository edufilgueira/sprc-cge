module Operator::Reports::Home::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [ t('operator.home.index.title'), operator_root_path ],
      [ t('operator.reports.home.index.title'), '' ]
    ]
  end

end
