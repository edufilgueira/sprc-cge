#
# Representa a exportação de chamados.
#
class GrossExport < ApplicationRecord
  include ::Reportable
  include Operator::Reports::GrossExports::Filters

  def sorted_tickets
    self.user.operator_accessible_tickets_for_report
  end
end
