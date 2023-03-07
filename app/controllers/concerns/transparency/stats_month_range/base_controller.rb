module Transparency::StatsMonthRange::BaseController
  extend ActiveSupport::Concern

  included do

    helper_method [
      :last_stat_month
    ]


    private

    def stats_month_range?
      params[:stats_month_start].present? && params[:stats_month_end].present?
    end

    def stats_month_start
      @stats_month_start ||= (params_stats_month_range[:stats_month_start] || default_stats_month_start)
    end

    def last_stats_month_range
      return @last_stats_month_range if @last_stats_month_range.present?

      stats = sorted_stats.last

      if stats.present? && stats.month_end > 0
        @last_stats_month_range = Date.new(stats.year, stats.month_end)
      end
    end

    def params_stats_month_range
      return nil if params[:stats_month_start].blank? || params[:stats_month_start].blank?

      {
        month_start: params[:stats_month_start],
        month_end: params[:stats_month_end]
      }
    end

    def last_stats
      if stats_month_range?
        find_stats(last_stats_year, 0, last_stats_month_range_params)
      end
    end

    def last_stats_month_range_params
      return {} if last_stats_month_range.blank?

      {
        month_start: params_stats_month_range[:month_start],
        month_end: last_stats_month_range.month
      }
    end

    def params_stats_year
      params[:stats_year].present? ? params[:stats_year] : Date.today.year
    end

    def stats_from_month_range
      find_stats(switch_year(params_stats_year, 0, params_stats_month_range), 0, params_stats_month_range) || last_stats
      # if check_parent_class?(self)
      #   year = params_stats_year == 2020 ? 2019 : params_stats_year
      #   find_stats(year, 0, params_stats_month_range) || last_stats
      # else
      #   find_stats(params_stats_year, 0, params_stats_month_range) || last_stats
      # end
      # Por razão de ainda não existirem valores lançados em alguns relatórios
      # referentes ao ano de 2020, a regra acima está sendo adotada.
      # Em meados de Março/Abril será readotada a regra abaixo
      #  find_stats(params_stats_year, 0, params_stats_month_range) || last_stats
    end

    def find_stats(year, month, month_range)
      params = {
        year: year,
        month_start: month_range[:month_start],
        month_end: month_range[:month_end]
      }

      stats_klass.find_by(params)
    end

    def sorted_stats
      stats_klass.where.not(month_end: nil).order('year, month_end').select(:year, :month_end)
    end

    def last_stat_month
      stat = last_stats_month

      if (self.class.parent.in?(parent_class) and stat&.month == 1 and
          find_stats(stat&.year, 0, params_default_month_range).blank?)
        12
      else
        stat&.month
      end
    end

    def last_stats_month
      last_stats_month_range
    end

    def stats_cache_date_key
      stats_month_range_str
    end

    def stats_month_range_str
      @stats_month_range_str ||= (params_stats_month_range_str || default_stats_month_range)
    end

    def params_stats_month_start
      params_stats_month_range[:month_start] if params_stats_month_range.present?
    end

    def params_stats_month_end
      params_stats_month_range[:month_end] if params_stats_month_range.present?
    end

    def params_stats_month_range_str
      if params_stats_year.present? && params_stats_month_start.present? && params_stats_month_end.present?
        "#{params_stats_year}_#{params_stats_month_start}_#{params_stats_month_end}"
      end
    end

    def default_stats_month_range
      "#{last_stats_year}_1_#{last_stat_month}"
    end
  end
end
