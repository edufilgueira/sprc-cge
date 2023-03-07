require 'rails_helper'

describe Reports::Tickets::Solvability::SouService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:solvability_report) { create(:solvability_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { solvability_report.filtered_scope }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::SolvabilityPresenter.new(default_scope, solvability_report) }
  subject(:service) { Reports::Tickets::Solvability::SouService.new(xls_workbook, solvability_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Solvability::SouService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Solvability::SouService.call(xls_workbook, solvability_report)

      expect(Reports::Tickets::Solvability::SouService).to have_received(:new).with(xls_workbook, solvability_report)
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

      let(:scope) { solvability_report.filtered_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

      before do
        scope
        create(:ticket, :confirmed, :with_parent)

        allow(Reports::Tickets::SolvabilityPresenter).to receive(:new).and_call_original

        service.call
      end

      it { expect(Reports::Tickets::SolvabilityPresenter).to have_received(:new).with(scope, solvability_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.solvability.sou.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        headers = presenter.class::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.solvability.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)

        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      it 'title' do
        title = I18n.t("services.reports.tickets.solvability.title", begin: I18n.l(beginning_date), end: I18n.l(end_date))

        allow(service).to receive(:xls_add_header)

        expect(service).to receive(:xls_add_header).with(anything, [title])

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
