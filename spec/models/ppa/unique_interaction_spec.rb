require 'rails_helper'

RSpec.describe PPA::UniqueInteraction, type: :model do

  subject { build :ppa_unique_interaction }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:interactable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:interactable_type, :interactable_id) }
  end

  describe 'factories' do
    it { is_expected.to be_valid }

    context 'invalid' do
      subject { build :ppa_unique_interaction, :invalid }

      it { is_expected.to be_invalid }
    end
  end

end
