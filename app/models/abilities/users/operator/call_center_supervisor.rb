class Abilities::Users::Operator::CallCenterSupervisor < Abilities::Users::Operator::CallCenter

  def initialize(user)
    can_letter_answer_option(user)
    can_phone_answer_option(user)

    super
    can_manage_attendance_reports
    can_manage_evaluation_exports
    can_manage_ticket_reports
  end

  private

  def can_manage_attendance_reports
    can [:index, :create], AttendanceReport
  end
end
