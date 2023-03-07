require 'rails_helper'

describe AnswerTemplate do
  subject(:answer_template) { build(:answer_template) }

  it_behaves_like 'models/timestamp'

  describe 'factories' do
    it { is_expected.to be_valid }
    it { expect(build(:answer_template, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:content).of_type(:text) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:user_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'helpers' do
    it 'title' do
      expect(answer_template.title).to eq(answer_template.name)
    end
  end

  describe 'scope' do
    it 'sorted' do
      expected = AnswerTemplate.order('answer_templates.name ASC').to_sql.downcase
      result = AnswerTemplate.sorted.to_sql.downcase

      expect(result).to eq(expected)
    end
  end

end
