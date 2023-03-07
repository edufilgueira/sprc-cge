require 'rails_helper'

RSpec.describe PPA::Biennium, type: :model do

  subject(:biennium) { described_class.new('2016-2017') }

  describe 'initializing' do
    describe '::new' do
      context 'with a String, parsing "2016-2017" as "#{start_year}-#{end_year}"' do
        subject(:biennium) { described_class.new('2016-2017') }

        it 'raise ArgumentError when String is not in the defined format' do
          expect { described_class.new('a-format') }.to raise_error ArgumentError
        end

        context 'parsing start_year' do
          subject { biennium.start_year }
          it { is_expected.to eq 2016 }
        end

        context 'parsing end_year' do
          subject { biennium.end_year }
          it { is_expected.to eq 2017 }
        end
      end

      context 'with an Array, parsing [2016, 2017] as [first_year, last_year]' do
        subject(:biennium) { described_class.new([2016, 2017]) }

        it 'raise ArgumentError when Array is not in the defined format' do
          expect do
            described_class.new([2016, 2017, 'invalid-format'])
          end.to raise_error ArgumentError
        end

        context 'parsing start_year' do
          subject { biennium.start_year }
          it { is_expected.to eq 2016 }
        end

        context 'parsing end_year' do
          subject { biennium.end_year }
          it { is_expected.to eq 2017 }
        end
      end

      context 'with an Hash, parsing { start_year: 2016, end_year: 2017 }' do
        subject(:biennium) { described_class.new(start_year: 2016, end_year: 2017) }

        it 'raise ArgumentError when Array is not in the defined format' do
          expect do
            described_class.new({ first: 2016, last: 2017 })
          end.to raise_error ArgumentError
        end

        context 'parsing start_year' do
          subject { biennium.start_year }
          it { is_expected.to eq 2016 }
        end

        context 'parsing end_year' do
          subject { biennium.end_year }
          it { is_expected.to eq 2017 }
        end
      end

      context 'with a PPA::Biennium' do
        let(:existing_biennium) { described_class.new([2016, 2017]) }
        subject(:biennium) { described_class.new(existing_biennium) }

        context 'parsing start_year' do
          subject { biennium.start_year }
          it { is_expected.to eq 2016 }
        end

        context 'parsing end_year' do
          subject { biennium.end_year }
          it { is_expected.to eq 2017 }
        end
      end
    end # end ::new


    describe '::from(year)' do
      let(:year) { Date.today.year }
      subject(:biennium) { described_class.from(year) }

      context 'when there is no PPA::Plan registered for the given year' do
        it { is_expected.to eq nil }
      end

      context 'when there is a PPA::Plan including the given year' do
        subject(:biennium_years) { biennium.to_a }

        context 'starting at the given year' do
          let!(:plan) { create :ppa_plan, start_year: year }

          it 'returns the first biennium of the plan' do
            expect(biennium_years).to eq [plan.start_year, plan.start_year.next]
          end
        end

        context 'starting at the previous year from given year' do
          let!(:plan) { create :ppa_plan, start_year: year - 1 }

          it 'returns the first biennium of the plan' do
            expect(biennium_years).to eq [plan.start_year, plan.start_year.next]
          end
        end

        context 'ending at the given year' do
          let!(:plan) { create :ppa_plan, start_year: (year - 3), end_year: year }

          it 'returns the second biennium of the plan' do
            expect(biennium_years).to eq [plan.end_year - 1, plan.end_year]
          end
        end

        context 'ending at the next year from the given year' do
          let!(:plan) { create :ppa_plan, start_year: (year - 2), end_year: (year + 1) }

          it 'returns the second biennium of the plan' do
            expect(biennium_years).to eq [plan.end_year - 1, plan.end_year]
          end
        end
      end
    end

  end # initializing



  describe '#plan' do
    before do
      allow(PPA::Plan).to receive(:find_by_biennium).and_call_original
      biennium.plan
    end

    it { expect(PPA::Plan).to have_received(:find_by_biennium).with(biennium) }
  end

  describe '#to_a' do
    it { expect(biennium.to_a).to eq [2016, 2017] }
  end

  describe '#to_s' do
    it { expect(biennium.to_s).to eq '2016-2017' }
  end

  describe '==' do
    subject { biennium == other}

    context 'when the other Biennium has the same year values' do
      let(:other) { PPA::Biennium.new biennium.years }

      it { is_expected.to eq true }
    end

    context 'when the other Biennium has different year values' do
      let(:other) do
        years_ahead = biennium.years.map { |i| i + 1 } # movind 1 year forward
        PPA::Biennium.new years_ahead
      end

      it { is_expected.to eq false }
    end
  end

end
