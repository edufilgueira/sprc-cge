module ::Transparency::ServerSalaries::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController

  PER_PAGE = 10

  SORT_COLUMNS = [
    'integration_servers_server_salaries.server_name',
    'integration_supports_organs.sigla',
    'integration_supports_server_roles.name',
    'integration_servers_server_salaries.functional_status',
    'integration_servers_server_salaries.income_total',
    'integration_servers_server_salaries.income_final'
  ]

  FILTERED_COLUMNS = [
    :integration_supports_server_role_id,
    :functional_status,
    { integration_servers_registrations: :cod_orgao }
  ]

  FILTERED_CUSTOM = [
    :functional_status,
    :cod_orgao
  ]

  included do

    helper_method [
      :server_salaries,
      :server_salary,
      :month_year,
      :date,

      :income_total_sum,
      :unique_servers_count,
      :server_salaries_count,

      :all_server_salaries
    ]

    # Helper methods

    def server_salaries
      paginated_resources
    end

    def server_salary
      resource
    end

    def month_year
      @month_year ||= (params_month_year || default_month_year)
    end

    def date
      @date ||= date_from_month_year
    end

    ## Sums and counts

    def income_total_sum
      filtered_resources.sum(:income_total) - filtered_resources.sum(:discount_under_roof)
    end

    def server_salaries_count
      filtered_resources.count
    end

    def unique_servers_count
      filtered_resources.select('DISTINCT integration_servers_registrations.dsc_cpf').count
    end

    ## Resources

    def all_server_salaries
      salaries_from_server = Integration::Servers::ServerSalary.
        from_server(server_salary.server).
        from_date(server_salary.date)

      [server_salary] + (salaries_from_server - [server_salary])
    end

    # Private

    private

    def resource_klass
      Integration::Servers::ServerSalary
    end

    def transparency_id
      :server_salaries
    end

    ## Sort

    def default_sort_scope
      # User o search_scope é importante pelos 'joins' nas tabelas de organs e
      # roles que são usados na ordenação. Esses joins já são feitos no 'search'
      # pois é possível buscar nesses campos.

      Integration::Servers::ServerSalary.search_scope.from_date(date)
    end

    ## Params

    def params_month_year
      params[:month_year].present? ? params[:month_year] : nil
    end

    def default_month_year
      last_date = Integration::Servers::ServerSalary.order('date').last.try(:date)

      l((last_date.present? ? last_date : Date.today), format: :month_year)
    end

    def date_from_month_year
      Date.new(year, month) rescue Date.today
    end

    def month
      month_year.split('/')[0].to_i
    end

    def year
      month_year.split('/')[1].to_i
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'servers/server_salaries'
    end

    def spreadsheet_file_prefix
      :servidores
    end

    ## Stats

    def stats_klass
      Stats::ServerSalary
    end
  end
end
