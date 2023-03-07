class Admin::Integrations::Supports::CreditorsController < AdminController
  include Admin::Integrations::Supports::Creditors::Breadcrumbs
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController

  SORT_COLUMNS = [
    'integration_supports_creditors.nome',
    'integration_supports_creditors.codigo',
    'integration_supports_creditors.status'
  ]

  helper_method [:creditors, :creditor]

  # Helper methods

  def creditors
    paginated_creditors
  end

  def creditor
    resource
  end


  # Private

  private

  def paginated_creditors
    paginated(filtered_creditors)
  end

  def filtered_creditors
    filtered(Integration::Supports::Creditor, sorted_creditors)
  end

  def sorted_creditors
    resources.sorted(sort_column, sort_direction)
  end

  def default_sort_column
    Integration::Supports::Creditor.default_sort_column
  end

  def default_sort_direction
    Integration::Supports::Creditor.default_sort_direction
  end

  def resource_klass
    Integration::Supports::Creditor
  end

end
