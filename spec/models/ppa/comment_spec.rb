require 'rails_helper'

RSpec.describe PPA::Comment, type: :model do

  subject { build :ppa_comment }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:interactable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'factories' do
    it { is_expected.to be_valid }

    context 'invalid' do
      subject { build :ppa_comment, :invalid }

      it { is_expected.to be_invalid }
    end
  end

end
