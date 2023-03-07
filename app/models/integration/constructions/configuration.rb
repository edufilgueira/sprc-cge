class Integration::Constructions::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :user,
    :password,
    :der_wsdl,
    :dae_wsdl,
    :schedule,
    presence: true

  validates :der_operation,
    :der_response_path,
    :dae_operation,
    :dae_response_path,
    presence: true

end
