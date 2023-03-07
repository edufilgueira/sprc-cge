module Transparency::Results::StrategicIndicators::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController

  FILTERED_ASSOCIATIONS = [
    :organ_id,
    :axis_id
  ]

  SORT_COLUMNS = [
    'integration_supports_axes.descricao_eixo',
    'integration_supports_organs.sigla',
    'integration_results_strategic_indicators.indicador',
    'integration_results_strategic_indicators.unidade'
  ].freeze

  included do

    helper_method [:strategic_indicators, :strategic_indicator]

    # Helper methods

    def strategic_indicators
      paginated_resources
    end

    def strategic_indicator
      resource
    end


    # Private

    private

    def resource_klass
      Integration::Results::StrategicIndicator
    end

    def transparency_id
      'results/strategic_indicators'
    end

    ## Spreadsheet

    def spreadsheet_file_prefix
      :results_strategic_indicator
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
      Stats::Results::StrategicIndicator
    end

    def data_dictionary_file_strategic_indicators_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_indicadores_estrategicos_ct.xlsx'
    end
  end
end
