require 'rails_helper'

describe Theme do
  it_behaves_like 'models/paranoia'

  subject(:theme) { build(:theme) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:theme, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:code).of_type(:string) }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
  end

  describe 'scope' do
    it 'sorted' do
      expected = Theme.order('themes.code ASC').to_sql.downcase
      result = Theme.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end

    it_behaves_like 'models/disableable'
  end

  describe 'helpers' do
    it 'title' do
      expect(theme.title).to eq(theme.name)
    end
  end
end
