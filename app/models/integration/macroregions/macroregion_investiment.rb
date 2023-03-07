class Integration::Macroregions::MacroregionInvestiment < ApplicationDataRecord
  include ::Integration::Macroregions::MacroregionInvestiment::Search
  include ::Sortable

  # Associations

  belongs_to :power, class_name: 'Integration::Macroregions::Power'
  belongs_to :region, class_name: 'Integration::Macroregions::Region'

  # Validations

  validates :ano_exercicio,
    :codigo_poder,
    :codigo_regiao,
    presence: true

  validates :ano_exercicio,
    uniqueness: { scope: [:codigo_poder, :codigo_regiao] }

  # Callbacks

  after_validation :set_perc_pago_calculated


  # Class methods

  ## Scopes

  def self.active_on_month(date)
    where(ano_exercicio: date.year.to_s)
  end

  ## Sortable

  def self.default_sort_column
    'integration_macroregions_macroregion_investiments.valor_lei'
  end

  def self.default_sort_direction
    :desc
  end


  # Instances methods

  ### Helpers

  def title
    descricao_regiao
  end


  # privates

  private

  def set_perc_pago_calculated
    self.perc_pago_calculated = (valor_pago / valor_lei) * 100
  end
end
