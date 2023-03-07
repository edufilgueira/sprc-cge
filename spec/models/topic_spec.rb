require 'rails_helper'

describe Topic do
  it_behaves_like 'models/paranoia'

  subject(:topic) { build(:topic) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:topic, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:other_organs).of_type(:boolean).with_options(default: false) }

      # Audit
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:name) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }

    it { is_expected.to have_many(:subtopics).dependent(:destroy).inverse_of(:topic) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:subtopics).allow_destroy(true) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:acronym).to(:organ).with_prefix(true) }
    it { is_expected.to delegate_method(:name).to(:organ).with_prefix(true) }
    it { is_expected.to delegate_method(:title).to(:organ).with_prefix(true) }
    it { is_expected.to delegate_method(:full_title).to(:organ).with_prefix(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to_not validate_presence_of(:organ) }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:organ_id)  }
  end

  describe 'scope' do
    it 'sorted' do
      expect(Topic.sorted.to_sql).to eq(Topic.order('topics.name asc').to_sql)
    end

    it_behaves_like 'models/disableable'

    it 'not_other_organs' do
      create(:topic, :other_organs)
      topic.save
      expect(Topic.not_other_organs).to eq([topic])
    end

    it 'create only_no_characteristic' do
      topic = create(:topic, :no_characteristic)

      expect(Topic.only_no_characteristic).to eq(topic)
    end

    it 'create without_no_characteristic' do
      topic = create(:topic, :no_characteristic)

      expect(Topic.without_no_characteristic).not_to eq(topic)
    end
  end

  describe 'helpers' do
    context 'title' do
      it "with organ" do
        organ = create(:executive_organ)
        topic.organ = organ

        expected = "[#{topic.organ_acronym}] - #{topic.name}"

        expect(topic.title).to eq(expected)
      end

      it "without organ" do
        expect(topic.title).to eq(topic.name)
      end
    end
  end

  context 'callbacks' do

    context 'before_save' do

      it 'upcase_name' do
        topic = build(:topic, name: 'upcase name')

        topic.save

        expect(topic.name).to eq('UPCASE NAME')
      end

      context 'invoke nested set_disabled_at' do
        let(:subtopic) { build(:subtopic, _disable: '1') }
        let(:topic) { create(:topic) }

        before do
          allow(topic).to receive(:subtopics){ [subtopic] }
          allow(subtopic).to receive(:set_disabled_at)

          topic.save
        end

        it { expect(subtopic).to have_received(:set_disabled_at) }
      end
    end
  end
end
