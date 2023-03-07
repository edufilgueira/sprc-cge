require 'rails_helper'

describe Schedule do

  subject(:schedule) { build(:schedule) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cron_syntax_frequency).of_type(:string) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do

    context 'allowed' do
      it { is_expected.to allow_value("").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("* * * * *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("0 0 1 1 *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("0 0 1 * *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("0 0 * * 0").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("0 0 * * *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("0 * * * *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("59 * * * *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("* 23 * * *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("* * 31 * *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("* * * 12 *").for(:cron_syntax_frequency) }
      it { is_expected.to allow_value("* * * * 6").for(:cron_syntax_frequency) }
    end

    context 'denied' do
      it { is_expected.to_not allow_value("60 * * * *").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("* 24 * * *").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("* * 32 * *").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("* * * 13 *").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("* * * * 7").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("a * * * *").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("* * * * * *").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("*****").for(:cron_syntax_frequency) }
      it { is_expected.to_not allow_value("bla").for(:cron_syntax_frequency) }
    end

  end

  describe 'associations' do
    it { is_expected.to belong_to(:scheduleable) }
  end

end
