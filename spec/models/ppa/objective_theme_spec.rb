require 'rails_helper'

RSpec.describe PPA::ObjectiveTheme, type: :model do

  subject { build :ppa_objective_theme }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_objective_theme, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:objective) }
    it { is_expected.to belong_to(:theme) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:objective) }
    it { is_expected.to validate_presence_of(:theme) }

    context 'uniqueness' do
      subject { create :ppa_objective_theme }

      it { is_expected.to validate_uniqueness_of(:theme_id).scoped_to(:objective_id, :region_id) }
    end
  end

end
