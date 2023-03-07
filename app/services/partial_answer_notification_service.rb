class PartialAnswerNotificationService
  def self.call
    new.call
  end

  def call
    organ_ids.each do |id|
      Notifier::PartialAnswer.delay.call(id)
    end
  end

  private

  def organ_ids
    tickets.distinct.pluck(:organ_id)
  end

  def tickets
    Ticket.where.not(parent_id: nil).partial_answer
  end
end
