class Transparency::Revenues::RegisteredRevenuesController < TransparencyController
  include Transparency::Revenues::Accounts::BaseController
  include Transparency::Revenues::RegisteredRevenues::Breadcrumbs


  helper_method [
    :registered_revenues
  ]

  def registered_revenues
   @registered_revenues ||= filtered_resources
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
    Integration::Revenues::RegisteredRevenue
  end

  def default_sort_scope
    resource_klass.from_year(year)
  end

  ## Stats

  def stats_klass
    Stats::Revenues::RegisteredRevenue
  end

  def transparency_id
    'revenues/registered_revenues'
  end

  def revenues_tree_klass
    Integration::Revenues::RegisteredRevenuesTree
  end

  def revenues_tree_resources
    registered_revenues
  end

  def nodes
    @nodes ||= revenues_tree.nodes(next_node_type).sort_by! {|n| n[:resource]}
  end

  def nodes_totals
    return @nodes_totals if @nodes_totals.present?

    result = {
      valor_lancado: 0
    }

    nodes.each do |nodes|
      result[:valor_lancado] += nodes[:valor_lancado]
    end

    @nodes_totals = result
  end

  ## Spreadsheet

  def spreadsheet_download_prefix
    'revenues/registered_revenues'
  end

  def spreadsheet_file_prefix
    :receitas_lancadas
  end

  def stats_yearly?
    true
  end

  def spreadsheet_download_path(format)
    if stats.present?
      transparency_spreadsheet_download_path(spreadsheet_download_prefix, spreadsheet_file_prefix, stats.year, 0, format)
    end
  end
end
