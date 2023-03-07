require 'rails_helper'

describe Integration::Supports::OrganServerRole do

  subject(:integration_supports_organ_server_role) { build(:integration_supports_organ_server_role) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_organ_server_role, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:integration_supports_organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:integration_supports_server_role_id).of_type(:integer) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it 'organ' do
      expect(integration_supports_organ_server_role).to belong_to(:role).
        with_foreign_key('integration_supports_server_role_id').
        class_name('Integration::Supports::ServerRole')

      expect(integration_supports_organ_server_role).to belong_to(:organ).
        with_foreign_key('integration_supports_organ_id').
        class_name('Integration::Supports::Organ')
    end
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:role) }
      it { is_expected.to validate_presence_of(:organ) }
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:integration_supports_server_role_id).scoped_to(:integration_supports_organ_id) }
    end
  end
end
