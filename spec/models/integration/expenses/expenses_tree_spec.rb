require 'rails_helper'

describe Integration::Expenses::ExpensesTree do


  describe 'initialization' do
    it 'returns empty array for empty nodes class' do
      tree = Integration::Expenses::ExpensesTree.new(Integration::Expenses::BudgetBalance.none)

      expect(tree.nodes(:unknown_node_class)).to eq([])
    end

    it 'initializes nodes class for each type' do
      expect(Integration::Expenses::ExpensesTreeNodes::Secretary).to receive(:new).and_call_original

      tree = Integration::Expenses::ExpensesTree.new(Integration::Expenses::BudgetBalance.all)

      tree.nodes(:secretary)
    end

    it 'accepts string as identifier' do
      tree = Integration::Expenses::ExpensesTree.new(Integration::Expenses::BudgetBalance.all)

      expect(tree.nodes('secretary')).to eq(tree.nodes(:secretary))
    end
  end
end
