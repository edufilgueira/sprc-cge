class EmailSatisfactionSurveyService
  def self.call
    new.call
  end

  def call
    answers.each do |answer|
      Notifier::SatisfactionSurvey.delay.call(answer.id)
    end
  end

  private

  def answers
    answers = Answer.joins(ticket: :classification)
      .final
      .where(answers: { status: [:cge_approved, :sectoral_approved] })
      .where('date(answers.updated_at) = ?', Date.today - 2.days)
      .where.not('classifications.other_organs = ? OR tickets.organ_id = ?', true, ExecutiveOrgan.dpge.id)
      .where.not('classifications.topic_id = ?', Topic.only_no_characteristic.id)
    answers.select { |answer|
      answer.status == 'cge_approved' || ( answer.status == 'sectoral_approved' && answer.ticket.organ.try(:ignore_cge_validation) == true )
    }
  end
end