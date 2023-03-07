require 'rails_helper'

RSpec.describe PPA::StrategiesVote, type: :model do

  #subject(:strategies_vote) { build :ppa_strategies_vote }

  describe 'db' do
    describe 'columns' do
      it {
        is_expected.to have_db_column(:user_id).of_type(:integer)
        #is_expected.to have_db_column(:strategy_id).of_type(:integer)
        is_expected.to have_db_column(:region_id).of_type(:integer)
      }
    end

    describe 'indexes' do
      it {
        is_expected.to have_db_index(:user_id)
        #is_expected.to have_db_index(:strategy_id)
        is_expected.to have_db_index(:region_id)
      }
    end
  end

  describe 'associations' do
    it {
      is_expected.to belong_to(:user)
      #is_expected.to belong_to(:strategy)
      is_expected.to belong_to(:region)
    }
  end
end
