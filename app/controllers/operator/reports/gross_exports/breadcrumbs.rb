module Operator::Reports::GrossExports::Breadcrumbs
  include ::Reports::BaseBreadcrumbs

  private

  def report_type
    :gross_exports
  end

  def report
    gross_export
  end
end
