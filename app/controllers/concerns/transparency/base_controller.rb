module Transparency::BaseController
  extend ActiveSupport::Concern
  include BaseController
  include PaginatedController
  include SortedController
  include FilteredController
  include TransparencyHelper

  included do

    helper_method [

      # Filters

      :filtered_count,
      :filtered_sum,

      # Stats

      :stats_month_year,
      :available_stats_months,

      # Stats (para anuais como em receitas)

      :stats_year,
      :available_years,

      # Spreadsheets

      :xlsx_download_path,
      :csv_download_path,
      :data_dictionary_download_path,

      # Cache

      :cache_key,
      :stats_cache_key,

      # transparency_export form

      :transparency_resources_path,

      # citizen transparency_follower
      :transparency_follower
    ]

    # Actions

    def index
      respond_to do |format|
        format.html do
          if show_stats?
            locals = {
              stats: stats,
              last_stats_month: last_stats_month,
              last_stats_year: last_stats_year,
              stats_cache_key: stats_cache_key
            }

            render partial: stats_partial_view_path, layout: false, locals: locals
          else
            super
          end
        end

        format.xlsx do
          # transparency_export
          index_for_xlsx
        end
      end
    end

    def show
      return super unless print?

      render template: print_view, layout: 'print'
    end


    # Helpers

    ## Assets

    def javascript
      asset_path
    end

    def stylesheet
      asset_path
    end

    ## Cache

    def cache_key
      CacheHelper.cache_key_for(cache_key_prefix, resource_klass)
    end

    def stats_cache_key
      CacheHelper.cache_key_for(stats_cache_key_prefix, stats_klass)
    end

    def stats_cache_key_prefix
      stats_klass.name.underscore.pluralize
    end

    ## Filters

    def year
      @year ||= (params_year || default_year)
    end

    def filtered_sum
      filtered_resources.sum(filtered_sum_column)
    end

    ## Stats

    def available_stats_months
      sorted_stats.map do |stats|
        l(Date.new(stats.year, stats.month), format: :month_year)
      end
    end

    def stats
      return @stats if @stats.present?

      if stats_yearly?
        @stats = params_stats_year.present? ? stats_from_year : last_stats
      elsif stats_month_range?
        @stats = params_stats_month_range.present? ? stats_from_month_range : last_stats
      else
        @stats = params_stats_month_year.present? ? stats_from_month_year : last_stats
      end

      @stats
    end

    def last_stats_month
      return @last_stats_month if @last_stats_month.present?

      stats = sorted_stats.last

      if stats.present? && stats.month > 0
        @last_stats_month = Date.new(stats.year, stats.month)
      end
    end


    def stats_month_year
      @stats_month_year ||= (params_stats_month_year || default_stats_month_year)
    end

    def last_stats_year
      return @last_stats_year if @last_stats_year.present?

      stats = sorted_stats.last

      if stats.present?
        @last_stats_year = stats.year
      end
    end

    def parent_class
      [Transparency::Revenues, Transparency::Expenses]
    end

    def params_default_month_range
      {
        month_start: 1,
        month_end: 1
      }
    end

    def switch_year(year, month=0, month_range=params_default_month_range)
      return (year.to_i - 1) if self.class.parent.in?(parent_class) and find_stats(year, month, month_range).blank?
      year
    end

    def stats_year
      @stats_year ||= (params_stats_year || default_stats_year)
    end

    def stats_yearly?
      false
    end

    def stats_month_range?
      false
    end

    # transparency_export

    def transparency_resources_path
      url_for controller: controller_path, action: :index
    end

    def transparency_export
      @transparency_export ||= Transparency::Export.new(transparency_export_params)
    end

    ## transparency_follower

    def transparency_follower
      return if resource.blank?

      url = url_for controller: controller_path, id: resource.id, action: :show

      @transparency_follower ||= Transparency::Follower.new(resourceable: resource, transparency_link: url)
    end

    ## Spreadsheets

    def xlsx_download_path
      spreadsheet_download_path(:xlsx)
    end

    def csv_download_path
      spreadsheet_download_path(:csv)
    end

    def data_dictionary_download_path
      spreadsheet_data_dictionary_download_path
    end

    # Privates

    private

    def spreadsheet_data_dictionary_download_path
      data_dictionary_file_path
    end

    def data_dictionary_file_path
      send("data_dictionary_file_#{controller_name}_path")
    end

    def dir_data_dictionary
      '/data_dictionary/'
    end

    def index_for_xlsx
      if human? && transparency_export.save
        Transparency::CreateSpreadsheetWorker.perform_async(transparency_export.id)
        render json: { status: 'success', message: I18n.t('transparency.exports.create.done', expiration: Transparency::Export::DEADLINE_EXPIRATION) }
      else
        render json: { status: 'error', errors: transparency_export.errors, message: I18n.t('transparency.exports.create.error') }
      end
    end

    ## Params

    def params_date_of_issue
      @params_date_of_issue ||=
        params[:date_of_issue]
    end

    def params_year
      if params_date_of_issue.present?
        years = params_date_of_issue.split(' - ').map { |i| i.split('/').last }
        (years.first..years.last).to_a
      else
        params[:year].present? ? params[:year] : nil
      end
    end

    def default_year
      switch_year(Date.today.year)
      # Adicionado estaticamente o ano de 2019 para que não se gerem gráficos
      # em branco. Aproximadamente em março ou abril retornar para a regra
      # antiga, comentada abaixo.
      #Date.today.year
    end

    def params_stats_month_year
      params[:stats_month_year].present? ? params[:stats_month_year] : nil
    end

    def default_stats_month_year
      if last_stats_month.present?
        l(last_stats_month, format: :month_year)
      end
    end

    def params_stats_year
      params[:stats_year].present? ? params[:stats_year] : nil
    end


    def default_stats_year
      switch_year(last_stats_year)
      # Adicionado estaticamente o ano de 2019 para que não se gerem gráficos
      # em branco. Aproximadamente em março ou abril retornar para a regra
      # antiga, comentada abaixo.
      # if last_stats_year.present?
      #   last_stats_year
      # end
    end

    ## Cache

    def cache_params
      params.permit!.to_h.to_s.downcase
    end

    # Para index que têm coluna de status baseado no dia atual, como em contratos
    # em que são considerados 'ativos'.
    # Nesses casos, precisamos 'expirar' o cache todos os dias. Ou seja,
    # adicionar a data atual à chave do cache.
    # O padrão é false, para não considerar a data atual na chave de cache.
    def cache_limited_by_day?
      false
    end

    def cache_key_prefix
      params_digest = Digest::SHA256.hexdigest(cache_params)

      # É importante usar o namespace no cache pois os links para show_path
      # das ferramentas de transparência que são compartilhadas por diversos
      # namespaces (:admin, :platform, ...) deve ser específicos.

      base_cache_key = "#{namespace}/#{params_digest}"
      cache_key_scoped(base_cache_key)
    end

    def stats_cache_key_prefix
      # É importante considerar o xlsx_download_path no cache pois pode ter sido cacheado enquanto
      # gerava a planilha e, com o cache, nunca apareceria para o download.
      #
      # Também devemos considerar o locale, pois deve haver um cache por locale.

      locale = params[:locale]

      date_key = stats_cache_date_key

      if locale.present?
        date_key = "#{locale}/#{stats_cache_date_key}"
      end

      base_cache_key = "stats/#{transparency_id}/#{date_key}/#{xlsx_download_path}/#{csv_download_path}"
      cache_key_scoped(base_cache_key)
    end

    def stats_cache_date_key
      (stats_yearly? ? stats_year : stats_month_year)
    end

    # Devemos considerar o dia na chave do cache pois o status dos contratos
    # é baseado na data_termino e no dia atual.
    # Sem considerar o dia, contratos ficariam cacheados como 'vigentes'
    # mesmo após serem concluídos.
    def cache_key_scoped(base_cache_key)
      if cache_limited_by_day?
        "#{base_cache_key}/#{Date.today.end_of_day}"
      else
        base_cache_key
      end
    end

    ## Sort

    def default_sort_scope
      # Usar o search_scope é importante pelos 'joins' nas tabelas.
      # Esses joins já são feitos no 'search' pois é possível buscar nesses campos.

      resource_klass.search_scope
    end

    ## Spreadsheets

    def spreadsheet_download_prefix
      # Pode ser sobrescrita pelo controller e é usado no helper para definir
      # o download_path do arquivo de transparência.
      # ex: :contracts

      transparency_id
    end

    def spreadsheet_file_prefix
      # Deve ser sobrescrita pelo controller e é usado no helper para definir
      # o download_path do arquivo de transparência.

      # ex: :contratos
    end

    def spreadsheet_download_path(format)
      if stats.present?
        transparency_spreadsheet_download_path(spreadsheet_download_prefix, spreadsheet_file_prefix, stats.year, stats.month, format)
      end
    end

    ## Stats

    def show_stats?
      params[:show_stats].present?
    end

    def last_stats
      if stats_yearly? && last_stats_year.present?
        find_stats(last_stats_year, 0)
      elsif last_stats_month.present?
        find_stats(last_stats_month.year, last_stats_month.month)
      end
    end

    def find_stats(year, month, month_range=nil)
      params = {
        year: year,
        month: month
      }

      stats_klass.find_by(params)
    end

    def stats_from_month_year
      month = params_stats_month_year.split('/')[0]
      year = params_stats_month_year.split('/')[1]

      find_stats(switch_year(year, month), month)

      # Por razão de ainda não existirem valores lançados em alguns relatórios
      # referentes ao ano de 2020, a regra acima está sendo adotada.
      # Em meados de Março/Abril será readotada a regra abaixo

    end

    def stats_from_year
      find_stats(switch_year(params_stats_year), 0)
      # Por razão de ainda não existirem valores lançados em alguns relatórios
      # referentes ao ano de 2020, a regra acima está sendo adotada.
      # Em meados de Março/Abril será readotada a regra abaixo
      # find_stats(params_stats_year, 0)
    end

    def sorted_stats
      stats_klass.order('year, month').select(:year, :month)
    end

    def stats_path
      "shared/transparency/#{transparency_id}/index/stats"
    end

    ## transparency export

    def human?
      verify_recaptcha(model: transparency_export, attribute: :recaptcha)
    end

    def transparency_export_params
      {
        # form params
        name: params[:export_name],
        email: params[:export_email],
        worksheet_format: params[:export_worksheet_format],

        # controller
        query: filtered_resources_sql,
        resource_name: resource_klass_str,
        status: :queued
      }
    end

    def filtered_resources_sql
      filtered_resources.to_sql
    end

    def resource_klass_str
      resource_klass.to_s
    end

    ## View paths

    def print_view
      "#{controller_base_view_path}/print"
    end


    def controller_base_view_path
      "shared/transparency/#{transparency_id}"
    end

    def index_view_path
      "#{controller_base_view_path}/index"
    end

    def show_view_path
      "#{controller_base_view_path}/show"
    end

    def stats_partial_view_path
      "#{controller_base_view_path}/index/stats"
    end

    def asset_path
      "views/shared/transparency/#{transparency_id}/#{action_name}"
    end
  end
end
