require 'rails_helper'

describe SearchContent do

  subject(:search_content) { build(:search_content) }

  it_behaves_like 'models/base'

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:link).of_type(:string) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description)  }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:link) }
  end

  describe 'scope' do
    it 'sorted' do
      expected = SearchContent.joins(:translations).where("search_content_translations.locale = '#{I18n.locale}'").order('search_content_translations.title ASC').to_sql.downcase
      result = SearchContent.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end
  end
end
