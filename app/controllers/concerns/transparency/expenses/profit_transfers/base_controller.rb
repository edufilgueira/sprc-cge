module Transparency::Expenses::ProfitTransfers::BaseController
  extend ActiveSupport::Concern
  include Transparency::Expenses::BaseController

  included do

    helper_method [
      :profit_transfers,

      :profit_transfer,

      :year
    ]

    # Helper methods

    def profit_transfers
      paginated_resources
    end

    def profit_transfer
      resource
    end

    # override

    def filtered_resources
      @filtered_resources ||= filtered_profit_transfers
    end

    # Private

    private

    def filtered_profit_transfers
      filtered = filtered(resource_klass, filtered_scope)

      # a busca pelo nome do credor no campo 'search_datalist' desconsidera os demais filtros
      return search_by_creditor_name(filtered) if params[:search_datalist].present?

      filtered
    end

    def resource_klass
      Integration::Expenses::ProfitTransfer
    end

    def transparency_id
      'expenses/profit_transfers'
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/profit_transfers'
    end

    def spreadsheet_file_prefix
      :transferencias_entidades_com_fins_lucrativos
    end

    ## Stats

    def stats_klass
      Stats::Expenses::ProfitTransfer
    end

    def stats_yearly?
      true
    end
  end
end
