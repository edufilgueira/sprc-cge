class Admin::Integrations::Revenues::TransfersController < AdminController
  include Transparency::Revenues::Accounts::BaseController
  include Admin::Integrations::Revenues::Transfers::Breadcrumbs

  helper_method [
    :transfers
  ]

  def transfers
    @transfers ||= filtered_resources
  end

  def stats
    @stats = params_stats_year.present? ? stats_from_year : last_stats
  end

  def last_stats_year
    return @last_stats_year if @last_stats_year.present?

    stats = sorted_stats.last

    if stats.present?
      @last_stats_year = stats.year
    end
  end

  # Private

  private

  def resource_klass
    Integration::Revenues::Transfer
  end

  ## Stats

  def stats_klass
    Stats::Revenues::Transfer
  end

  def transparency_id
    'revenues/transfers'
  end

  def revenues_tree_klass
    Integration::Revenues::TransfersTree
  end

  def revenues_tree_resources
    transfers
  end

  def sorted_stats
    stats_klass.order('year, month').select(:year, :month)
  end

  def find_stats(year, month)
    params = {
      year: year,
      month: month
    }

    stats_klass.find_by(params)
  end

  def render_stats
    locals = {
      stats: stats,
      last_stats_year: last_stats_year,
      stats_cache_key: stats_cache_key
    }

    render partial: stats_partial_view_path, layout: false, locals: locals
  end

  ## Cache

  def stats_cache_date_key
    stats_year
  end

  ## Spreadsheet

  def spreadsheet_download_prefix
    'revenues/transfers'
  end

  def spreadsheet_file_prefix
    :receitas_poder_executivo_transferencias
  end

  def spreadsheet_download_path(format)
    if stats.present?
      transparency_spreadsheet_download_path(spreadsheet_download_prefix, spreadsheet_file_prefix, stats.year, 0, format)
    end
  end
end
