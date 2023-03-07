require 'rails_helper'

RSpec.describe PPA::ThemeStrategy, type: :model do

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:theme_id).of_type(:integer) }
      it { is_expected.to have_db_column(:strategy_id).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:theme) }
    it { is_expected.to belong_to(:strategy) }
  end


  describe 'validations' do
    it { is_expected.to validate_presence_of(:theme) }
    it { is_expected.to validate_presence_of(:strategy) }
  end

end
