module Operator::SouEvaluationSamples::GeneratedLists::Breadcrumbs
  
  def index_breadcrumbs
    [
      [t('app.home'), '/'],
      [t('operator.tickets.index.sou_evaluation_samples.breadcrumb_title'), operator_sou_evaluation_samples_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('app.home'), '/'],
      [t('operator.tickets.index.sou_evaluation_samples.breadcrumb_title'), operator_sou_evaluation_samples_path],
      [t('operator.tickets.show.sou_evaluation_samples.breadcrumb_title'), operator_generated_lists_path],
      [t('operator.tickets.show.sou_evaluation_sample_details.breadcrumb_title'), '']
    ]
  end

end
