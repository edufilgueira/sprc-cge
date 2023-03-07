require 'rails_helper'

describe Reports::Tickets::Report::Sic::SummaryService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date} }) }
  let(:default_scope) { ticket_report.filtered_scope }

  let(:presenter) { Reports::Tickets::Sic::SummaryPresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::SummaryService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::SummaryService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::SummaryService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::SummaryService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do
    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :with_parent, :sic) }
      let!(:ticket_parent_no_children) { create(:ticket, :confirmed, :sic) }
      let!(:ticket_invalidated) { create(:ticket, :invalidated, :sic) }
      let!(:ticket_other_organs) do
        ticket = create(:ticket, :confirmed, :sic)
        create(:classification, :other_organs, ticket: ticket)
        ticket
      end

      let(:scope) { ticket_report.filtered_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

      before do
        scope
        create(:ticket, :confirmed, :sic)

        allow(Reports::Tickets::Sic::SummaryPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sic::SummaryPresenter).to have_received(:new).with(scope, ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sou.summary.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        date = DateTime.now

        title = [
          I18n.t("services.reports.tickets.sou.summary.title",
            begin: date.beginning_of_month.to_date,
            end: date.end_of_month)
        ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        expect(service).to receive(:xls_add_row).with(anything, [ presenter.relevant_to_executive_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.call_center_sic_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.call_center_forwarded_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.sic_without_attendance_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.call_center_finalized_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.finalized_without_call_center_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.reopened_count_str ])

        service.call
      end
    end
  end
end
