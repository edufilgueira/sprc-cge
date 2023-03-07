module Transparency::Expenses::Nlds::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController

  FILTERED_COLUMNS = [
    :unidade_gestora
  ]

  FILTERED_DATE_RANGE = [
    :date_of_issue
  ]

  SORT_COLUMNS = [
    'integration_expenses_nlds.exercicio',
    'integration_expenses_nlds.numero',
    'integration_expenses_nlds.date_of_issue',
    'integration_supports_management_units.titulo',
    'integration_supports_creditors.nome',
    'integration_expenses_nlds.valor'
  ]

  included do

    helper_method [
      :nlds,

      :nld
    ]

    # Helper methods

    def nlds
      paginated_resources
    end

    def nld
      resource
    end

    # Private

    private

    def resource_klass
      Integration::Expenses::Nld
    end

    def transparency_id
      'expenses/nlds'
    end

    def filtered_sum_column
      :valor
    end

    ## Spreadsheet

    def spreadsheet_file_prefix
      :nlds
    end

    ## Stats

    def stats_klass
      Stats::Expenses::Nld
    end
  end
end
