require 'rails_helper'

describe Reports::Tickets::Report::Sic::AnswerPreferenceService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }
  let(:confirmed_at_params) { { start: beginning_date, end: end_date } }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date} }) }

  let(:default_scope) { ticket_report.filtered_scope }

  let(:presenter) { Reports::Tickets::Sic::AnswerPreferencePresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::AnswerPreferenceService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::AnswerPreferenceService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::AnswerPreferenceService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::AnswerPreferenceService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do
    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.answer_type.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sic.answer_type.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        rows = Ticket.answer_types.keys

        rows.each do |row|
          expect(service).to receive(:xls_add_row).with(anything, [
            presenter.answer_type_str(row),
            presenter.answer_type_count(row),
            presenter.answer_type_percentage(row)
          ])
        end

        service.call
      end
    end
  end
end
