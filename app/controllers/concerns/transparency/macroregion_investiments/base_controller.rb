module Transparency::MacroregionInvestiments::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::MacroregionInvestiments::Filters

  SORT_COLUMNS = %w[
    integration_macroregions_macroregion_investiments.descricao_poder
    integration_macroregions_macroregion_investiments.descricao_regiao
    integration_macroregions_macroregion_investiments.valor_lei
    integration_macroregions_macroregion_investiments.valor_lei_creditos
    integration_macroregions_macroregion_investiments.valor_empenhado
    integration_macroregions_macroregion_investiments.valor_pago
    integration_macroregions_macroregion_investiments.perc_pago_calculated
  ].freeze

  included do

    helper_method [
      :macroregion_investiments,
      :investiment,
      :filtered_count,
      :filtered_sum
    ]

    # Helper methods

    def macroregion_investiments
      paginated_resources
    end

    def investiment
      resource
    end


    # Private

    private

    def resource_klass
      Integration::Macroregions::MacroregionInvestiment
    end

    def transparency_id
      :macroregion_investiments
    end

    def filtered_sum_column
      :valor_lei
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'macroregions'
    end

    def spreadsheet_file_prefix
      :macroregions
    end

    ## Stats

    def find_stats(year, _month)
      #
      # * Overriding * na busca de estatísticas apenas por ano
      #
      stats_klass.find_by(year: year)
    end

    def stats_yearly?
      #
      # * Overriding * estatísticas anuais
      #
      true
    end

    def stats_klass
      Stats::MacroregionInvestment
    end
  end
end
