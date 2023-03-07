module Transparency::Expenses::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::CreditorsSelectController

  FILTERED_ASSOCIATIONS = [
  ]

  FILTERED_COLUMNS = [
    :unidade_gestora,
    :classificacao_regiao_administrativa
  ]

  FILTERED_DATE_RANGE = [
    :date_of_issue
  ]

  SORT_COLUMNS = [
    'integration_expenses_neds.numero',
    'integration_expenses_neds.date_of_issue',
    'integration_supports_management_units.titulo',
    'integration_expenses_neds.razao_social_credor',
    'integration_supports_expense_nature_items.titulo',
    'integration_expenses_neds.valor',
    'integration_expenses_neds.valor_pago'
  ]

  INCLUDES = [
    :expense_nature_item,
    :management_unit
  ]

  included do

    def filtered_sum
      {
        valor: filtered_resources.sum(:calculated_valor_final),
        valor_pago: filtered_resources.sum(:calculated_valor_pago_final)
      }
    end

    private

    def default_sort_scope
      resource_klass.from_executivo.from_year(year).ordinarias.includes(self.class::INCLUDES)
    end
  end
end
