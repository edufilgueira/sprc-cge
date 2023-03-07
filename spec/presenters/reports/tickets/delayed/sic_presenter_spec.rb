require 'rails_helper'

describe Reports::Tickets::Delayed::SicPresenter do

  let(:scope) { Ticket.sou.left_joins(:tickets) }

  subject(:presenter) { Reports::Tickets::Delayed::SicPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Delayed::SicPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Delayed::SicPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do

    context 'rows' do
      let(:ticket) { create(:ticket, :sic, :gross_export) }
      let(:scope) { [ ticket ] }

      let(:row) do
        [
          ticket.parent_protocol,
          ticket.organ_acronym,
          I18n.l(ticket.created_at, format: :date),
          nil,    # departments
          ticket.deadline
        ]
      end

      before { ticket }

      it { expect(presenter.rows).to match_array([row]) }

      context 'subnet' do
        let(:ticket) { create(:ticket, :sic, :gross_export, :with_subnet) }
        let(:subnet) { ticket.subnet }

        before { row[1] = subnet.full_acronym }

        it { expect(presenter.rows).to match_array([row]) }
      end
    end
  end
end
