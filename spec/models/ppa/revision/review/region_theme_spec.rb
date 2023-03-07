require 'rails_helper'

RSpec.describe PPA::Revision::Review::RegionTheme, type: :model do
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:theme_id).of_type(:integer) }
      it { is_expected.to have_db_column(:region_id).of_type(:integer) }
      it { is_expected.to have_db_column(:problem_situation_strategy_id).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:theme) }
    it { is_expected.to belong_to(:region) }
    it { is_expected.to belong_to(:problem_situation_strategy) }
    it { is_expected.to have_many(:problem_situations) }
    it { is_expected.to have_many(:regional_strategies) }
    it { is_expected.to have_many(:new_regional_strategies) }
    it { is_expected.to have_many(:new_problem_situations) }
  end
end