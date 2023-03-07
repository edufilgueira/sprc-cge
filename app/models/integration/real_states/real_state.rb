class Integration::RealStates::RealState < ApplicationDataRecord
  include ::Integration::RealStates::RealState::Search
  include ::Sortable

  # SPRC-DATA Associations

  belongs_to :manager,
              -> { where('integration_supports_organs.orgao_sfp = ? AND integration_supports_organs.data_termino IS NULL', false) },
              class_name: 'Integration::Supports::Organ'

  belongs_to :property_type,
              class_name: 'Integration::Supports::RealStates::PropertyType'

  belongs_to :occupation_type,
              class_name: 'Integration::Supports::RealStates::OccupationType'


  # SPRC-DATA Validations

  validates :municipio,
            :service_id,
            presence: true


  # SPRC-DATA Delegations

  delegate :title, to: :property_type, prefix: true, allow_nil: true
  delegate :title, to: :occupation_type, prefix: true, allow_nil: true
  delegate :title, to: :manager, prefix: true, allow_nil: true

  # Sortable

  def self.default_sort_column
    'integration_real_states_real_states.id'
  end

  def self.default_sort_direction
    :asc
  end

  # SPRC methods
  def title
    descricao_imovel
  end
end
