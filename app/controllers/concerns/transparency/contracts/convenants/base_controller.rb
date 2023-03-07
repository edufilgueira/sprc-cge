module Transparency::Contracts::Convenants::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::Contracts::Convenants::Filters

  SORT_COLUMNS = [
    'integration_contracts_contracts.data_assinatura',
    'integration_contracts_contracts.isn_sic',
    'integration_contracts_contracts.num_contrato',
    'integration_supports_organs.descricao_orgao',
    'integration_contracts_contracts.descricao_nome_credor',
    'integration_contracts_contracts.descricao_objeto',
    'integration_contracts_contracts.valor_atualizado_concedente',
    'integration_contracts_contracts.calculated_valor_empenhado',
    'integration_contracts_contracts.calculated_valor_pago'
  ]

  included do

    helper_method [
      :convenants,

      :convenant,
      :additives,
      :adjustments,
      :financials,
      :infringements
    ]

    # Helper methods

    def convenants
      paginated_resources
    end

    def convenant
      resource
    end

    def additives
      convenant.additives.sorted
    end

    def adjustments
      convenant.adjustments.sorted
    end

    def financials
      convenant.financials.sorted
    end

    def infringements
      convenant.infringements.sorted
    end

    # Private

    private

    def resource_klass
      Integration::Contracts::Convenant
    end

    def transparency_id
      'contracts/convenants'
    end

    #
    # Nome da coluna que será somada no sumário dos filtros.
    #
    def filtered_sum_column
      :valor_atualizado_concedente
    end

    ## Params

    def params_data_assinatura
      @params_data_assinatura ||=
        params[:data_assinatura].present? ? params[:data_assinatura] : nil
    end

    def params_data_vigencia
      @params_data_vigencia ||=
        params[:data_vigencia].present? ? params[:data_vigencia] : nil
    end

    def params_data_publicacao_portal
      @params_data_publicacao_portal ||=
        params[:data_publicacao_portal].present? ? params[:data_publicacao_portal] : nil
    end

    def params_data_termino_original
      @params_data_termino_original ||=
        params[:data_termino_original].present? ? params[:data_termino_original] : nil
    end

    def params_data_rescisao
      @params_data_rescisao ||=
        params[:data_rescisao].present? ? params[:data_rescisao] : nil
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'contracts/convenants'
    end

    def spreadsheet_file_prefix
      :convenios
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
      Stats::Contracts::Convenant
    end

    def data_dictionary_file_convenants_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_convenios_ct.xlsx'
    end
  end
end
