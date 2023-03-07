require 'rails_helper'

RSpec.describe PPA::Plan, type: :model do

  subject(:plan) { build :ppa_plan }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(plan.start_year).to eq Date.today.year }

    context 'past' do
      let(:past_plan) { build :ppa_plan, :past }
      it { expect(past_plan).to be_valid }
      it { expect(past_plan.start_year).to eq(Date.today.year - 1) }
    end

    context 'future' do
      let(:future_plan) { build :ppa_plan, :future }
      it { expect(future_plan).to be_valid }
      it { expect(future_plan.start_year).to eq(Date.today.year + 1) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:workshops) }
    it { is_expected.to have_many(:proposals).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_year) }
    it { is_expected.to validate_uniqueness_of(:start_year) }
    it { is_expected.to validate_numericality_of(:start_year).only_integer }

    it { is_expected.to validate_presence_of(:end_year) }
    it { is_expected.to validate_uniqueness_of(:end_year) }
    it { is_expected.to validate_numericality_of(:end_year).only_integer }
    it { is_expected.to_not allow_value(subject.start_year).for(:end_year) }

    describe 'duration' do
      it 'cannot be longer than 4 years' do
        plan = build :ppa_plan, start_year: 2016, end_year: 2020

        expect(plan).to include_error(:invalid_duration, duration: PPA::Plan::DURATION)
          .on(:end_year)
      end

      it 'cannot be shorter than 4 years' do
        plan = build :ppa_plan, start_year: 2016, end_year: 2018

        expect(plan).to include_error(:invalid_duration, duration: PPA::Plan::DURATION)
          .on(:end_year)
      end
    end

    describe 'interpolated plan periods' do
      before { subject.save! }

      let(:other_plan) { build :ppa_plan  }

      before { other_plan.validate }

      it 'doesnt allow overlapping periods' do
        expect(other_plan).to include_error(:invalid_range).on(:base)
      end
    end


  end

  describe '#end_date' do
    it { expect(plan.end_date).to eq Date.parse("#{plan.end_year}-12-31") }
  end

  context 'finder methods' do
    describe '.find_by_year' do
      context 'for 2016 to 2019 plan' do
        let!(:plan) { create :ppa_plan, start_year: 2016, end_year: 2019 }

        subject { PPA::Plan.find_by_year(year) }

        context 'for each year in its duration' do
          (2016..2019).each do |year|
            context "for year #{year}" do
              let(:year) { year }
              it { is_expected.to eq plan }
            end
          end
        end

        context 'for year 2015 - before plan duration' do
          let(:year) { 2015 }
          it { is_expected.to eq nil }
        end

        context 'for year 2020 - before plan duration' do
          let(:year) { 2020 }
          it { is_expected.to eq nil }
        end
      end
    end

    describe '.find_by_biennium' do
      context 'for 2020 to 2024 plan' do
        let!(:plan) { create :ppa_plan, base_date: Date.new(2020,1,1) }

        it 'returns it for 2020-2021 range' do
          expect(PPA::Plan.find_by_biennium([2020, 2021])).to eq plan
        end

        it 'returns it for 2022-2023 range' do
          expect(PPA::Plan.find_by_biennium([2022, 2023])).to eq plan
        end

        it 'returns nil for 2023-2024 range' do
          expect(PPA::Plan.find_by_biennium('2023-2024')).to be_nil
        end

        it 'return nil for 2019-2020 range' do
          expect(PPA::Plan.find_by_biennium('2019-2020')).to be_nil
        end
      end
    end

    describe '.current' do
      context 'when a matching plan exists' do
        let!(:plan)        { create :ppa_plan }
        let!(:future_plan) { create :ppa_plan, start_year: (plan.start_year + 5) }

        it 'returns it' do
          expect(PPA::Plan.current).to eq plan
        end
      end

      context 'when a matching plan doesnt exist' do
        let!(:future_plan) { create :ppa_plan, :future }

        it 'returns nil' do
          expect(PPA::Plan.current).to eq nil
        end
      end
    end
  end

end