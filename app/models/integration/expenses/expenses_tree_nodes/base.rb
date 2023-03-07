#
# Representação básica e compartilhada dos nós da árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::Base

  attr_reader :initial_scope, :parent_node_path

  NODE_SCOPE_COLUMNS = {
    secretary: 'integration_expenses_budget_balances.integration_supports_secretary_id',
    organ: 'integration_expenses_budget_balances.integration_supports_organ_id',
    function: 'integration_supports_functions.codigo_funcao',
    sub_function: 'integration_supports_sub_functions.codigo_sub_funcao',
    government_program: 'integration_expenses_budget_balances.integration_supports_government_program_id',
    government_action: 'integration_supports_government_actions.codigo_acao',
    economic_category: 'integration_supports_economic_categories.codigo_categoria_economica',
    application_modality: 'integration_supports_application_modalities.codigo_modalidade',
    expense_element: 'integration_supports_expense_elements.codigo_elemento_despesa',
    administrative_region: 'integration_supports_administrative_regions.codigo_regiao_resumido',
    expense_nature: 'integration_supports_expense_natures.codigo_natureza_despesa',
    qualified_resource_source: 'integration_supports_qualified_resource_sources.codigo',
    finance_group: 'integration_supports_finance_groups.codigo_grupo_financeiro'
  }.with_indifferent_access

  def initialize(initial_scope, parent_node_path = nil)
    @initial_scope = scoped_to_parent(initial_scope, parent_node_path)
    @parent_node_path = parent_node_path
  end

  # Método padrão para gerar os nós que pode ser sobrescrito pelos nós específicos
  def nodes
    result = []

    resources_with_budget_balances.each do |resource|
      budget_balances = budget_balances_from_resource(resource)

      result << {
        resource: resource,
        id: resource_id(resource),
        type: resource_type,
        title: resource_title(resource)
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  def resource_id(resource)
    resource.id
  end

  def resource_title(resource)
    resource.title
  end

  private

  def scoped_to_parent(scope, parent_node_path)
    scope = base_scope_from_executivo(scope)

    return scope if parent_node_path.blank?

    # quebra  "secretary/2/organ/9" em
    # [["secretary", "2"], ["organ", "9"]]

    parents_path = parent_node_path.split('/').in_groups_of(2)

    parents_path.each do |parent_path|
      # cada parent_path é um array do tipo ["secretary", "2"]

      node_type, node_id = parent_path

      scope = scoped_to_node(scope, node_type, node_id)
    end

    scope
  end

  def scoped_to_node(scope, node_type, node_id)
    column = NODE_SCOPE_COLUMNS[node_type]

    if column.present?
      scope.where("#{column} = ?", node_id)
    else
      scope
    end
  end

  def include_tables
    NODE_SCOPE_COLUMNS.keys
  end

  def nodes_data(budget_balances)
    budget_balances_sums = budget_balances.pluck(%Q{
      SUM(calculated_valor_orcamento_inicial),
      SUM(calculated_valor_orcamento_atualizado),
      SUM(calculated_valor_empenhado),
      SUM(calculated_valor_liquidado),
      SUM(calculated_valor_pago)
    })

    {
      calculated_valor_orcamento_inicial: budget_balances_sums[0][0],
      calculated_valor_orcamento_atualizado: budget_balances_sums[0][1],
      calculated_valor_empenhado: budget_balances_sums[0][2],
      calculated_valor_liquidado: budget_balances_sums[0][3],
      calculated_valor_pago: budget_balances_sums[0][4]
    }
  end

  def base_scope_from_executivo(scope)
    scope.
      includes(include_tables).
      references(include_tables).
      where('integration_supports_organs.poder = ?', 'EXECUTIVO').
      reorder('')
  end
end
