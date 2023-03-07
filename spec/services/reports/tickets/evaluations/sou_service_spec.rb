require 'rails_helper'

describe Reports::Tickets::Evaluations::SouService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:evaluation_export) { create(:evaluation_export, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}}) }

  let(:default_scope) { evaluation_export.filtered_scope }

  let(:presenter) { Reports::Tickets::Evaluations::SouPresenter.new(default_scope) }
  subject(:service) { Reports::Tickets::Evaluations::SouService.new(xls_workbook, evaluation_export.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Evaluations::SouService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Evaluations::SouService.call(xls_workbook, evaluation_export.id)

      expect(Reports::Tickets::Evaluations::SouService).to have_received(:new).with(xls_workbook, evaluation_export.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:evaluation) { create(:evaluation) }

      let(:scope) { evaluation_export.filtered_scope }

      before do
        scope

        create(:evaluation, :sic)

        allow(Reports::Tickets::Evaluations::SouPresenter).to receive(:new).and_call_original

        service.call
      end

      it { expect(Reports::Tickets::Evaluations::SouPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.evaluations.sou.sheet_name").slice(0, 25)

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
        create(:evaluation)

        allow(service).to receive(:xls_add_row)
        service.call

       presenter.rows.each do |row|
          expect(service).to have_received(:xls_add_row).with(anything, row)
        end
      end
    end
  end
end
