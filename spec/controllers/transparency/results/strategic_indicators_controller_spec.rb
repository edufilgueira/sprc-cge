require 'rails_helper'

describe Transparency::Results::StrategicIndicatorsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/results/strategic_indicators/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/results/strategic_indicators/show'
  end
end
