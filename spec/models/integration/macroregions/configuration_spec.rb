require 'rails_helper'

describe Integration::Macroregions::Configuration do
  subject(:configuration) { build(:integration_macroregions_configuration) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_macroregions_configuration, :invalid)).to be_invalid }
  end

  describe 'db' do
    # Tested @ SPRC-DATA
  end

  describe 'associations' do
    # Tested @ SPRC-DATA
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:schedule) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:cron_syntax_frequency).to(:schedule) }
  end

  describe 'validations' do
    # Tested @ SPRC-DATA
  end

  describe 'enums' do
    it 'status' do
      statuses = [:status_queued, :status_in_progress, :status_success, :status_fail]
      is_expected.to define_enum_for(:status).with_values(statuses)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(configuration.title).to eq configuration.model_name.human
    end

    it 'status_str' do
      configuration.status_success!
      expect(configuration.status_str).to eq I18n.t("integration/base_configuration.statuses.status_success")
    end
  end
end
