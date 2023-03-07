module Transparency::CityUndertakings::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::CityUndertakings::Filters

  SORT_COLUMNS = {
    data_assinatura: 'integration_contracts_contracts.data_assinatura',
    sic: 'integration_city_undertakings_city_undertakings.sic',
    municipio: 'integration_city_undertakings_city_undertakings.municipio',
    sigla: 'integration_supports_organs.sigla',
    descricao: 'integration_supports_undertakings.descricao',
    mapp: 'integration_city_undertakings_city_undertakings.mapp'
  }


  included do

    helper_method [
      :city_undertakings,
      :city_undertaking,
      :filtered_count,
      :filtered_sum
    ]

    def show
      redirect_to contract_or_convenant_path
    end

    # Helper methods

    def city_undertakings
      paginated_resources.eager_load(:organ, :creditor, :undertaking)
    end

    def city_undertaking
      resource
    end

    # Private

    private

    def resource_klass
      Integration::CityUndertakings::CityUndertaking
    end

    def transparency_id
      :city_undertakings
    end

    def filtered_sum_column
      # utilizamos o somatório das 8 colunas de valor_executado
      (1..8).inject([]) do |array, i|
        array << "COALESCE(valor_executado#{i}, 0)"
        array
      end.join(' + ')
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'city_undertakings'
    end

    def spreadsheet_file_prefix
      :empreendimentos_municipios
    end

    ## Stats

    def stats_klass
      Stats::CityUndertaking
    end

    def contract_or_convenant_path
      contract = city_undertaking.contract

      if contract.present?
        transparency_contracts_contract_path(contract)
      else
        convenant = city_undertaking.convenant
        transparency_contracts_convenant_path(convenant)
      end
    end
  end
end
