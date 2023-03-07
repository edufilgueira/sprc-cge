require 'rails_helper'

describe Event do
  it_behaves_like 'models/timestamp'

  subject(:event) { build(:event) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:event, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:starts_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:category).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'scopes' do
    context 'sorted' do
      it 'sorted' do
        expected = Event.order('events.title ASC').to_sql.downcase
        result = Event.sorted.to_sql.downcase
        expect(result).to eq(expected)
      end
    end

    describe 'upcoming' do
      let!(:tomorrow_event) { create(:event, starts_at: Date.tomorrow) }
      let!(:old_event) { create(:event, starts_at: Date.yesterday) }
      let!(:today_event) { create(:event, starts_at: Date.today) }

      it { expect(Event.upcoming).to eq [today_event, tomorrow_event] }
    end
  end
end
