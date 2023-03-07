module Transparency::MacroregionInvestiments::Filters
  include Transparency::BaseFilters

  FILTERED_COLUMNS = [
    :ano_exercicio,
    :descricao_poder
  ]

  def filtered_resources
    filtered(Integration::Macroregions::MacroregionInvestiment, sorted_resources)
  end
end
