require 'rails_helper'

RSpec.describe PPA::Interaction, type: :model do

  subject { build :ppa_interaction }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:interactable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'factories' do
    it { is_expected.to be_valid }

    context 'invalid' do
      subject { build :ppa_interaction, :invalid }

      it { is_expected.to be_invalid }
    end
  end

end
