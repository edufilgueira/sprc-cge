class Integration::Expenses::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :npf_wsdl,
    :npf_operation,
    :npf_response_path,
    :npf_user,
    :npf_password,
    :ned_wsdl,
    :ned_operation,
    :ned_response_path,
    :ned_user,
    :ned_password,
    :nld_wsdl,
    :nld_operation,
    :nld_response_path,
    :nld_user,
    :nld_password,
    :npd_wsdl,
    :npd_operation,
    :npd_response_path,
    :npd_user,
    :npd_password,
    :budget_balance_wsdl,
    :budget_balance_operation,
    :budget_balance_response_path,
    :budget_balance_user,
    :budget_balance_password,
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
