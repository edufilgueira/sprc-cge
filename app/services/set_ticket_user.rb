class SetTicketUser

  attr_accessor :ticket, :user

  def self.call(ticket_id)
    new(ticket_id).call
  end

  def initialize(ticket_id)
    @ticket = Ticket.find(ticket_id)
    @user = User.find_by(document: document)
  end

  def call
    set_created_by
  end


  private

  def set_created_by
    ticket.update_attributes(created_by: user) if user.present?
  end

  def document
    ticket.document
  end

end
