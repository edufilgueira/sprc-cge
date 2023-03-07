class Integration::Results::StrategicIndicator < ApplicationDataRecord
  include ::Integration::Results::StrategicIndicator::Search
  include ::Sortable

  # SPRC-DATA Associations

  belongs_to :organ,
              -> { where('integration_supports_organs.orgao_sfp = ?', false) },
              class_name: 'Integration::Supports::Organ'

  belongs_to :axis,
              class_name: 'Integration::Supports::Axis'


  # SPRC-DATA Validations

  validates :eixo,
            :indicador,
            :sigla_orgao,
            :organ,
            :axis,
            presence: true


  # SPRC-DATA Delegations

  delegate :title, to: :organ, prefix: true, allow_nil: true
  delegate :sigla, to: :organ, prefix: true, allow_nil: true
  delegate :title, to: :axis, prefix: true


  # Default scope

  # XXX
  # XXX não devemos considerar registros que não sejam do poder executivo
  # XXX
  default_scope { joins(:organ).where(integration_supports_organs: { poder: 'EXECUTIVO' } ) }


  # Sortable

  def self.default_sort_column
    'integration_supports_axes.descricao_eixo'
  end

  def self.default_sort_direction
    :asc
  end

  # Instances methods

  ## helpers

  def title
    indicador
  end

  def valores_realizados_by_year(year)
    return if valores_realizados.blank?

    value_by_year(year, valores_realizados['valor_realizado'])
  end

  def valores_atuais_by_year(year)
    return if valores_atuais.blank?

    value_by_year(year, valores_atuais['valor_atual'])
  end


  # private

  private

  def value_by_year(year, hash_attribute)
    hash_attribute.map do |i|
      i['valor'] if i.is_a?(Hash) && i['ano'] == year.to_s
    end.compact.first
  end
end
