require 'rails_helper'

describe Stats::Evaluation do

  describe 'db' do
    it 'columns' do
      is_expected.to have_db_column(:data).of_type(:jsonb)
      is_expected.to have_db_column(:evaluation_type).of_type(:integer)
      is_expected.to have_db_column(:month).of_type(:integer)
      is_expected.to have_db_column(:year).of_type(:integer)

      is_expected.to have_db_column(:created_at).of_type(:datetime)
      is_expected.to have_db_column(:updated_at).of_type(:datetime)
    end

    it 'indexes' do
      is_expected.to have_db_index(:evaluation_type)
      is_expected.to have_db_index([:year, :month])
    end
  end

  describe 'validations' do
    it 'presence' do
      is_expected.to validate_presence_of(:month)
      is_expected.to validate_presence_of(:year)
      is_expected.to validate_presence_of(:evaluation_type)
    end

    it 'uniqueness' do
      is_expected.to validate_uniqueness_of(:month).scoped_to([:year, :evaluation_type])
    end
  end

  describe 'enumarations' do
    it 'evaluation_type' do
      expected = [:sou, :sic, :call_center, :transparency]

      is_expected.to define_enum_for(:evaluation_type).with_values(expected)
    end
  end

  describe 'class_methods' do
    describe 'scopes' do

      it 'from_year_month_type' do
        stat = create(:stats_evaluation)

        expect(Stats::Evaluation.from_year_month_type(stat.year, stat.month, :sou))
      end

      it 'sorted' do
        first = create(:stats_evaluation, year: 2018, month: 2, evaluation_type: 'sou')
        second = create(:stats_evaluation, year: 2018, month: 1, evaluation_type: 'sou')
        third = create(:stats_evaluation, year: 2017, month: 2, evaluation_type: 'sou')
        fourth = create(:stats_evaluation, year: 2017, month: 1, evaluation_type: 'sou')

        expect(Stats::Evaluation.sorted('sou')).to eq([first, second, third, fourth])
      end
    end
  end
end
