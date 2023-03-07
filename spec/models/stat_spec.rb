require 'rails_helper'

describe Stat do
  subject(:stat) { create(:stat) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  describe 'db' do
    # @SPRC-DATA tested
  end

  describe 'validations' do

    describe 'presence' do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:month) }
      it { is_expected.to validate_presence_of(:year) }
    end

    describe 'uniqueness' do
      it 'month_end blank' do
        stat = create(:stat, month_end: nil)

        is_expected.to validate_uniqueness_of(:month).scoped_to([:year, :type])
      end

      it { is_expected.to validate_uniqueness_of(:month_end).scoped_to([:year, :type, :month_start]) }
    end

    describe 'inclusion' do
      it { is_expected.to validate_inclusion_of(:month_end).in_range(stat.month_start..12) }
    end
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    # it { is_expected.to serialize(:data) }
    #
    it { expect(stat.data).to be_a Hash }
  end

  describe 'helpers' do
    describe 'sorted last_stat' do
      it 'contracts' do
        contract_stat_2 = create(:stats_contracts_contract, year: 2019, month: 1, month_start: nil, month_end: nil)
        contract_stat_1 = create(:stats_contracts_contract, year: 2018, month: 2, month_start: nil, month_end: nil)
        contract_stat_0 = create(:stats_contracts_contract, year: 2017, month: 3, month_start: nil, month_end: nil)
        contract_stat_3 = create(:stats_contracts_contract, year: 2019, month: 2, month_start: nil, month_end: nil)

        expected_sorted = [contract_stat_0, contract_stat_1, contract_stat_2, contract_stat_3]
        expected_last = contract_stat_3

        expect(Stats::Contracts::Contract.sorted).to eq(expected_sorted)
        expect(Stats::Contracts::Contract.last).to eq(expected_last)
      end

      it 'expenses' do
        expense_stat_2 = create(:stats_expenses_budget_balance, year: 2019, month: 6, month_start: 3, month_end: 12)
        expense_stat_1 = create(:stats_expenses_budget_balance, year: 2018, month: 6, month_start: 1, month_end: 12)
        expense_stat_0 = create(:stats_expenses_budget_balance, year: 2017, month: 12, month_start: 6, month_end: 6)
        expense_stat_3 = create(:stats_expenses_budget_balance, year: 2019, month: 0, month_start: 1, month_end: 4)

        expected_sorted = [expense_stat_0, expense_stat_1, expense_stat_2, expense_stat_3]
        expected_last = expense_stat_3

        expect(Stats::Expenses::BudgetBalance.sorted).to eq(expected_sorted)
        expect(Stats::Expenses::BudgetBalance.last).to eq(expected_last)
      end
    end
  end
end
