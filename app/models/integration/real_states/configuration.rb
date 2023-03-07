class Integration::RealStates::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :operation,
    :response_path,
    :detail_operation,
    :detail_response_path,
    :schedule,
    presence: true

  # Instace methods

  ## Helpers

  def importer_class
    # Integration::RealStates::Importer
  end
end
