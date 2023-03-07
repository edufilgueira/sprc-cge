require 'rails_helper'

RSpec.describe PPA::Revision::Review::ProblemSituationStrategy, type: :model do
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:plan_id).of_type(:integer) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:problem_situations) }
    it { is_expected.to have_many(:regional_strategies) }
    it { is_expected.to have_many(:new_regional_strategies) }
    it { is_expected.to have_many(:new_problem_situations) }
  end
end
