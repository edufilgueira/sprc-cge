class TicketProtectAttachment < ApplicationRecord

  # Modelo que identifica quais são os ANEXOS do ticket pai
  # que ao serem compartilhados com outro orgão,
  # terão seu acesso protegido


  belongs_to :resource, polymorphic: true
  belongs_to :attachment
  belongs_to :user

  after_create :create_ticket_log

  def create_ticket_log
  	RegisterTicketLog.call(
      resource_ticket, 
      resource.created_by, 
      :ticket_protect_attachment,  
      { resource_type: 'TicketProtectAttachment', resource_id: id}
    )
  end

  def resource_ticket
    return resource if resource.class.name == 'Ticket'
    resource.ticket
  end

  # Orgão ou deptartamento afetado
  def organ_department_affected
    return resource.organ.name if ticket?
    return resource.department.name if ticket_department?
  end

  def ticket_department?
    resource_type == 'TicketDepartment'
  end

  def ticket?
    resource_type == 'Ticket'
  end

  def filename
    attachment.document_filename
  end
end