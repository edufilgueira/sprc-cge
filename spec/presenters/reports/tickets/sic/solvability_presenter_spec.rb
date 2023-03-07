require 'rails_helper'

describe Reports::Tickets::Sic::SolvabilityPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope.without_other_organs }

  subject(:presenter) { Reports::Tickets::Sic::SolvabilityPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::SolvabilityPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::SolvabilityPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    let(:organ) { create(:executive_organ) }

    before do

      create(:ticket, :with_parent_sic, :replied, organ: organ)

      ticket = create(:ticket, :sic, :with_parent_sic, organ: organ)
      ticket.cge_validation!

      create(:ticket, :sic, :with_parent_sic, organ: organ, deadline: -1)
    end

    it 'organs_solvability' do
      expected = [[organ.acronym, 50.00, 3]]

      expect(presenter.organs_solvability).to eq(expected)
    end

    it  'total_unscoped_count' do
      expect(presenter.total_unscoped_count).to eq(3)
    end


  end
end
