class Integration::Results::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :strategic_indicator_operation,
    :strategic_indicator_response_path,
    :thematic_indicator_operation,
    :thematic_indicator_response_path,
    :schedule,
    presence: true


  # Privates

  private

  def importer_class
    # Integration::Results::Importer
  end
end
