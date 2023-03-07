class MailTicketDeadlineWorker
  include Sidekiq::Worker

  def perform
    Ticket::Deadline::Mailer.call
  end
end

