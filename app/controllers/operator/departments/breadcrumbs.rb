module Operator::Departments::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('operator.home.index.title'), operator_root_path],
      [t('.title'), '']
    ]
  end

  def new_create_breadcrumbs
    [
      [t('operator.home.index.title'), operator_root_path],
      [t('operator.departments.index.title'), operator_departments_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('operator.home.index.title'), operator_root_path],
      [t('operator.departments.index.title'), operator_departments_path],
      [department.title, '']
    ]
  end
end
