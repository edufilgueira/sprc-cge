module ::Transparency::Constructions::Daes::BaseController
  extend ActiveSupport::Concern
  include Transparency::Constructions::BaseController
  include Transparency::Constructions::Daes::Filters

  SORT_COLUMNS = [
    'integration_constructions_daes.numero_sacc',
    'integration_constructions_daes.secretaria',
    'integration_constructions_daes.contratada',
    'integration_constructions_daes.descricao',
    'integration_constructions_daes.municipio',
    'integration_constructions_daes.status',
    'integration_constructions_daes.valor'
  ]

  included do

    helper_method [
      :daes,
      :dae,
      :last_update
    ]

    # Helper methods

    def daes
      paginated_resources
    end

    def dae
      resource
    end

    def last_update
      Integration::Constructions::Dae.order(:updated_at).last.updated_at unless Integration::Constructions::Dae.last.nil?
    end

    # Private

    private

    def resource_klass
      Integration::Constructions::Dae
    end

    def transparency_id
      'constructions/daes'
    end

    def filtered_sum_column
      :valor
    end

    ## Params

    def params_data_inicio
      @params_data_inicio ||=
        params[:data_inicio].present? ? params[:data_inicio] : nil
    end

    def params_data_fim_previsto
      @params_data_fim_previsto ||=
        params[:data_fim_previsto].present? ? params[:data_fim_previsto] : nil
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'constructions/daes'
    end

    def spreadsheet_file_prefix
      'daes'
    end

    ## Cache

    # Devemos considerar o dia na chave do cache pois o status dos contratos
    # é baseado na data_termino e no dia atual.
    # Sem considerar o dia, contratos ficariam cacheados como 'vigentes'
    # mesmo após serem concluídos.

    def cache_limited_by_day?
      true
    end

    ## Stats

    def stats_klass
      Stats::Constructions::Dae
    end

    def data_dictionary_file_daes_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_dae_ct.xlsx'
    end
  end
end
