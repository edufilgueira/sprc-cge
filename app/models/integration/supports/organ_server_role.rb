class Integration::Supports::OrganServerRole < ApplicationDataRecord

  # Associations

  belongs_to :role,
    foreign_key: 'integration_supports_server_role_id',
    class_name: 'Integration::Supports::ServerRole'

  belongs_to :organ,
    foreign_key: 'integration_supports_organ_id',
    class_name: 'Integration::Supports::Organ'

  # Validations

  ## Presence

  validates :role,
    :organ,
    presence: true


  validates :integration_supports_server_role_id,
    uniqueness: { scope: :integration_supports_organ_id }

end
