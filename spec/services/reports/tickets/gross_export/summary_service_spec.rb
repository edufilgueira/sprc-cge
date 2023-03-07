require 'rails_helper'

describe Reports::Tickets::GrossExport::SummaryService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:gross_export) { create(:gross_export, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { gross_export.filtered_scope }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::GrossExport::SummaryPresenter.new(default_scope, gross_export) }
  subject(:service) { Reports::Tickets::GrossExport::SummaryService.new(xls_workbook, gross_export) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::GrossExport::SummaryService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::GrossExport::SummaryService.call(xls_workbook, gross_export)

      expect(Reports::Tickets::GrossExport::SummaryService).to have_received(:new).with(xls_workbook, gross_export)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do
    context 'invokes presenter with scope' do
      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:ticket_parent_no_children) { create(:ticket, :confirmed) }
      let(:ticket_invalidated) { create(:ticket, :invalidated) }
      let(:ticket_dpge) { create(:ticket, :confirmed, :with_parent, organ: organ_dpge) }
      let(:ticket_other_organs) do
        ticket = create(:ticket, :confirmed)
        create(:classification, :other_organs, ticket: ticket)
        ticket
      end


      let(:scope) { gross_export.filtered_scope }

      before do
        scope
        create(:ticket, :confirmed, :with_parent)

        allow(Reports::Tickets::GrossExport::SummaryPresenter).to receive(:new).and_call_original

        service.call
      end

      it { expect(Reports::Tickets::GrossExport::SummaryPresenter).to have_received(:new).with(scope, gross_export) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.gross_export.summary.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.gross_export.summary.title", begin: date.beginning_of_month.to_date, end: date.end_of_month.end_of_day) ]

        allow(service).to receive(:xls_add_header)

        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        expect(service).to receive(:xls_add_row).with(anything, [ presenter.name_report ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.created_by ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.created_at ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.creator_email ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.operator_type ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.tickets_count ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.tickets_invalidate_count ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.tickets_other_organs_count ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.tickets_reopened_count ])

        service.call
      end

    end
  end
end
