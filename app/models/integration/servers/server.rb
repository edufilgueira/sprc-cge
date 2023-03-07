class Integration::Servers::Server < ApplicationDataRecord
   include Integration::Servers::Server::Search

  # Associations

  has_many :registrations,
    foreign_key: 'dsc_cpf',
    primary_key: 'dsc_cpf',
    dependent: :destroy

  has_many :proceeds, through: :registrations

  has_many :server_salaries, through: :registrations

  # Validations

  ## Presence

  validates :dsc_funcionario,
    :dsc_cpf,
    presence: true

end
