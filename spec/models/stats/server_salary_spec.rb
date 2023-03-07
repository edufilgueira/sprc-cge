require 'rails_helper'

describe Stats::ServerSalary do

  subject(:stats_server_salary) { create(:stats_server_salary) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:month).of_type(:integer) }
      it { is_expected.to have_db_column(:year).of_type(:integer) }
      it { is_expected.to have_db_column(:data).of_type(:text) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:month) }
    it { is_expected.to validate_presence_of(:year) }
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    # it { is_expected.to serialize(:data) }
    #
    it { expect(stats_server_salary.data).to be_a Hash }
  end

  describe 'helpers' do
    describe 'sorted last_stat' do
      it 'servers' do
        server_stat_2 = create(:stats_server_salary, year: 2019, month: 1)
        server_stat_1 = create(:stats_server_salary, year: 2018, month: 2)
        server_stat_0 = create(:stats_server_salary, year: 2017, month: 3)
        server_stat_3 = create(:stats_server_salary, year: 2019, month: 2)

        expected_sorted = [server_stat_0, server_stat_1, server_stat_2, server_stat_3]
        expected_last = server_stat_3

        expect(Stats::ServerSalary.sorted).to eq(expected_sorted)
        expect(Stats::ServerSalary.last).to eq(expected_last)
      end
    end
  end
end
