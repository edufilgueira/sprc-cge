require 'rails_helper'

describe Integration::Constructions::Der::Measurement do

  describe 'associations' do
    it { is_expected.to belong_to(:integration_constructions_der).class_name('Integration::Constructions::Der') }

    it do
      is_expected.to have_one(:utils_data_change).class_name('Integration::Utils::DataChange')
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:data_changes).to(:utils_data_change).with_arguments(allow_nil: true) }
    it { is_expected.to delegate_method(:resource_status).to(:utils_data_change).with_arguments(allow_nil: true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :integration_constructions_der }
    it { is_expected.to validate_presence_of :id_obra }
    it { is_expected.to validate_presence_of :id_medicao }
  end

  describe 'callbacks' do
    it 'notify_create' do
      measurement = create(:integration_constructions_der_measurement)

      expect(measurement.utils_data_change.new_resource_notificable?).to be_truthy
      expect(measurement.data_changes).to eq(nil)
    end
  end
end
