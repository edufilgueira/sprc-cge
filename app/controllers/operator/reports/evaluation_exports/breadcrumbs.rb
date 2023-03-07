module Operator::Reports::EvaluationExports::Breadcrumbs
  include ::Reports::BaseBreadcrumbs

  private

  def report_type
    :evaluation_exports
  end

  def report
    evaluation_export
  end
end
