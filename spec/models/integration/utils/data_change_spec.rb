require 'rails_helper'

describe Integration::Utils::DataChange do
  subject(:changes) { build(:integration_utils_data_change) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_utils_data_change, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:data_changes).of_type(:jsonb) }
      it { is_expected.to have_db_column(:changeable_id).of_type(:integer) }
      it { is_expected.to have_db_column(:changeable_type).of_type(:string) }
      it { is_expected.to have_db_column(:resource_status).of_type(:integer).with_options(default: :new_resource_notificable) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:resource_status) }
      it { is_expected.to have_db_index([:changeable_id, :changeable_type]) }
      it { is_expected.to have_db_index([:resource_status, :changeable_id, :changeable_type]) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:changeable) }
  end

  describe 'enumarations' do
    expected = [:new_resource_notificable, :updated_resource_notificable, :resource_notified]

    it { is_expected.to define_enum_for(:resource_status).with_values(expected) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:changeable_id) }
    it { is_expected.to validate_presence_of(:changeable_type) }
  end
end
