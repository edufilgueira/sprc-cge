require 'rails_helper'

RSpec.describe PPA::StrategiesVoteItem, type: :model do

  #subject(:strategies_vote) { build :ppa_strategies_vote }

  describe 'db' do
    describe 'columns' do
      it {

        is_expected.to have_db_column(:strategy_id).of_type(:integer)
        is_expected.to have_db_column(:strategies_vote_id).of_type(:integer)
      }
    end

    describe 'indexes' do
      it {

        is_expected.to have_db_index(:strategy_id)
        is_expected.to have_db_index(:strategies_vote_id)
      }
    end
  end

  describe 'associations' do
    it {
      is_expected.to belong_to(:strategy)
      is_expected.to belong_to(:strategies_vote)
    }
  end
end
