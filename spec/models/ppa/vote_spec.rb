require 'rails_helper'

RSpec.describe PPA::Vote, type: :model do

  subject { build :ppa_vote }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:interactable) }
  end

end
