module Transparency::Expenses::Npfs::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController

  FILTERED_COLUMNS = [
    :unidade_gestora
  ]

  FILTERED_DATE_RANGE = [
    :date_of_issue
  ]

  SORT_COLUMNS = [
    'integration_expenses_npfs.exercicio',
    'integration_expenses_npfs.numero',
    'integration_expenses_npfs.date_of_issue',
    'integration_supports_management_units.titulo',
    'integration_supports_creditors.nome',
    'integration_expenses_npfs.valor'
  ]

  included do

    helper_method [
      :npfs,

      :npf
    ]

    # Helper methods

    def npfs
      paginated_resources
    end

    def npf
      resource
    end

    # Private

    private

    def resource_klass
      Integration::Expenses::Npf
    end

    def transparency_id
      'expenses/npfs'
    end

    def filtered_sum_column
      :valor
    end

    ## Spreadsheet

    def spreadsheet_file_prefix
      :npfs
    end

    ## Stats

    def stats_klass
      Stats::Expenses::Npf
    end
  end
end
