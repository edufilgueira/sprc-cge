module Transparency::Expenses::Neds::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::CreditorsSelectController

  FILTERED_ASSOCIATIONS = [
    :classificacao_funcao,
    :classificacao_subfuncao,
    :classificacao_programa_governo,
    :classificacao_regiao_administrativa,
    :classificacao_natureza_despesa,
    :classificacao_fonte_recursos,
    :classificacao_elemento_despesa,
    :item_despesa
  ]

  FILTERED_COLUMNS = [
    :unidade_gestora
  ]

  FILTERED_DATE_RANGE = [
    :date_of_issue
  ]

  FILTERED_CUSTOM = [
    :numero
  ]

  SORT_COLUMNS = [
    'integration_expenses_neds.numero',
    'integration_expenses_neds.date_of_issue',
    'integration_supports_management_units.titulo',
    'integration_expenses_neds.razao_social_credor',
    'integration_expenses_neds.valor',
    'integration_expenses_neds.calculated_valor_pago_final'
  ]

  included do

    helper_method [
      :neds,

      :ned,
      :ned_items,
      :ned_planning_items,
      :ned_disbursement_forecasts,

      :year
    ]

    # Helper methods

    def neds
      paginated_resources
    end

    def ned
      resource
    end

    def ned_items
      ned.ned_items.sorted
    end

    def ned_planning_items
      ned.ned_planning_items.sorted
    end

    def ned_disbursement_forecasts
      ned.ned_disbursement_forecasts.sorted
    end

    def filtered_sum
      {
        calculated_valor_final: filtered_resources.sum(:calculated_valor_final),  # valor empenhado final
        calculated_valor_pago_final: filtered_resources.sum(:calculated_valor_pago_final)  # valor pago final
      }
    end

    # override

    def filtered_resources
      @filtered_resources ||= filtered_neds
    end

    # action para exibir NED (show), sem saber o id
    # utilizando ano, orgao, numero nota

    def ned_by_note
      ned = resource_klass.where(
        unidade_gestora: params_ned_by_note[:organ],
        exercicio: params_ned_by_note[:year],
        numero: params_ned_by_note[:note],
      ).first

      redirect_to ned
    end


    # Private

    private

    def integration_expenses_ned_url(resource)
      transparency_expenses_ned_path(resource)
    end

    def filtered_neds
      filtered = filtered(resource_klass, filtered_scope)

      # a busca pelo nome do credor no campo 'search_datalist' desconsidera os demais filtros
      return search_by_creditor_name(filtered) if params[:search_datalist].present?

      filtered
    end

    def params_ned_by_note
     params.permit(:year, :organ ,:note)
    end

    def resource_klass
      Integration::Expenses::Ned
    end

    def default_sort_scope
      scope = resource_klass.with_numero(params[:numero]).from_executivo.ordinarias.from_year(year)
    end

    def transparency_id
      'expenses/neds'
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/neds'
    end

    def spreadsheet_file_prefix
      :notas_de_empenho
    end

    ## Stats

    def stats_klass
      Stats::Expenses::Ned
    end

    def stats_yearly?
      true
    end

    def data_dictionary_file_neds_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_neds_ct.xlsx'
    end
    
  end
end
