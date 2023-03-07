require 'rails_helper'

describe Reports::Tickets::GrossExport::SicService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:gross_export) { create(:gross_export, :all_columns, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date} }) }
  let(:default_scope) { gross_export.filtered_scope }

  let(:presenter) { Reports::Tickets::GrossExport::SicPresenter.new(default_scope, gross_export.id) }
  subject(:service) { Reports::Tickets::GrossExport::SicService.new(xls_workbook, gross_export) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::GrossExport::SicService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::GrossExport::SicService.call(xls_workbook, gross_export)

      expect(Reports::Tickets::GrossExport::SicService).to have_received(:new).with(xls_workbook, gross_export)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:ticket_child) { create(:ticket, :sic, :with_parent_sic) }
      let(:ticket_parent_no_children) { create(:ticket, :sic, :confirmed) }

      let(:scope) { gross_export.filtered_scope }

      before do
        scope
        create(:ticket, :confirmed)

        allow(Reports::Tickets::GrossExport::SicPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::GrossExport::SicPresenter).to have_received(:new).with(scope, gross_export.id) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.gross_export.sic.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = I18n.t("services.reports.tickets.gross_export.sic.title")

        headers = Reports::Tickets::GrossExport::SicPresenter::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.gross_export.sic.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)
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
