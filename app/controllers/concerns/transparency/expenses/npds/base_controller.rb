module Transparency::Expenses::Npds::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController

  FILTERED_COLUMNS = [
    :unidade_gestora
  ]

  FILTERED_DATE_RANGE = [
    :date_of_issue
  ]

  SORT_COLUMNS = [
    'integration_expenses_npds.exercicio',
    'integration_expenses_npds.numero',
    'integration_expenses_npds.date_of_issue',
    'integration_supports_management_units.titulo',
    'integration_supports_creditors.nome',
    'integration_expenses_npds.valor'
  ]

  included do

    helper_method [
      :npds,

      :npd
    ]

    # Helper methods

    def npds
      paginated_resources
    end

    def npd
      resource
    end

    # Private

    private

    def resource_klass
      Integration::Expenses::Npd
    end

    def transparency_id
      'expenses/npds'
    end

    def filtered_sum_column
      :valor
    end

    ## Spreadsheet

    def spreadsheet_file_prefix
      :npds
    end

    ## Stats

    def stats_klass
      Stats::Expenses::Npd
    end
  end
end
