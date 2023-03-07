require 'rails_helper'

RSpec.describe PPA::Like, type: :model do

  subject { build :ppa_like }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:interactable) }
  end

end
