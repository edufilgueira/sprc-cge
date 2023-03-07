module Transparency::Expenses::CityTransfers::BaseController
  extend ActiveSupport::Concern
  include Transparency::Expenses::BaseController

  included do

    helper_method [
      :city_transfers,
      :city_transfer,
      :year
    ]

    # Helper methods

    def city_transfers
      paginated_resources
    end

    def city_transfer
      resource
    end

    # override

    def filtered_resources
      @filtered_resources ||= filtered_city_transfers
    end


    # Private

    private

    def filtered_city_transfers
      filtered = filtered(resource_klass, filtered_scope)

      # a busca pelo nome do credor no campo 'search_datalist' desconsidera os demais filtros
      return search_by_creditor_name(filtered) if params[:search_datalist].present?

      filtered
    end

    def resource_klass
      Integration::Expenses::CityTransfer
    end

    def transparency_id
      'expenses/city_transfers'
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/city_transfers'
    end

    def spreadsheet_file_prefix
      :transferencias_municipios
    end

    ## Stats

    def stats_klass
      Stats::Expenses::CityTransfer
    end

    def stats_yearly?
      true
    end

    def data_dictionary_file_city_transfers_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_transferencia_municipios_ct.xlsx'
    end

  end
end
