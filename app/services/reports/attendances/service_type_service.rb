class Reports::Attendances::ServiceTypeService < Reports::Attendances::BaseService

  private

  def presenter
    @presenter ||= Reports::Attendances::ServiceTypePresenter.new(default_scope)
  end

  def build_sheet(sheet)
    add_header(sheet)

    service_types.each do |service_type|
      xls_add_row(sheet, [ service_type_str(service_type), presenter.count(service_type) ])
    end
  end

  def sheet_type
    :service_type
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
end

