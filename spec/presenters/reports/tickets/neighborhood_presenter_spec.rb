require 'rails_helper'

describe Reports::Tickets::NeighborhoodPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::NeighborhoodPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::NeighborhoodPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::NeighborhoodPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    context 'rows' do
      let(:neighborhood) { "Bairro 1" }

      let(:row_1) do
        [
          I18n.t("services.reports.tickets.sou.neighborhood.empty"),
          1,
          number_to_percentage(25, precision: 2)
        ]
      end

      let(:row_2) do
        [
          neighborhood,
          3,
          number_to_percentage(75, precision: 2)
        ]
      end

      let(:expected) { [row_1, row_2] }

      before do
        create(:ticket, :with_parent, target_address_neighborhood: neighborhood)
        create(:ticket, :with_parent)
        reopened = create(:ticket, :with_reopen_and_log, target_address_neighborhood: neighborhood)
      end

      it { expect(presenter.rows).to match_array(expected) }
      it { expect(presenter.total_count).to eq(4) }
    end
  end
end
