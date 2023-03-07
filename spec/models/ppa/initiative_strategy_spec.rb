require 'rails_helper'

RSpec.describe PPA::InitiativeStrategy, type: :model do
  subject { build :ppa_initiative_strategy }

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_initiative_strategy, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:initiative) }
    it { is_expected.to belong_to(:strategy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:initiative) }
    it { is_expected.to validate_presence_of(:strategy) }

    context 'uniqueness' do
      subject { create :ppa_initiative_strategy }

      it { is_expected.to validate_uniqueness_of(:strategy_id).scoped_to(:initiative_id) }
    end
  end

end
