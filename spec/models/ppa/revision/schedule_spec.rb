require 'rails_helper'

RSpec.describe PPA::Revision::Schedule, type: :model do
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:start_in).of_type(:date) }
      it { is_expected.to have_db_column(:end_in).of_type(:date) }
      it { is_expected.to have_db_column(:plan_id).of_type(:integer) }
      it { is_expected.to have_db_column(:stage).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:plan) }
    it { is_expected.to validate_presence_of(:stage) }
    it { is_expected.to validate_presence_of(:start_in) }
    it { is_expected.to validate_presence_of(:end_in) }
  end
end
