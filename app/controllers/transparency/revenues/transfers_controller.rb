class Transparency::Revenues::TransfersController < TransparencyController
  include Transparency::Revenues::Accounts::BaseController
  include Transparency::Revenues::Transfers::Breadcrumbs

  helper_method [
    :transfers
  ]

  def transfers
    @transfers ||= filtered_resources
  end

  def stats
    @stats = params_stats_year.present? ? stats_from_year : last_stats
  end

  def find_stats(year, month, month_range=nil)
    params = {
      year: year,
      month: month
    }

    stats_klass.find_by(params)
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

  def revenues_tree
    @revenues_tree ||= revenues_tree_klass.new(revenues_tree_resources, param_node_path)
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

  def render_stats
    locals = {
      stats: stats,
      last_stats_year: last_stats_year,
      stats_cache_key: stats_cache_key
    }

    render partial: stats_partial_view_path, layout: false, locals: locals
  end

  def node_types_options
    default_node_types.map do |node_type|
      [
        ::Integration::Supports::RevenueNature.human_attribute_name(node_type),
        node_type
      ]
    end
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

  def data_dictionary_file_transfers_path
    "#{dir_data_dictionary}#{data_dictionary_file_name}"
  end

  def data_dictionary_file_name
    'dicionario_dados_recursos_recebidos_tranferencias_ct.xlsx'
  end
end
