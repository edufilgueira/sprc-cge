require 'rails_helper'

describe Reports::Tickets::Evaluations::SicService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:evaluation_export) { create(:evaluation_export, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}}) }

  let(:default_scope) { evaluation_export.filtered_scope }

  let(:rejected_service_types) { Attendance.service_types.symbolize_keys.except(:sic_forward, :sic_completed) }

  let(:presenter) { Reports::Tickets::Evaluations::SicPresenter.new(default_scope) }
  subject(:service) { Reports::Tickets::Evaluations::SicService.new(xls_workbook, evaluation_export.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Evaluations::SicService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Evaluations::SicService.call(xls_workbook, evaluation_export.id)

      expect(Reports::Tickets::Evaluations::SicService).to have_received(:new).with(xls_workbook, evaluation_export.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:evaluation) { create(:evaluation, :sic) }

      let(:scope) { evaluation_export.filtered_scope }

      before do
        scope

        create(:evaluation)

        allow(Reports::Tickets::Evaluations::SicPresenter).to receive(:new).and_call_original

        service.call
      end

      it { expect(Reports::Tickets::Evaluations::SicPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.evaluations.sic.sheet_name").slice(0, 25)

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        headers = presenter.class::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.evaluations.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)

        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      it 'rows' do
        create(:evaluation, :sic)

        allow(service).to receive(:xls_add_row)
        service.call

       presenter.rows.each do |row|
          expect(service).to have_received(:xls_add_row).with(anything, row)
        end
      end
    end
  end
end
