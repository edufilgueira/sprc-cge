class Integration::Constructions::Der::Measurement < Integration::BaseDataChange
  belongs_to :integration_constructions_der,
              class_name: 'Integration::Constructions::Der',
              foreign_key: 'integration_constructions_der_id'

  validates :integration_constructions_der,
            :id_obra,
            :id_medicao,
            presence: true
end
