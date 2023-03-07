require 'rails_helper'

describe Reports::Tickets::Sou::GenderPresenter do

  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::GenderPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::GenderPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::GenderPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed, :with_reopen_and_log, reopened_count: 2, gender: :male)
      create(:ticket, :confirmed, gender: :female)
      create(:ticket, :confirmed, gender: '')
    end

    it { expect(presenter.gender_str(:male)).to eq(I18n.t("ticket.genders.male")) }
    it { expect(presenter.gender_str(:female)).to eq(I18n.t("ticket.genders.female")) }
    it { expect(presenter.gender_str(nil)).to eq(I18n.t("ticket.genders.empty")) }
    it { expect(presenter.gender_count(:male)).to eq(3) }
    it { expect(presenter.gender_count(:female)).to eq(1) }
    it { expect(presenter.gender_count(nil)).to eq(1) }
    it { expect(presenter.gender_percentage(:male)).to eq(60.00) }
    it { expect(presenter.gender_percentage(:female)).to eq(20.00) }
    it { expect(presenter.gender_percentage(nil)).to eq(20.00) }
  end
end
