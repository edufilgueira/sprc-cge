require 'rails_helper'

describe Reports::Tickets::Sic::GenderPresenter do

  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sic::GenderPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::GenderPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::GenderPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed, gender: :male)
      create(:ticket, :confirmed, gender: :female)
      create(:ticket, :confirmed, gender: :other_gender)
      create(:ticket, :confirmed, gender: :not_informed_gender)
      create(:ticket, :confirmed, gender: '')
      create(:ticket, :confirmed, gender: '')
    end

    it { expect(presenter.gender_str(:male)).to eq(I18n.t("ticket.genders.male")) }
    it { expect(presenter.gender_str(:female)).to eq(I18n.t("ticket.genders.female")) }
    it { expect(presenter.gender_str(:other_gender)).to eq(I18n.t("ticket.genders.other_gender")) }
    it { expect(presenter.gender_str(:not_informed_gender)).to eq(I18n.t("ticket.genders.not_informed_gender")) }
    it { expect(presenter.gender_str(nil)).to eq(I18n.t("ticket.genders.empty")) }
    it { expect(presenter.gender_count(:male)).to eq(1) }
    it { expect(presenter.gender_count(:female)).to eq(1) }
    it { expect(presenter.gender_count(:other_gender)).to eq(1) }
    it { expect(presenter.gender_count(:not_informed_gender)).to eq(1) }
    it { expect(presenter.gender_count(nil)).to eq(2) }
    it { expect(presenter.gender_percentage(:male)).to eq(16.67) }
    it { expect(presenter.gender_percentage(:female)).to eq(16.67) }
    it { expect(presenter.gender_percentage(:other_gender)).to eq(16.67) }
    it { expect(presenter.gender_percentage(:not_informed_gender)).to eq(16.67) }
    it { expect(presenter.gender_percentage(nil)).to eq(33.33) }
  end
end
