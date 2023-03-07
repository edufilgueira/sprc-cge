require 'rails_helper'

describe Transparency::RealStatesController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/real_states/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/real_states/show'
  end
end
