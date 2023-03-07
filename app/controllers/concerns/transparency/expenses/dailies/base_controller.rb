module Transparency::Expenses::Dailies::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::CreditorsSelectController

  FILTERED_ASSOCIATIONS = [
  ]

  FILTERED_COLUMNS = [
    :unidade_gestora,
    :classificacao_regiao_administrativa,
    :exercicio
  ]

  FILTERED_DATE_RANGE = [
    :date_of_issue
  ]

  FILTERED_IGNORE_IN_HIGHLIGHTS = [
    :exercicio
  ]

  SORT_COLUMNS = [
    'integration_expenses_npds.numero',
    'integration_expenses_npds.data_emissao',
    'integration_supports_management_units.titulo',
    'integration_expenses_neds.razao_social_credor',
    'integration_expenses_npds.calculated_valor_final'
  ]

  INCLUDES = [
    :management_unit,

    { nld: :ned }
  ]

  included do

    helper_method [
      :dailies,

      :daily,

      :year
    ]

    # Helper methods

    def dailies
      paginated_resources
    end

    def daily
      resource
    end

    def filtered_sum
      {
        calculated_valor_final: filtered_resources.sum(:calculated_valor_final)
      }
    end


    # override
    def filtered_resources
      @filtered_resources ||= filtered_npds
    end


    # Private

    private

    def filtered_npds
      filtered = filtered(resource_klass, filtered_scope)

      # a busca pelo nome do credor no campo 'search_datalist' desconsidera os demais filtros
      return search_by_creditor_name(filtered) if params[:search_datalist].present?

      filtered
    end

    def default_sort_scope
      resource_klass.default_sort_scope.includes(INCLUDES).references(INCLUDES)
    end

    def resource_klass
      Integration::Expenses::Daily
    end

    def transparency_id
      'expenses/dailies'
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/dailies'
    end

    def spreadsheet_file_prefix
      :diarias
    end

    ## Stats

    def stats_klass
      Stats::Expenses::Daily
    end

    def stats_yearly?
      true
    end

    def data_dictionary_file_dailies_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_despesas_diarias_ct.xlsx'
    end
  end
end
