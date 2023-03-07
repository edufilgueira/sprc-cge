require 'rails_helper'

RSpec.describe PPA::Axis, type: :model do

  subject(:axis) { build :ppa_axis }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:code).scoped_to(:plan_id) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:plan_id) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:themes).dependent(:destroy) }
  end

  describe 'factories' do
    context 'default' do
      it { is_expected.to be_valid }
    end

    context 'invalid' do
      subject { build :ppa_axis, :invalid }

      it { is_expected.to be_invalid }
    end
  end

end
