class Integration::Results::ThematicIndicator < ApplicationDataRecord
  include ::Integration::Results::ThematicIndicator::Search
  include ::Sortable

  belongs_to :organ,
              -> { where('integration_supports_organs.orgao_sfp = ? AND integration_supports_organs.data_termino IS NULL', false) },
              class_name: 'Integration::Supports::Organ'

  belongs_to :axis,
              class_name: 'Integration::Supports::Axis'

  belongs_to :theme,
              class_name: 'Integration::Supports::Theme'

  validates :eixo,
            :tema,
            :indicador,
            :sigla_orgao,
            :organ,
            :axis,
            :theme,
            presence: true

  delegate :title, to: :organ, prefix: true, allow_nil: true
  delegate :sigla, to: :organ, prefix: true, allow_nil: true
  delegate :title, to: :axis, prefix: true
  delegate :title, to: :theme, prefix: true


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

    value = value_by_year(year, valores_realizados['valor_realizado'])

    value.present? ? build_result(value, :done) : valores_programados_by_year(year)
  end

  def valores_programados_by_year(year)
    return if valores_programados.blank?

    value = value_by_year(year, valores_programados['valor_programado'])

    build_result(value, :scheduled)
  end


  # private

  private

  def build_result(value, status)
    {
      value: value,
      status: status
    }
  end

  def value_by_year(year, hash_attribute)
    hash_attribute.map do |i|
      i['valor'] if i.is_a?(Hash) && i['ano'] == year.to_s
    end.compact.first
  end
end
