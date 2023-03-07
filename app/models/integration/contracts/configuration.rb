class Integration::Contracts::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :schedule,
    presence: true

  validates :contract_operation,
    :contract_response_path,
    :additive_operation,
    :additive_response_path,
    :adjustment_operation,
    :adjustment_response_path,
    presence: true

  validates :financial_operation,
    :financial_response_path,
    :infringement_operation,
    :infringement_response_path,
    presence: true

end
