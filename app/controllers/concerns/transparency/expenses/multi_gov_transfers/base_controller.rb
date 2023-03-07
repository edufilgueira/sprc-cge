module Transparency::Expenses::MultiGovTransfers::BaseController
  extend ActiveSupport::Concern
  include Transparency::Expenses::BaseController

  included do

    helper_method [
      :multi_gov_transfers,

      :multi_gov_transfer,

      :year
    ]

    # Helper methods

    def multi_gov_transfers
      paginated_resources
    end

    def multi_gov_transfer
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
      Integration::Expenses::MultiGovTransfer
    end

    def transparency_id
      'expenses/multi_gov_transfers'
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/multi_gov_transfers'
    end

    def spreadsheet_file_prefix
      :transferencias_instituicoes_multigovernamentais
    end

    ## Stats

    def stats_klass
      Stats::Expenses::MultiGovTransfer
    end

    def stats_yearly?
      true
    end
  end
end
