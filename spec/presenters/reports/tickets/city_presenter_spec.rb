require 'rails_helper'

describe Reports::Tickets::CityPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::CityPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::CityPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::CityPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    context 'rows' do
      let(:city) { create(:city) }

      before do
        create(:ticket, :with_parent, city: city )
        create(:ticket, :with_parent)
        create(:ticket, :with_reopen_and_log, city: city)
      end

      it {expect(presenter.rows.count).to eq(2)}
      
      it { expect(presenter.total_count).to eq(4) }
    end
  end
end
