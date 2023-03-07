require 'rails_helper'

RSpec.describe PPA::Revision::Review::RegionalStrategy, type: :model do
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:strategy_id).of_type(:integer) }
      it { is_expected.to have_db_column(:persist).of_type(:boolean) }
      it { is_expected.to have_db_column(:region_theme_id).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:strategy) }
    it { is_expected.to belong_to(:region_theme) }
  end

  describe 'validations' do
    # it { is_expected.to validate_presence_of(:strategy_id) }
    # it { is_expected.to validate_presence_of(:persist) }
    # it { is_expected.to validate_presence_of(:problem_situation_strategy_id) }

  end
end
