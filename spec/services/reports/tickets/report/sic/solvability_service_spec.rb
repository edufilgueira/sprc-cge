require 'rails_helper'

describe Reports::Tickets::Report::Sic::SolvabilityService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date} }) }

  let(:default_scope) { ticket_report.filtered_scope }
  let(:report_scope) do
    scope = default_scope.left_joins(parent: :attendance)
    scope.where(attendances: { id: nil }).or(scope.where(attendances: { service_type: :sic_forward }))
  end

  let!(:attendance_sic_completed) do
    ticket_immediate_answer = create(:ticket, :sic, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::Sic::SolvabilityPresenter.new(report_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::SolvabilityService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::SolvabilityService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::SolvabilityService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::SolvabilityService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do
    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :with_parent_sic, :sic) }
      let!(:ticket_parent_no_children) { create(:ticket, :confirmed, :sic) }
      let!(:ticket_invalidated) { create(:ticket, :invalidated, :sic) }
      let!(:ticket_other_organs) do
        ticket = create(:ticket, :confirmed, :sic)
        create(:classification, :other_organs, ticket: ticket)
        ticket
      end

      let(:scope) { report_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

      before do
        create(:ticket, :confirmed, :sic)

        allow(Reports::Tickets::Sic::SolvabilityPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sic::SolvabilityPresenter).to have_received(:new).with(match_array(scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.solvability.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        date = DateTime.now

        title = [
          I18n.t("services.reports.tickets.sic.solvability.title",
            begin: date.beginning_of_month,
            end: date.end_of_month)
        ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        expected = [
          I18n.t("services.reports.tickets.sic.solvability.organ"),
          I18n.t("services.reports.tickets.sic.solvability.solvability"),
          I18n.t("services.reports.tickets.sic.solvability.total")
        ]

        expect(service).to receive(:xls_add_row).with(anything, expected)

        presenter.organs_solvability.each do |organ_solvability|
          expected = [
            organ_solvability[0],
            number_to_percentage(organ_solvability[1], precision: 2),
            organ_solvability[2]
          ]
          expect(service).to receive(:xls_add_row).with(anything, expected)
        end


        expect(service).to receive(:xls_add_row).with(anything, [I18n.t("services.reports.tickets.sic.solvability.total_unscoped"),"" ,presenter.total_unscoped_count])

        service.call
      end
    end
  end
end
