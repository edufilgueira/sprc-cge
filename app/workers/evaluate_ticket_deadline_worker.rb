class EvaluateTicketDeadlineWorker
  include Sidekiq::Worker

  def perform
    Ticket::Deadline::Evaluate.delay.call
  end
end

