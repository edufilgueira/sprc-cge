class Integration::Supports::ServerRole < ApplicationDataRecord
  include Integration::Supports::ServerRole::Search

  # Associations

  has_many :server_salaries,
    foreign_key: 'integration_supports_server_role_id',
    class_name: 'Integration::Servers::ServerSalary'

  has_many :organ_server_roles,
    foreign_key: 'integration_supports_server_role_id',
    class_name: 'Integration::Supports::OrganServerRole'

  has_many :organs, through: :organ_server_roles

  # Validations

  ## Presence

  validates :name,
    presence: true

  # Scopes

  def self.sorted
    order(:name)
  end

  def title
    name
  end
end
