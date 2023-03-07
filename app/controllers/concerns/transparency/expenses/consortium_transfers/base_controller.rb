module Transparency::Expenses::ConsortiumTransfers::BaseController
  extend ActiveSupport::Concern
  include Transparency::Expenses::BaseController

  included do

    helper_method [
      :consortium_transfers,

      :consortium_transfer,

      :year
    ]

    # Helper methods

    def consortium_transfers
      paginated_resources
    end

    def consortium_transfer
      resource
    end

    # override

    def filtered_resources
      @filtered_resources ||= filtered_consortium_transfers
    end


    # Private

    private

    def filtered_consortium_transfers
      filtered = filtered(resource_klass, filtered_scope)

      # a busca pelo nome do credor no campo 'search_datalist' desconsidera os demais filtros
      return search_by_creditor_name(filtered) if params[:search_datalist].present?

      filtered
    end

    def resource_klass
      Integration::Expenses::ConsortiumTransfer
    end

    def transparency_id
      'expenses/consortium_transfers'
    end


    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/consortium_transfers'
    end

    def spreadsheet_file_prefix
      :transferencias_consorcios_publicos
    end

    ## Stats

    def stats_klass
      Stats::Expenses::ConsortiumTransfer
    end

    def stats_yearly?
      true
    end
  end
end
