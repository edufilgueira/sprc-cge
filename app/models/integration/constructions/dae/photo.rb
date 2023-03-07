class Integration::Constructions::Dae::Photo < Integration::BaseDataChange
  belongs_to :integration_constructions_dae,
              class_name: 'Integration::Constructions::Dae',
              foreign_key: 'integration_constructions_dae_id'

  validates :integration_constructions_dae,
            :codigo_obra,
            :id_medicao,
            presence: true

end
