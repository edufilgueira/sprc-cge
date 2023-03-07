class Admin::HolidaysController < Admin::BaseCrudController
  include Admin::Holidays::Breadcrumbs

  PERMITTED_PARAMS = [
    :title,
    :day,
    :month
  ]

  SORT_COLUMNS = {
    month: 'holidays.month',
    day: 'holidays.day',
    title: 'holidays.title'
  }

  helper_method [:holidays, :holiday]

  #  Helper methods

  def holidays
    paginated_resources
  end

  def holiday
    resource
  end
end
