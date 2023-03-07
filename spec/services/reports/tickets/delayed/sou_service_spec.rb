require 'rails_helper'

describe Reports::Tickets::Delayed::SouService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:default_scope) { Ticket.sou.left_joins(:tickets).where(confirmed_at: beginning_date..end_date, tickets_tickets: { id: nil }) }

  let(:presenter) { Reports::Tickets::Delayed::SouPresenter.new(default_scope) }
  subject(:service) { Reports::Tickets::Delayed::SouService.new(xls_workbook, beginning_date, end_date) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Delayed::SouService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Delayed::SouService.call(xls_workbook, beginning_date, end_date)

      expect(Reports::Tickets::Delayed::SouService).to have_received(:new).with(xls_workbook, beginning_date, end_date)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:ticket_child) { create(:ticket, :with_parent, :expired_can_extend) }
      let(:ticket_parent_no_children) { create(:ticket, :confirmed, :expired_can_extend) }

      let(:scope) { [ticket_child, ticket_parent_no_children] }

      before do
        scope
        create(:ticket, :sic, :confirmed)
        create(:ticket, :confirmed)
        create(:ticket, :replied, :expired_can_extend)

        allow(Reports::Tickets::Delayed::SouPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Delayed::SouPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.delayed.sou.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = I18n.t("services.reports.tickets.delayed.sou.title", begin: date.beginning_of_month, end: date.end_of_month)

        headers = Reports::Tickets::Delayed::SouPresenter::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.delayed.sou.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, [title])
        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        presenter.rows.each do |row|
          expect(service).to receive(:xls_add_row).with(anything, row)
        end

        service.call
      end
    end
  end
end
