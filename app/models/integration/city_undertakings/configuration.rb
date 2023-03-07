class Integration::CityUndertakings::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :undertaking_operation,
    :undertaking_response_path,
    :city_undertaking_operation,
    :city_undertaking_response_path,
    :city_organ_operation,
    :city_organ_response_path,
    :schedule,
    presence: true

  # Instace methods

end
