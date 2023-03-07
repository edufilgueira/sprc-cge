module Transparency::Purchases::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::Purchases::Filters

  SORT_COLUMNS = %w[
    integration_purchases_purchases.numero_publicacao
    integration_purchases_purchases.nome_fornecedor
    integration_purchases_purchases.nome_resp_compra
    integration_purchases_purchases.codigo_item
    integration_purchases_purchases.descricao_item
    integration_purchases_purchases.quantidade_estimada
    integration_purchases_purchases.valor_total_calculated
  ].freeze

  included do

    helper_method [
      :purchases,
      :purchase,
      :filtered_count,
      :filtered_sum
    ]

    # Helper methods

    def purchases
      paginated_resources
    end

    def purchase
      resource
    end

    def filtered_sum
      filtered_resources.sum(:valor_total_calculated).to_f
    end

    # Private

    private

    def resource_klass
      Integration::Purchases::Purchase
    end

    def transparency_id
      :purchases
    end

    ## Params

    def params_data_publicacao
      @params_data_publicacao ||=
        params[:data_publicacao].present? ? params[:data_publicacao] : nil
    end

    def params_data_finalizada
      @params_data_finalizada ||=
        params[:data_finalizada].present? ? params[:data_finalizada] : nil
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'purchases'
    end

    def spreadsheet_file_prefix
      :compras
    end

    ## Stats

    def stats_klass
      Stats::Purchase
    end

    def data_dictionary_file_purchases_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_licitacoes_finalizadas_ct.xlsx'
    end
  end
end
