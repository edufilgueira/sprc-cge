require 'rails_helper'

describe Reports::Tickets::Report::Sic::BudgetProgramService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { ticket_report.filtered_scope }
  let(:report_scope) do
    scope = default_scope.left_joins(parent: :attendance)
    scope.where(attendances: { id: nil}).or(scope.where(attendances: { service_type: :sic_forward }))
  end

  let!(:attendance_sic_completed) do
    ticket_immediate_answer = create(:ticket, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::BudgetProgramPresenter.new(report_scope, ticket_report) }

  subject(:service) { Reports::Tickets::Report::Sic::BudgetProgramService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::BudgetProgramService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::BudgetProgramService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::BudgetProgramService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :sic, :with_parent_sic) }
      let!(:ticket_parent_no_children) { create(:ticket, :confirmed, :sic) }

      before do
        create(:ticket, :confirmed)

        # fora do range de data
        create(:ticket, :sic, :confirmed, confirmed_at: 31.days.ago)

        allow(Reports::Tickets::BudgetProgramPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::BudgetProgramPresenter).to have_received(:new).with(match_array(report_scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.budget_program.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      context 'header' do
        context 'when cge operator' do
          it 'include organ' do
            headers = Reports::Tickets::BudgetProgramPresenter::COLUMNS.map do |column|
              I18n.t("services.reports.tickets.sic.budget_program.headers.#{column}")
            end

            allow(service).to receive(:xls_add_header)
            expect(service).to receive(:xls_add_header).with(anything, headers)

            service.call
          end
        end
        context 'when sectoral operator' do
          let(:ticket_report) { create(:ticket_report, :sectoral) }
          it 'exclude organ' do
            columns = Reports::Tickets::BudgetProgramPresenter::COLUMNS - [:organ]
            headers = columns.map do |column|
              I18n.t("services.reports.tickets.sic.budget_program.headers.#{column}")
            end

            allow(service).to receive(:xls_add_header)
            expect(service).to receive(:xls_add_header).with(anything, headers)

            service.call
          end
        end
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
