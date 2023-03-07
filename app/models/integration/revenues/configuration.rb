class Integration::Revenues::Configuration < Integration::BaseConfiguration

  #  Associations

  has_many :account_configurations,
    foreign_key: 'integration_revenues_configuration_id',
    inverse_of: :configuration

  # Nesteds

  accepts_nested_attributes_for :account_configurations, reject_if: :all_blank, allow_destroy: true

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :operation,
    :response_path,
    :schedule,
    presence: true

end
