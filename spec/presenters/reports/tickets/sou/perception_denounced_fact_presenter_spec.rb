require 'rails_helper'

describe Reports::Tickets::Sou::PerceptionDenouncedFactPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::PerceptionDenouncedFactPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::PerceptionDenouncedFactPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::PerceptionDenouncedFactPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed, denunciation_assurance: :assured)
      create(:ticket, :confirmed, denunciation_assurance: :assured)
      create(:ticket, :confirmed, :with_reopen_and_log, reopened_count: 2, denunciation_assurance: :suspicion)
    end

    it { expect(presenter.denunciation_assurance_count(:assured)).to eq(2) }
    it { expect(presenter.denunciation_assurance_count(:suspicion)).to eq(1) }
    it { expect(presenter.denunciation_assurance_str(:assured)).to eq(Ticket.human_attribute_name("denunciation_assurance.assured")) }
    it { expect(presenter.denunciation_assurance_percentage(:assured)).to eq('66,67%') }
    it { expect(presenter.denunciation_assurance_percentage(:rumor)).to eq('0,00%') }
    it { expect(presenter.total_count).to eq(3) }
  end
end
