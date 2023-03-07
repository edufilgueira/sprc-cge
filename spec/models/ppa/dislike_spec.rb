require 'rails_helper'

RSpec.describe PPA::Dislike, type: :model do

  subject { build :ppa_dislike }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:interactable) }
  end

end
