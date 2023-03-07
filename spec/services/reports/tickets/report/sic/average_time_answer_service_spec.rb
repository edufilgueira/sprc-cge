require 'rails_helper'

describe Reports::Tickets::Report::Sic::AverageTimeAnswerService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }
  let(:confirmed_at_params) { { start: beginning_date, end: end_date } }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date} }) }

  let(:default_scope) { ticket_report.filtered_scope }

  let!(:attendance_sic_completed) do
    ticket_immediate_answer = create(:ticket, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::Sic::AverageTimeAnswerPresenter.new(default_scope) }
  subject(:service) { Reports::Tickets::Report::Sic::AverageTimeAnswerService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::AverageTimeAnswerService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::AverageTimeAnswerService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::AverageTimeAnswerService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :sic, :with_parent_sic) }
      let!(:ticket_parent) { ticket_child.parent }
      let!(:ticket_parent_no_children) { create(:ticket, :sic, :confirmed) }


      before do
        create(:ticket, :confirmed)

        # fora do range de data
        create(:ticket, :sic, :confirmed, confirmed_at: 31.days.ago)

        allow(Reports::Tickets::Sic::AverageTimeAnswerPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sic::AverageTimeAnswerPresenter).to have_received(:new).with(match_array(default_scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.average_time_answer.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sic.average_time_answer.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        rows = [
          :call_center_and_csai,
          :csai
        ]

        rows.each do |row|
          expect(service).to receive(:xls_add_row).with(anything, [
            presenter.average_type_str(row),
            presenter.average_time_str(row),
            presenter.amount_count(row)
          ])
        end

        service.call
      end
    end
  end
end
