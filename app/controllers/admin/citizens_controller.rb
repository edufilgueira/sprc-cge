class Admin::CitizensController < Admin::BaseCrudController
  include Admin::Citizens::Breadcrumbs
  include Admin::FilterDisabled

  FILTERED_ENUMS = [
    :person_type
  ]

  SORT_COLUMNS = {
    name: 'users.name',
    email: 'users.email'
  }

  helper_method [:users, :user]

  # Helper methods

  def users
    paginated_resources
  end

  def user
    resource
  end

  def resource_symbol
    'user'
  end

  # Private

  private

  def resource_klass
    User
  end

  def default_sort_scope
    User.user
  end
end
