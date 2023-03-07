#
# Representação em árvores de despesas
#
#

class Integration::Expenses::ExpensesTree

  NODES_TYPES = {
    secretary: Integration::Expenses::ExpensesTreeNodes::Secretary,
    organ: Integration::Expenses::ExpensesTreeNodes::Organ,
    function: Integration::Expenses::ExpensesTreeNodes::Function,
    sub_function: Integration::Expenses::ExpensesTreeNodes::SubFunction,
    government_program: Integration::Expenses::ExpensesTreeNodes::GovernmentProgram,
    government_action: Integration::Expenses::ExpensesTreeNodes::GovernmentAction,
    economic_category: Integration::Expenses::ExpensesTreeNodes::EconomicCategory,
    application_modality: Integration::Expenses::ExpensesTreeNodes::ApplicationModality,
    expense_element: Integration::Expenses::ExpensesTreeNodes::ExpenseElement,
    administrative_region: Integration::Expenses::ExpensesTreeNodes::AdministrativeRegion,
    expense_nature: Integration::Expenses::ExpensesTreeNodes::ExpenseNature,
    qualified_resource_source: Integration::Expenses::ExpensesTreeNodes::QualifiedResourceSource,
    finance_group: Integration::Expenses::ExpensesTreeNodes::FinanceGroup
  }

  attr_reader :initial_scope, :parent_node_path

  def initialize(initial_scope, parent_node_path = nil)
    @initial_scope = initial_scope
    @parent_node_path = parent_node_path
  end

  def nodes(nodes_type)
    nodes_class = NODES_TYPES.with_indifferent_access[nodes_type]

    return [] if nodes_class.blank?

    nodes_class.new(initial_scope, parent_node_path).nodes
  end
end
