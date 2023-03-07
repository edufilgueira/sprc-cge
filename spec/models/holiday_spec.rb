require 'rails_helper'

describe Holiday do
  it_behaves_like 'models/paranoia'

  subject(:holiday) { build(:holiday) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:holiday, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:day).of_type(:integer) }
      it { is_expected.to have_db_column(:month).of_type(:integer) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index([:day, :month]) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:day) }
    it { is_expected.to validate_presence_of(:month) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_numericality_of(:month).is_less_than(13) }
    it { is_expected.to validate_numericality_of(:month).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:day).is_less_than(32) }
    it { is_expected.to validate_numericality_of(:day).is_greater_than(0) }
  end

  describe 'scope' do
    it 'sorted' do
      expected = Holiday.order('holidays.month ASC').to_sql.downcase
      result = Holiday.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end
  end

  describe 'helpers' do
    it 'month_str' do
      expected = I18n.t('date.month_names')[holiday.month]

      expect(holiday.month_str).to eq(expected)
    end

    context 'self.next_weekday' do
      it 'default date' do
        saturday = Date.today.next_week.next_day(5)
        days_to_saturday = (saturday - Date.today).to_i

        monday = saturday.next_day(2)
        tuesday = monday.next_day(1)
        days_to_tuesday = (tuesday - Date.today).to_i

        create(:holiday, month: monday.month, day: monday.day)

        expect(Holiday.next_weekday(days_to_saturday)).to eq(days_to_tuesday)
      end
      it 'any date' do
        date = Date.today + 1.month
        saturday = date.next_week.next_day(5)
        days_to_saturday = (saturday - date).to_i

        monday = saturday.next_day(2)
        tuesday = monday.next_day(1)
        days_to_tuesday = (tuesday - date).to_i

        create(:holiday, month: monday.month, day: monday.day)

        expect(Holiday.next_weekday(days_to_saturday, date)).to eq(days_to_tuesday)
      end

      it 'when date is ActiveSupport::TimeWithZone' do
        days_count = 2
        yesterday_time_with_zone = 1.day.ago

        next_weekday = Date.tomorrow
        next_weekday += 1.day until next_weekday.on_weekday?

        expected = (next_weekday - Date.yesterday).to_i

        expect(Holiday.next_weekday(days_count, yesterday_time_with_zone)).to eq(expected)
      end
    end
  end


end
