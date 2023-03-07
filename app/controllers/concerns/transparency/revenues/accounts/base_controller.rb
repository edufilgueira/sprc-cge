module Transparency::Revenues::Accounts::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::StatsMonthRange::BaseController

  FILTERED_COLUMNS = [
    'integration_revenues_revenues.integration_supports_secretary_id',
    'integration_revenues_revenues.unidade',
    'integration_supports_revenue_natures.unique_id_consolidado',
    'integration_supports_revenue_natures.unique_id_categoria_economica',
    'integration_supports_revenue_natures.unique_id_origem',
    'integration_supports_revenue_natures.unique_id_subfonte'
  ]

  SORT_COLUMNS = [
  ]

  included do

    helper_method [
      :accounts,
      :revenues_tree,
      :nodes,
      :default_node_types,
      :default_node_types_path,
      :node_types,
      :node_types_options,
      :next_node_type,
      :current_node_level,
      :nodes_totals,
      :year,
      :multi_dependent_select
    ]

    def index
      respond_to do |format|
        format.html do
          if param_node_path.present?
            render_revenue_tree_node
          elsif show_stats?
            render_stats
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

    # Helper methods

    def multi_dependent_select
      'components/multi_dependent_select'
    end

    def accounts
      @accounts ||= filtered_accounts
    end

    def filtered_accounts
      return filtered_resources unless params_month_start.present? && params_month_end.present?
      filtered_resources.where(mes: (params_month_start..params_month_end).to_a)
    end

    def params_month_start
      params[:month_start]
    end

    def params_month_end
      params[:month_end]
    end

    def revenues_tree
      @revenues_tree ||= revenues_tree_klass.new(revenues_tree_resources, param_node_path)
    end

    def default_node_types
      # receita lançada  ou receita em transferência
      if revenues_tree_klass::NODES_TYPES.values.include? Integration::Revenues::RegisteredRevenuesTreeNodes::Revenue or
         revenues_tree_klass::NODES_TYPES.values.include? Integration::Revenues::TransfersTreeNodes::Transfer

          revenues_tree_klass::NODES_TYPES.keys
      else
        # outras receitas
        if revenues_tree_klass::NODES_TYPES[year.to_i]
          revenues_tree_klass::NODES_TYPES[year.to_i].keys
        else
          last_year = revenues_tree_klass::NODES_TYPES.keys.max
          revenues_tree_klass::NODES_TYPES[last_year].keys
        end
      end

    end

    def default_node_types_path
      default_node_types.join('/')
    end

    def node_types
      if param_node_types.present?
        types = param_node_types
        types.split('/').map(&:to_sym)
      else
        default_node_types
      end
    end

    def next_node_type
      if param_node_path.present?
        current_node_type_index = node_types.index(current_node_type)

        node_types[current_node_type_index + 1]
      else
        node_types.first
      end
    end

    def nodes
      @nodes ||= revenues_tree.nodes(next_node_type).sort_by! {|n| -1 * n[:valor_arrecadado]}
    end

    def current_node_type
      parent_node_paths.last[0].to_sym
    end

    def current_node_level
      return 0 if param_node_path.blank?

      node_types.index(current_node_type) + 1
    end

    def sorted_resources
      # Não ordenamos pois é apresentada como árvore e as colunas consolidadas
      # não existem no banco de dados.

      default_sort_scope
    end

    def node_types_options

      default_node_types.map do |node_type|
        [
          ::Integration::Supports::RevenueNature.human_attribute_name(node_type),
          node_type
        ]
      end
    end

    def nodes_totals
      return @nodes_totals if @nodes_totals.present?

      result = {
        valor_previsto_inicial: 0,
        valor_previsto_atualizado: 0,
        valor_arrecadado: 0
      }

      nodes.each do |nodes|
        result[:valor_previsto_inicial] += nodes[:valor_previsto_inicial]
        result[:valor_previsto_atualizado] += nodes[:valor_previsto_atualizado]
        result[:valor_arrecadado] += nodes[:valor_arrecadado]
      end

      @nodes_totals = result
    end


    # Private

    private

    def resource_klass
      Integration::Revenues::Account
    end

    def transparency_id
      'revenues/accounts'
    end

    def filtered_sum_column
      :valor_credito
    end

    def parent_node_paths
      param_node_path.split("/").in_groups_of(2)
    end

    def default_sort_scope
      resource_klass.joins({ revenue: :organ }, :revenue_nature)
        .from_year(year)
        .where(
          integration_supports_revenue_natures: {
            year: year_for_revenue_nature
          }
        )
    end

    def year_for_revenue_nature
      year.to_i <= 2018 ? '2018' : year
    end

    def param_search
      @param_search ||= params[:search]
    end

    def param_node_types
      @param_node_types ||= params[:node_types]
    end

    #
    # Parâmetro passado quando um nó da árvore é aberto. Devemos instanciar
    # a RevenueTree considerando o node_path como parent e renderizar a partial
    # index/nodes

    def param_node_path
      @param_node_path ||= params[:node_path]
    end

    def render_revenue_tree_node
      render html: cached_revenue_tree_node
    end

    def cached_revenue_tree_node
      cache(cache_key) do
        locals = {
          revenues_tree: revenues_tree,
          current_node_path: param_node_path,
          next_node_type: next_node_type,
          next_node_level: current_node_level + 1,
          node_types: node_types
        }

        render_to_string(partial: "shared/transparency/#{transparency_id}/index/nodes", locals: locals)
      end
    end

    def render_stats
      locals = {
        stats: stats,
        last_stats_month: last_stats_month_range,
        stats_cache_key: stats_cache_key
      }

      render partial: stats_partial_view_path, layout: false, locals: locals
    end

    def revenues_tree_klass
      Integration::Revenues::RevenuesTree
    end

    def revenues_tree_resources
      accounts
    end


    ## Spreadsheet

    def spreadsheet_download_prefix
      :revenues
    end

    def spreadsheet_file_prefix
      :receitas_poder_executivo
    end

    def spreadsheet_download_path(format)
      if stats.present?
        transparency_spreadsheet_download_path(spreadsheet_download_prefix, spreadsheet_file_prefix, stats.year, "#{stats.month_start}-#{stats.month_end}", format)
      end
    end

    ## Stats

    def stats_klass
      Stats::Revenues::Account
    end

    def data_dictionary_file_accounts_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_receitas_poder_executivo_ct.xlsx'
    end
  end
end
