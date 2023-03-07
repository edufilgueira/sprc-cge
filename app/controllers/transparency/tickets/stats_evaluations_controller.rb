class Transparency::Tickets::StatsEvaluationsController < TransparencyController
  include Transparency::Tickets::StatsEvaluations::Breadcrumbs

  helper_method [:stats_evaluations]

  # actions

  def create
    UpdateStatsEvaluation.delay.call(year, month, param_evaluation_type)

    set_success_flash_notice

    redirect_to transparency_tickets_stats_evaluations_path(params_to_redirect)
  end

  # helpers

  def stats_evaluations
    resources.from_year_month_type(year, month, param_evaluation_type)
  end


  # privates

  private

  def year
    param_month_year&.second || last_month.year
  end

  def month
    param_month_year&.first || last_month.month
  end

  def param_month_year
    params[:month_year]&.split('/')
  end

  def params_to_redirect
    {
      month_year: "#{month}/#{year}",
      evaluation_type: param_evaluation_type
    }
  end

  def last_month
    Date.today.last_month
  end

  def param_evaluation_type
    params[:evaluation_type] || 'sou'
  end

  def resource_klass
    Stats::Evaluation
  end
end
