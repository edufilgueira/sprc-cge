require 'rails_helper'

describe Transparency::Results::ThematicIndicatorsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/results/thematic_indicators/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/results/thematic_indicators/show'
  end
end
