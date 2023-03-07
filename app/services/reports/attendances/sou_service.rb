class Reports::Attendances::SouService < Reports::Attendances::BaseService

  private

  def attendances_by_user_presenter
    @attendances_by_user_presenter ||= Reports::Attendances::AttendancesByUserPresenter.new(sou_scope)
  end

  def phone_returned_by_user_presenter
    @phone_returned_by_user_presenter ||= Reports::Attendances::PhoneReturnedByUserPresenter.new(attendance_response_scope)
  end

  def whatsapp_returned_by_user_presenter
    @whatsapp_returned_by_user_presenter ||= Reports::Attendances::WhatsappReturnedByUserPresenter.new(attendance_response_scope)
  end

  def sheet_type
    :sou
  end

  def sou_scope
    default_scope.where(service_type: [:sou_forward, :no_characteristic])
  end
end

