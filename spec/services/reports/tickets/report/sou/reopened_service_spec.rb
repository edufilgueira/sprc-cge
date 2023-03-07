require 'rails_helper'

describe Reports::Tickets::Report::Sou::ReopenedService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }
  let(:date_range) { beginning_date..end_date }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }
  let(:default_scope) do
    ticket_report.filtered_scope.without_other_organs.leaf_tickets
      .without_internal_status(Ticket::INVALIDATED_STATUSES)
      .joins(:ticket_logs).where(ticket_logs: {
        created_at: date_range,
        action: TicketLog.actions[:reopen] })
  end


  let(:presenter) { Reports::Tickets::Sou::ReopenedPresenter.new(default_scope) }

  subject(:service) { Reports::Tickets::Report::Sou::ReopenedService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sou::ReopenedService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sou::ReopenedService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sou::ReopenedService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:ticket_child) do
        ticket = create(:ticket, :with_parent)
        create(:ticket_log, :reopened, ticket: ticket)
        ticket
      end
      let(:ticket_parent_no_children) do
        ticket = create(:ticket, :confirmed)
        create(:ticket_log, :reopened, ticket: ticket)
        ticket
      end

      let(:ticket_old) do
        ticket = create(:ticket, :confirmed, confirmed_at: 1.year.ago)
        create(:ticket_log, :reopened, ticket: ticket)
        ticket
      end

      let(:scope) do
        ticket_report.filtered_scope.without_other_organs.leaf_tickets
          .without_internal_status(Ticket::INVALIDATED_STATUSES)
      end

      before do
        scope

        create(:ticket, :confirmed, :sic)
        create(:ticket, :invalidated)
        create(:classification, :other_organs).ticket
        create(:ticket, :confirmed, :with_parent, organ: organ_dpge)

        allow(Reports::Tickets::Sou::ReopenedPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sou::ReopenedPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sou.reopened.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        headers = presenter.class::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.sou.reopened.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        presenter.rows(date_range).each do |row|
          expect(service).to receive(:xls_add_row).with(anything, row)
        end

        service.call
      end
    end
  end
end
