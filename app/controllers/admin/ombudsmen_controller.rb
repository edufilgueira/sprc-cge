class Admin::OmbudsmenController < Admin::BaseCrudController
  include Admin::Ombudsmen::Breadcrumbs

  PERMITTED_PARAMS = [
    :title,
    :contact_name,
    :phone,
    :email,
    :address,
    :operating_hours,
    :kind
  ]

  FILTERED_ENUMS = [
    :kind
  ]

  SORT_COLUMNS = {
    title: 'ombudsmen.title',
    email: 'ombudsmen.email',
    kind: 'ombudsmen.kind'
  }

  helper_method [:ombudsman, :ombudsmen]

  def ombudsmen
    paginated_resources
  end

  def ombudsman
    resource
  end
end
