module Operator::SubnetDepartments::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      home_breadcrumb,
      [ t('.title', organ_acronym: organ.acronym), '' ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      [ t('operator.subnet_departments.index.title', organ_acronym: organ.acronym), operator_subnet_departments_path ],
      [ department.title, '' ]
    ]
  end

  private

  def home_breadcrumb
    [ t('operator.home.index.title'), operator_root_path ]
  end
end
