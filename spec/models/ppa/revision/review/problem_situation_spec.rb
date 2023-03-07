require 'rails_helper'

RSpec.describe PPA::Revision::Review::ProblemSituation, type: :model do
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:persist).of_type(:boolean) }
      it { is_expected.to have_db_column(:problem_situation_id).of_type(:integer) }
      it { is_expected.to have_db_column(:region_theme_id).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:problem_situation) }
    it { is_expected.to belong_to(:region_theme) }
  end
end
