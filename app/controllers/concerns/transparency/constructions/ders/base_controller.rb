module Transparency::Constructions::Ders::BaseController
  extend ActiveSupport::Concern
  include Transparency::Constructions::BaseController
  include Transparency::Constructions::Ders::Filters

  SORT_COLUMNS = [
    'integration_constructions_ders.status',
    'integration_constructions_ders.trecho',
    'integration_constructions_ders.construtora',
    'integration_constructions_ders.extensao',
    'integration_constructions_ders.valor_aprovado',
    'integration_constructions_ders.numero_contrato_sic'
  ]

  included do

    helper_method [
      :ders,
      :der,
      :last_update
    ]

    # Helper methods

    def ders
      paginated_resources
    end

    def der
      resource
    end

    def last_update
      Integration::Constructions::Der.order(:updated_at).last.updated_at unless Integration::Constructions::Der.last.nil?
    end

    # Private

    private

    def resource_klass
      Integration::Constructions::Der
    end

    def transparency_id
      'constructions/ders'
    end

    def filtered_sum_column
      :valor_aprovado
    end

    ## Params

    def params_data_fim_contrato
      @params_data_fim_contrato ||=
        params[:data_fim_contrato].present? ? params[:data_fim_contrato] : nil
    end

    def params_data_fim_previsto
      @params_data_fim_previsto ||=
        params[:data_fim_previsto].present? ? params[:data_fim_previsto] : nil
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'constructions/ders'
    end

    def spreadsheet_file_prefix
      'ders'
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
      Stats::Constructions::Der
    end

    def data_dictionary_file_ders_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_der_ct.xlsx'
    end
  end
end
