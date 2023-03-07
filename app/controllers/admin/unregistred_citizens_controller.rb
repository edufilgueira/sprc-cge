class Admin::UnregistredCitizensController < Admin::BaseCrudController
  include Admin::UnregistredCitizens::Breadcrumbs

  FILTERED_ENUMS = [
    :person_type
  ]

  SORT_COLUMNS = {
    name: 'tickets.name',
    email: 'tickets.email'
  }

  TICKET_SEARCH_EXPRESSION = %q{
    LOWER(tickets.name) LIKE LOWER(:search) OR
    LOWER(tickets.email) LIKE LOWER(:search)
  }

  helper_method [:tickets, :ticket]

  # Helper methods

  def tickets
    paginated_resources
  end

  def ticket
    resource
  end

  def resource_symbol
    'ticket'
  end

  # Private

  private

  def resource_klass
    Ticket
  end

  def default_sort_scope
    resource_klass.where(anonymous: false, created_by: nil)
  end

  def default_sort_column
    'tickets.name'
  end
end
