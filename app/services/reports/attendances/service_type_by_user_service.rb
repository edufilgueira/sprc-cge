class Reports::Attendances::ServiceTypeByUserService < Reports::Attendances::BaseService

  private

  def presenter
    @presenter ||= Reports::Attendances::ServiceTypeByUserPresenter.new(default_scope)
  end

  def build_sheet(sheet)
    add_header(sheet)

    users.each do |user|
      xls_add_row(sheet, presenter.row(user))
    end
  end

  def sheet_type
    :service_type_by_user
  end

  def default_scope
    Attendance.where(created_at: date_range)
  end

  def service_types
    Attendance.service_types.keys
  end

  def service_type_str(service_type)
    Attendance.human_attribute_name("service_type.#{service_type}")
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    [header_name] + service_type_headers
  end

  def header_name
    I18n.t("services.reports.attendances.service_type_by_user.headers.name")
  end

  def service_type_headers
    service_types.map { |service_type| service_type_str(service_type) }
  end
end

