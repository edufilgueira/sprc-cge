module Transparency::RealStates::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::RealStates::Filters

  SORT_COLUMNS = %w[
    integration_real_states_real_states.id
    integration_real_states_real_states.descricao_imovel
    integration_supports_organs.sigla
    integration_supports_real_states_property_types.title
    integration_supports_real_states_occupation_types.title
    integration_real_states_real_states.municipio
  ].freeze

  included do

    helper_method [
      :real_states,
      :real_state,
      :filtered_count,
      :filtered_sum
    ]

    # Helper methods

    def real_states
      paginated_resources.eager_load(:manager, :property_type, :occupation_type)
    end

    def real_state
      resource
    end

    # Private

    private

    def resource_klass
      Integration::RealStates::RealState
    end

    def transparency_id
      :real_states
    end

    def filtered_sum_column
      :area_projecao_construcao
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'real_states'
    end

    def spreadsheet_file_prefix
      :bens_imoveis
    end

    ## Stats

    def stats_klass
      Stats::RealState
    end

    def data_dictionary_file_real_states_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_bens_imoveis_ct.xlsx'
    end
  end
end
