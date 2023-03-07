class Operator::SubnetDepartmentsController < Operator::BaseCrudController
  include ::Operator::SubnetDepartments::Breadcrumbs

  SORT_COLUMNS = {
    subnet_acronym: 'subnets.acronym',
    name: 'departments.name'
  }

  helper_method [:departments, :filtered_resources, :department, :organ]

  def index
    if print?
      render template: 'operator/subnet_departments/print/index', layout: 'print'
    else
      super
    end
  end

  def show
    if print?
      render template: 'operator/subnet_departments/print/show', layout: 'print'
    else
      super
    end
  end

  private

  def department
    resource
  end

  def departments
    paginated_resources
  end

  def organ
    current_user.organ
  end

  def resources
    @resources ||= organ.subnet_departments
  end

  def default_sort_column
    Subnet.default_sort_column
  end

  def default_sort_scope
    resources
  end

  def resource_name
    'department'
  end
end
