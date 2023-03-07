class Transparency::Export::IntegrationExpensesBudgetBalancePresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :title,
    :calculated_valor_orcamento_atualizado,
    :calculated_valor_empenhado,
    :calculated_valor_liquidado,
    :calculated_valor_pago
  ].freeze

  # override
  def self.tree_structure
    true
  end

  def spreadsheet_row
    expenses_tree = Integration::Expenses::ExpensesTree.new(resource)
    nodes = expenses_tree.nodes(:organ)

    nodes.map do |node|
      columns.map do |column|
        node[column]
      end
    end
  end

  # Override

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/expenses/budget_balance.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
