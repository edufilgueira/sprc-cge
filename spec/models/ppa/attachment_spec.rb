require 'rails_helper'

RSpec.describe PPA::Attachment, type: :model do

  subject { build :ppa_attachment }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:uploadable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:attachment_filename) }
  end

end
