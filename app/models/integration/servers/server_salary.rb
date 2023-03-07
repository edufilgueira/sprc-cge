class Integration::Servers::ServerSalary < ApplicationDataRecord
  include Integration::Servers::ServerSalary::Search
  include ::Sortable

  # Enums

  enum status: [
    :civil_active,
    :militar_active,
    :civil_away_with_onus,
    :militar_away_with_onus,
    :civil_away_without_onus,
    :militar_away_without_onus,
    :pensioner,
    :food_pension,
    :injunction
  ]

  enum functional_status: [
    :functional_status_active,
    :functional_status_retired,
    :functional_status_pensioner,
    :functional_status_intern
  ]

  # Associations

  belongs_to :registration,
    foreign_key: 'integration_servers_registration_id',
    class_name: 'Integration::Servers::Registration'

  has_one :server, through: :registration
  has_one :organ, through: :registration

  belongs_to :role,
    foreign_key: 'integration_supports_server_role_id',
    class_name: 'Integration::Supports::ServerRole'

  # Validations

  ## Presence

  validates :integration_servers_registration_id,
    uniqueness: { scope: [:date] },
    presence: true

  validates :date,
    :registration,
    presence: true

  # Delegations

  delegate :title, to: :organ, prefix: true, allow_nil: true
  delegate :sigla, to: :organ, prefix: true, allow_nil: true
  delegate :name, to: :role, prefix: true, allow_nil: true

  # Scopes

  def self.from_date(date)
    # Date é sempre 01/MM/YYYY.

    where(date: date)
  end

  def self.with_active_registrations
    joins(:registration).where('integration_servers_registrations.active_functional_status': true)
  end

  # Sortable

  def self.default_sort_column
    'integration_servers_server_salaries.server_name'
  end

  def self.default_sort_direction
    :asc
  end

  #
  # Retorna os registros de salário do servidor passado como parâmetro.
  #
  def self.from_server(server)
    with_server.where(integration_servers_servers: { id: server.id })
  end

  # Helpers

  def title
    server_name
  end

  def functional_status_enum
    return "" unless any_functional_status_str.present?
    I18n.t("#{any_functional_status_str}")
  end

  def any_functional_status_str
    #Procura na competencia do mes (ServerSalary) caso não ache, vai p registration
    @functional_status ||= functional_status_str || registration.functional_status_str
    @functional_status
  end


  private

  def self.with_server
    joins({ registration: :server })
  end
end
