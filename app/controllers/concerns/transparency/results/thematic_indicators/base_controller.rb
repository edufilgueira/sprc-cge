module Transparency::Results::ThematicIndicators::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController

  FILTERED_ASSOCIATIONS = [
    :organ_id,
    :axis_id,
    :theme_id
  ]

  SORT_COLUMNS = [
    'integration_supports_axes.descricao_eixo',
    'integration_supports_themes.descricao_tema',
    'integration_supports_organs.sigla',
    'integration_results_thematic_indicators.indicador',
    'integration_results_thematic_indicators.unidade'
  ].freeze

  included do

    helper_method [:thematic_indicators, :thematic_indicator]

    # Helper methods

    def thematic_indicators
      paginated_resources
    end

    def thematic_indicator
      resource
    end


    # Private

    private

    def resource_klass
      Integration::Results::ThematicIndicator
    end

    def transparency_id
      'results/thematic_indicators'
    end

    ## Spreadsheet

    def spreadsheet_file_prefix
      :results_thematic_indicator
    end

    def spreadsheet_download_path(format)
      date = Date.today

      last_spreadsheet_download_path(date, format) || last_spreadsheet_download_path(date.last_month, format)
    end

    def last_spreadsheet_download_path(date, format)
      transparency_spreadsheet_download_path(spreadsheet_download_prefix, spreadsheet_file_prefix, date.year, date.month, format)
    end

    ## Stats

    def stats_klass
      Stats::Results::ThematicIndicator
    end

    def data_dictionary_file_thematic_indicators_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_indicadores_tematicos_ct.xlsx'
    end
  end
end