class Integration::Supports::Creditor::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :operation,
    :response_path,
    :schedule,
    presence: true


  ## Customs

  validate :started_at_before_finished_at

  # Privates

  private

  def started_at_before_finished_at
    errors.add(:finished_at, :youngest) if started_at_after_finished_at?
  end

  def started_at_after_finished_at?
    started_at.present? && finished_at.present? && started_at > finished_at
  end
end
