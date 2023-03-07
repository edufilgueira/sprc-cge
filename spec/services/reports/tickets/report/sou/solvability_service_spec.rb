require 'rails_helper'

describe Reports::Tickets::Report::Sou::SolvabilityService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { ticket_report.filtered_scope }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::Sou::SolvabilityPresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sou::SolvabilityService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sou::SolvabilityService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sou::SolvabilityService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sou::SolvabilityService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    it 'invokes presenter with scope' do
      ticket = create(:ticket, :with_parent)

      scope = ticket_report.filtered_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES)

      create(:ticket, :confirmed, :with_parent, organ: organ_dpge)

      allow(Reports::Tickets::Sou::SolvabilityPresenter).to receive(:new).and_call_original

      service.call

      expect(Reports::Tickets::Sou::SolvabilityPresenter).to have_received(:new).with(scope, ticket_report)
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sou.solvability.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sou.solvability.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        create(:ticket, :with_parent)

        solubilities = [
          :final_answers_in_deadline,
          :final_answers_out_deadline,
          :attendance_in_deadline,
          :attendance_out_deadline
        ]

        solubilities.each do |solvability|
          total_solvability = presenter.solvability_count(solvability)
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.solvability_name(solvability), total_solvability, presenter.solvability_percentage(total_solvability) ])
        end

        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t("services.reports.tickets.sou.solvability.rows.total"), presenter.solvability_count(:total), presenter.resolubility ])

        service.call
      end
    end
  end
end
