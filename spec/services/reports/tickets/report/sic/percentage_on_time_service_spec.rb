require 'rails_helper'

describe Reports::Tickets::Report::Sic::PercentageOnTimeService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:confirmed_at_params) { { start: beginning_date, end: end_date } }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date} }) }

  let(:default_scope) { ticket_report.filtered_scope }
  let(:report_scope) do
    scope = default_scope.left_joins(parent: :attendance)
    scope.where(attendances: { id: nil}).or(scope.where(attendances: { service_type: :sic_forward }))
  end

  let!(:attendance_sic_completed) do
    ticket_immediate_answer = create(:ticket, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::Sic::PercentageOnTimePresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::PercentageOnTimeService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::PercentageOnTimeService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::PercentageOnTimeService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::PercentageOnTimeService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do
    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :with_parent) }
      let!(:ticket_parent_no_children) { create(:ticket, :confirmed) }
      let!(:ticket_invalidated) { create(:ticket, :invalidated) }
      let!(:ticket_other_organs) do
        ticket = create(:ticket, :confirmed)
        create(:classification, :other_organs, ticket: ticket)
        ticket
      end

      let(:scope) { default_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

      before do
        scope
        create(:ticket, :confirmed, :sic)

        allow(Reports::Tickets::Sic::PercentageOnTimePresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sic::PercentageOnTimePresenter).to have_received(:new).with(match_array(scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.percentage_on_time.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sic.percentage_on_time.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        expect(service).to receive(:xls_add_row).with(anything, [presenter.total_count_str, presenter.total_count])
        expect(service).to receive(:xls_add_row).with(anything, [presenter.total_completed_count_str, presenter.total_completed_count])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.all_on_time_str, presenter.all_on_time ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.call_center_on_time_str, presenter.call_center_on_time ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.csai_on_time_str, presenter.csai_on_time ])

        service.call
      end

    end
  end
end
