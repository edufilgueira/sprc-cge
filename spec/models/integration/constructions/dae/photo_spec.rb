require 'rails_helper'

RSpec.describe Integration::Constructions::Dae::Photo, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:integration_constructions_dae).class_name('Integration::Constructions::Dae') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :integration_constructions_dae }
    it { is_expected.to validate_presence_of :codigo_obra }
    it { is_expected.to validate_presence_of :id_medicao }
  end
end
