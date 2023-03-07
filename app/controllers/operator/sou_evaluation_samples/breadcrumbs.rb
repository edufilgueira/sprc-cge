module Operator::SouEvaluationSamples::Breadcrumbs
  
  def index_breadcrumbs
    [
      [t('app.home'), operator_root_path],
      [t('.index.title'), '']
    ]
  end

end
