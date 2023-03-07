require 'rails_helper'

describe Transparency::CityUndertakingsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/city_undertakings/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/city_undertakings/show'
  end
end
