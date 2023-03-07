class Integration::CityUndertakings::CityUndertaking < ApplicationDataRecord
  include Integration::CityUndertakings::CityUndertaking::Search
  include ::Sortable

  enum expense: [:convenant, :contract]

  belongs_to :organ, -> { where('integration_supports_organs.orgao_sfp = ? AND integration_supports_organs.data_termino IS NULL', false) },
              class_name: 'Integration::Supports::Organ'

  belongs_to :creditor,
              class_name: 'Integration::Supports::Creditor'

  belongs_to :undertaking,
              class_name: 'Integration::Supports::Undertaking'


  belongs_to :contract,  optional: true, primary_key: 'isn_sic', foreign_key: 'sic', class_name: 'Integration::Contracts::Contract'
  belongs_to :convenant, optional: true, primary_key: 'isn_sic', foreign_key: 'sic', class_name: 'Integration::Contracts::Convenant'


  validates_presence_of :municipio
  validates_presence_of :mapp
  validates_presence_of :sic

  delegate :title, to: :organ, prefix: true, allow_nil: true
  delegate :title, to: :creditor, prefix: true, allow_nil: true
  delegate :title, to: :undertaking, prefix: true, allow_nil: true

  def self.default_sort_column
    'integration_contracts_contracts.data_assinatura'
  end

  def self.default_sort_direction
    :desc
  end

  def title
    undertaking_title
  end

  def self.default_scope
    #
    # Houve uma demanda da CGE para não exibir investimentos quando não houver contratos no WS (#1224)
    #
    joins('LEFT OUTER JOIN integration_contracts_contracts ON (integration_contracts_contracts.isn_sic = integration_city_undertakings_city_undertakings.sic)').where('integration_contracts_contracts.id IS NOT NULL')
  end

  #
  # Usado por controllers que possuem o filtro de Credor.
  #
  def self.creditors_name_column
    'integration_supports_creditors.nome'
  end
end
