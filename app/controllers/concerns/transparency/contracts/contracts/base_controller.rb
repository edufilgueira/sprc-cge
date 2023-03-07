module ::Transparency::Contracts::Contracts::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::Contracts::Contracts::Filters

  SORT_COLUMNS = [
    'integration_contracts_contracts.data_assinatura',
    'integration_contracts_contracts.isn_sic',
    'integration_contracts_contracts.num_contrato',
    'integration_supports_organs.descricao_orgao',
    'integration_supports_management_units.titulo',
    'integration_contracts_contracts.descricao_nome_credor',
    'integration_contracts_contracts.descricao_objeto',
    'integration_contracts_contracts.valor_atualizado_concedente',
    'integration_contracts_contracts.calculated_valor_empenhado',
    'integration_contracts_contracts.calculated_valor_pago'
  ]

  included do

    helper_method [
      :contracts,

      :contract,
      :additives,
      :adjustments,
      :financials,
      :infringements
    ]

    # Helper methods

    def contracts
      paginated_resources
    end

    def contract
      resource
    end

    def additives
      contract.additives.sorted
    end

    def adjustments
      contract.adjustments.sorted
    end

    def financials
      contract.financials.sorted
    end

    def infringements
      contract.infringements.sorted
    end

    # Private

    private

    def resource_klass
      Integration::Contracts::Contract
    end

    def transparency_id
      'contracts/contracts'
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

    def params_data_publicacao_portal
      @params_data_publicacao_portal ||=
        params[:data_publicacao_portal].present? ? params[:data_publicacao_portal] : nil
    end

    def params_data_vigencia
      @params_data_vigencia ||=
        params[:data_vigencia].present? ? params[:data_vigencia] : nil
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
      'contracts/contracts'
    end

    def spreadsheet_file_prefix
      :contratos
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
      Stats::Contracts::Contract
    end

    def data_dictionary_file_contracts_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_contratos_ct.xlsx'
    end
  end
end
