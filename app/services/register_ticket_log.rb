#
# Serviço responsável por registrar eventos no ticket
#
# @params
# - ticket        :  Ticket
# - responsible   :  User || Ticket || .....
# - action        :  TicketLog#actions
# - attributes    :  Hash
#
class RegisterTicketLog

  attr_reader :ticket_log

	def self.call(ticket, responsible, action, attributes = {})
    new.call(ticket, responsible, action, attributes)
  end

  def initialize
    @ticket_log = TicketLog.new
  end

  def call(ticket, responsible, action, attributes = {})
    @ticket_log.ticket = ticket
    @ticket_log.responsible = responsible
    @ticket_log.action = action

    assign_attributes(attributes)

    @ticket_log.save
  end

  private

  def assign_attributes(attributes)
    attributes.each do |key, value|
      @ticket_log.send("#{key}=", value) if @ticket_log.respond_to?("#{key}=")
    end
  end

end
