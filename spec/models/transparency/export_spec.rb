require 'rails_helper'

describe Transparency::Export do

  subject(:transparency_export) { build(:transparency_export) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:transparency_export, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:query).of_type(:string) }
      it { is_expected.to have_db_column(:resource_name).of_type(:string) }
      it { is_expected.to have_db_column(:expiration).of_type(:datetime) }
      it { is_expected.to have_db_column(:filename).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:worksheet_format) }
    it { is_expected.to validate_presence_of(:query) }
    it { is_expected.to validate_presence_of(:resource_name) }

    describe 'email' do
      context 'allowed' do
        it { is_expected.to allow_value("admin@example.com").for(:email) }
        it { is_expected.to allow_value("admin@example.br").for(:email) }
      end

      context 'denied' do

        # Cusmomizando validação pois esta validação não é barrada pelo devise
        it { is_expected.to_not allow_value("admin@example").for(:email) }

        it { is_expected.to_not allow_value("").for(:email) }
        it { is_expected.to_not allow_value("admin@").for(:email) }
        it { is_expected.to_not allow_value("admin").for(:email) }
        it { is_expected.to_not allow_value("@example").for(:email) }
        it { is_expected.to_not allow_value("@example.com").for(:email) }
        it { is_expected.to_not allow_value("@example.com.br").for(:email) }
      end
    end

  end

  describe 'enum' do
    it 'statuses' do
      statuses = [
        :queued,
        :in_progress,
        :error,
        :success
      ]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end

    it 'worksheet_format' do
      worksheet_formats = [
        :xlsx,
        :csv
      ]

      is_expected.to define_enum_for(:worksheet_format).with_values(worksheet_formats)
    end
  end

  describe 'callbacks' do
    it 'remove_spreadsheet' do
      export = create(:transparency_export, :server_salary)
      export.update(filename: "#{export.id}_#{export.underscored_resource}.csv")

      filepath = export.filepath

      FileUtils.mkdir_p(export.dirpath)

      exportfile = File.open(filepath, 'w')

      expect(File.exist?(filepath)).to be_truthy

      export.destroy

      expect(File.exist?(filepath)).to be_falsey
    end
  end
end
