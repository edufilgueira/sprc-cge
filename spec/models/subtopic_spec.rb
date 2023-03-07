require 'rails_helper'

describe Subtopic do
  it_behaves_like 'models/paranoia'

  subject(:subtopic) { build(:subtopic) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:subtopic, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:topic_id).of_type(:integer) }
      it { is_expected.to have_db_column(:other_organs).of_type(:boolean).with_options(default: false) }

      # Audit
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index([:name, :topic_id, :deleted_at]) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:topic) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:topic) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:topic_id) }
  end

  describe 'scope' do
    it 'sorted' do
      expect(Subtopic.sorted).to eq(Subtopic.order(:name))
    end

    it_behaves_like 'models/disableable'
  end

  describe 'helpers' do
    it 'title' do
      expect(subtopic.title).to eq(subtopic.name)
    end

    it 'not_other_organs' do
      create(:subtopic, :other_organs)
      subtopic.save
      expect(Subtopic.not_other_organs).to eq([subtopic])
    end
  end

  context 'callbacks' do
    it 'upcase_name' do
      subtopic = build(:subtopic, name: 'upcase name')

      subtopic.save

      expect(subtopic.name).to eq('UPCASE NAME')
    end
  end
end
