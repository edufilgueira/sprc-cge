require 'rails_helper'

RSpec.describe PPA::Region, type: :model do

  subject { build :ppa_region }

  describe 'factories' do
    it { is_expected.to be_valid }

    context 'invalid' do
      subject { build :ppa_region, :invalid }

      it { is_expected.to be_invalid }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:cities).dependent(:nullify) }
    it { is_expected.to have_many(:objectives) }
    it { is_expected.to have_many(:strategies) }
    it { is_expected.to have_many(:annual_regional_strategies) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

end
