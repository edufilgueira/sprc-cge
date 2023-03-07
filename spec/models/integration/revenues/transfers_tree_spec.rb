require 'rails_helper'

describe Integration::Revenues::TransfersTree do
  describe 'initialization' do
    it 'returns empty array for empty nodes class' do
      tree = Integration::Revenues::TransfersTree.new(Integration::Revenues::Transfer.none)

      expect(tree.nodes(:unknown_node_class)).to eq([])
    end

    it 'initializes nodes class for each type' do
      expect(Integration::Revenues::RevenuesTreeNodes::Secretary).to receive(:new).and_call_original

      tree = Integration::Revenues::TransfersTree.new(Integration::Revenues::Transfer.all)

      tree.nodes(:secretary)
    end

    it 'accepts string as identifier' do
      tree = Integration::Revenues::TransfersTree.new(Integration::Revenues::Transfer.all)

      expect(tree.nodes('secretary')).to eq(tree.nodes(:secretary))
    end
  end
end
