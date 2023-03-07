module TransferDepartmentsHelper

  def ticket_department_associated(ticket, user)
    TicketDepartment.where(ticket: ticket, department: user.department).take
  end

end
