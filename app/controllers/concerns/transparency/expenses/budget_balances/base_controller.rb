module Transparency::Expenses::BudgetBalances::BaseController
  extend ActiveSupport::Concern
  include Transparency::BaseController
  include Transparency::StatsMonthRange::BaseController

  FILTERED_COLUMNS = [
    'integration_supports_secretary_id',
    'integration_supports_organ_id',
    'cod_funcao',
    'cod_subfuncao',
    'integration_supports_government_program_id',
    'cod_natureza_desp',
    'cod_fonte',
    'cod_grupo_fin',
    'cod_categoria_economica',
    'cod_grupo_desp',
    'cod_modalidade_aplicacao',
    'cod_elemento_despesa'
  ]

  SORT_COLUMNS = [
  ]

  INCLUDES = [
    :secretary,
    :organ,
    :function,
    :sub_function,
    :government_program,
    :government_action,
    :administrative_region,
    :expense_nature,
    :qualified_resource_source,
    :finance_group
  ]

  included do

    helper_method [
      :budget_balances,
      :expenses_tree,
      :nodes,
      :default_node_types,
      :default_node_types_path,
      :node_types,
      :node_types_options,
      :next_node_type,
      :current_node_level,
      :nodes_totals,

      :year,

      :max_budget_balances_for_open_nodes
    ]

    def index
      respond_to do |format|
        format.html do
          if param_node_path.present?
            render_expense_tree_node
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

    def budget_balances
      @budget_balances ||= filtered_budget_balances
    end

    def filtered_budget_balances
      return filtered_resources unless params_month_start.present? && params_month_end.present?

      filtered_resources.where(month: (params_month_start..params_month_end).to_a)
    end

    def params_month_start
      params[:month_start]
    end

    def params_month_end
      params[:month_end]
    end

    def expenses_tree
      @expenses_tree ||= expenses_tree_klass.new(budget_balances, param_node_path)
    end

    def default_node_types
      expenses_tree_klass::NODES_TYPES.keys
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
      @nodes ||= expenses_tree.nodes(next_node_type).sort_by! {|n| -1 * n[:calculated_valor_orcamento_inicial]}
    end

    def current_node_type
      parent_node_paths.last[0].to_sym
    end

    def current_node_level
      return 0 if param_node_path.blank?

      node_types.index(current_node_type) + 1
    end

    def max_budget_balances_for_open_nodes
      150
    end

    def sorted_resources
      # Não ordenamos pois é apresentada como árvore e as colunas consolidadas
      # não existem no banco de dados.

      default_sort_scope
    end

    def node_types_options
      default_node_types.map do |node_type|
        [
          resource_klass.human_attribute_name(node_type),
          node_type
        ]
      end
    end

    def nodes_totals
      return @nodes_totals if @nodes_totals.present?

      result = {
        calculated_valor_orcamento_inicial: 0,
        calculated_valor_orcamento_atualizado: 0,
        calculated_valor_empenhado: 0,
        calculated_valor_liquidado: 0,
        calculated_valor_pago: 0
      }

      nodes.each do |nodes|
        result[:calculated_valor_orcamento_inicial] += nodes[:calculated_valor_orcamento_inicial]
        result[:calculated_valor_orcamento_atualizado] += nodes[:calculated_valor_orcamento_atualizado]
        result[:calculated_valor_empenhado] += nodes[:calculated_valor_empenhado]
        result[:calculated_valor_liquidado] += nodes[:calculated_valor_liquidado]
        result[:calculated_valor_pago] += nodes[:calculated_valor_pago]
      end

      @nodes_totals = result
    end


    # Private

    private

    def resource_klass
      Integration::Expenses::BudgetBalance
    end

    def transparency_id
      'expenses/budget_balances'
    end

    def filtered_sum_column
      :calculated_valor_pago
    end

    def parent_node_paths
      param_node_path.split("/").in_groups_of(2)
    end

    def default_sort_scope
      resource_klass.from_year(year).
        includes(INCLUDES).
        references(INCLUDES).
        where('integration_supports_organs.poder = ?', 'EXECUTIVO')
    end

    ## Params

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

    def render_expense_tree_node
      render html: cached_expense_tree_node
    end

    def cached_expense_tree_node
      cache(cache_key) do
        locals = {
          expenses_tree: expenses_tree,
          current_node_path: param_node_path,
          next_node_type: next_node_type,
          next_node_level: current_node_level + 1,
          node_types: node_types,
          nodes: nodes
        }

        render_to_string(partial: 'shared/transparency/expenses/budget_balances/index/nodes', locals: locals)
      end
    end

    def render_stats
      locals = {
        stats: stats,
        last_stats_month: last_stats_month_range,
        last_stats_year: last_stats_year,
        stats_cache_key: stats_cache_key
      }

      render partial: stats_partial_view_path, layout: false, locals: locals
    end

    def expenses_tree_klass
      Integration::Expenses::ExpensesTree
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/budget_balances'
    end

    def spreadsheet_file_prefix
      :despesas_poder_executivo
    end

    def spreadsheet_download_path(format)
      if stats.present?
        transparency_spreadsheet_download_path(spreadsheet_download_prefix, spreadsheet_file_prefix, stats.year, "#{stats.month_start}-#{stats.month_end}", format)
      end
    end

    ## Stats

    def stats_klass
      Stats::Expenses::BudgetBalance
    end

    def data_dictionary_file_budget_balances_path
      "#{dir_data_dictionary}#{data_dictionary_file_name}"
    end

    def data_dictionary_file_name
      'dicionario_dados_despesas_poder_executivo_ct.xlsx'
    end
  end
end
