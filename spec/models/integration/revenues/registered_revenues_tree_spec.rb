require 'rails_helper'

describe Integration::Revenues::RegisteredRevenuesTree do
  describe 'initialization' do
    it 'returns empty array for empty nodes class' do
      tree = Integration::Revenues::RegisteredRevenuesTree.new(Integration::Revenues::RegisteredRevenue.none)

      expect(tree.nodes(:unknown_node_class)).to eq([])
    end

    it 'initializes nodes class for each type' do
      expect(Integration::Revenues::RegisteredRevenuesTreeNodes::Month).to receive(:new).and_call_original

      tree = Integration::Revenues::RegisteredRevenuesTree.new(Integration::Revenues::RegisteredRevenue.all)

      tree.nodes(:month)
    end

    it 'accepts string as identifier' do
      tree = Integration::Revenues::RegisteredRevenuesTree.new(Integration::Revenues::RegisteredRevenue.all)

      expect(tree.nodes('month')).to eq(tree.nodes(:month))
    end
  end
end
