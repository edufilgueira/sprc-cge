class Attendance::CloneService

  PERMITTED_PARAMS = %w(
    service_type
    description
    answer
    unknown_organ
  )

  PERMITTED_TICKET_PARAMS = %w(
    description
    ticket_type
    sou_type
    answer_type
    city_id
    used_input
    person_type

    denunciation_organ_id
    denunciation_description
    denunciation_date
    denunciation_place
    denunciation_assurance
    denunciation_witness
    denunciation_evidence
    denunciation_against_operator
  )

  def self.call(user, attendance_id, new_attendance_id)
    new.call(user, attendance_id, new_attendance_id)
  end

  def call(user, attendance_id, new_attendance_id)
    cloned_attendance = Attendance.find_by(id: new_attendance_id)
    attendance = Attendance.find_by(id: attendance_id)

    cloned_attendance = clone_attendance(user, attendance, cloned_attendance)
    add_ticket(cloned_attendance, attendance)
    add_organs_subnets(cloned_attendance, attendance)
    cloned_attendance
  end

  private

  def clone_attendance(user, attendance, cloned_attendance)
    cloned_attendance.created_by = user
    cloned_attendance.save(validate: false)

    cloned_attendance.assign_attributes(attendance.attributes.slice(*PERMITTED_PARAMS))

    cloned_attendance
  end

  def add_ticket(cloned_attendance, attendance)
    build_ticket(cloned_attendance)

    cloned_attendance.ticket.assign_attributes(attendance.ticket.attributes.slice(*PERMITTED_TICKET_PARAMS))
    cloned_attendance.ticket.person_type = nil if cloned_attendance.ticket.anonymous?
    cloned_attendance.ticket.internal_status = :in_filling
  end

  def build_ticket(cloned_attendance)
    cloned_attendance.build_ticket(answer_type: :phone, used_input: :phone_155) unless cloned_attendance.ticket.present?


    cloned_attendance.ticket.build_classification unless cloned_attendance.ticket.classification.present?
  end

  def add_organs_subnets(cloned_attendance, attendance)
    attendance.attendance_organ_subnets.each do |aos|
       cloned_attendance.attendance_organ_subnets.build(organ_id: aos.organ_id, subnet_id: aos.subnet_id, unknown_subnet: aos.unknown_subnet)
    end
  end
end
