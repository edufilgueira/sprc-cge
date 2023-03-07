require 'rails_helper'

describe Reports::Tickets::Sou::SouTypePresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::SouTypePresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::SouTypePresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::SouTypePresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed, sou_type: :complaint)
      create(:ticket, :confirmed, sou_type: :complaint)
      create(:ticket, :confirmed, :with_reopen_and_log, reopened_count: 2, sou_type: :suggestion)
    end

    it { expect(presenter.sou_type_count(:complaint)).to eq(2) }
    it { expect(presenter.sou_type_count(:suggestion)).to eq(3) }
    it { expect(presenter.sou_type_str(:complaint)).to eq(Ticket.human_attribute_name("sou_type.complaint")) }
    it { expect(presenter.sou_type_percentage(:complaint)).to eq('40,00%') }
    it { expect(presenter.sou_type_percentage(:denunciation)).to eq('0,00%') }
    it { expect(presenter.total_count).to eq(5) }
  end
end
