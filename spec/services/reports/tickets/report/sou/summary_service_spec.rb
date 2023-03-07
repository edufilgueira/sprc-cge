require 'rails_helper'

describe Reports::Tickets::Report::Sou::SummaryService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  before { 
    create(:topic, :no_characteristic)
  }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { ticket_report.filtered_scope }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::Sou::SummaryPresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sou::SummaryService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sou::SummaryService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sou::SummaryService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sou::SummaryService).to have_received(:new).with(xls_workbook, ticket_report)
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


      let(:scope) { ticket_report.filtered_scope.without_characteristic }

      before do
        scope
        create(:ticket, :confirmed, :with_parent)

        allow(Reports::Tickets::Sou::SummaryPresenter).to receive(:new).and_call_original

        service.call
      end

      it { expect(Reports::Tickets::Sou::SummaryPresenter).to have_received(:new).with(scope, ticket_report) }
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
        title = [ I18n.t("services.reports.tickets.sou.summary.title", begin: date.beginning_of_month.to_date, end: date.end_of_month) ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        expect(service).to receive(:xls_add_row).with(anything, [ presenter.relevant_to_executive_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.invalidated_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.other_organs_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.anonymous_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.total_count_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.average_time_answer_str ])
        expect(service).to receive(:xls_add_row).with(anything, [ presenter.reopened_count_str ])

        service.call
      end

    end
  end
end
