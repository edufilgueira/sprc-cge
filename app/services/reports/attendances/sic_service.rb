class Reports::Attendances::SicService < Reports::Attendances::BaseService

  private

  def attendances_by_user_presenter
    @attendances_by_user_presenter ||= Reports::Attendances::AttendancesByUserPresenter.new(sic_scope)
  end

  def phone_returned_by_user_presenter
    @phone_returned_by_user_presenter ||= Reports::Attendances::PhoneReturnedByUserPresenter.new(attendance_response_scope)
  end

  def whatsapp_returned_by_user_presenter
    @whatsapp_returned_by_user_presenter ||= Reports::Attendances::WhatsappReturnedByUserPresenter.new(attendance_response_scope)
  end

  def sheet_type
    :sic
  end

  def sic_scope
    default_scope.where(service_type: [:sic_forward, :sic_completed])
  end
end

