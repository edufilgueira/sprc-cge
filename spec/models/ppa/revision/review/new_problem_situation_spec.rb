require 'rails_helper'

RSpec.describe PPA::Revision::Review::NewProblemSituation, type: :model do
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:region_theme_id).of_type(:integer) }
      it { is_expected.to have_db_column(:city_id).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:city) }
    it { is_expected.to belong_to(:region_theme) }
  end
end
