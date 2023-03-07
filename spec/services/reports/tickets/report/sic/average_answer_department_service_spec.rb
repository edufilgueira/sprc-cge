require 'rails_helper'

describe Reports::Tickets::Report::Sic::AverageAnswerDepartmentService do

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
    ticket_immediate_answer = create(:ticket, :sic, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::AverageAnswerDepartmentPresenter.new(report_scope) }
  subject(:service) { Reports::Tickets::Report::Sic::AverageAnswerDepartmentService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::AverageAnswerDepartmentService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::AverageAnswerDepartmentService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::AverageAnswerDepartmentService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :with_parent_sic) }
      let!(:ticket_parent) { ticket_child.parent }
      let!(:ticket_parent_no_children) { create(:ticket, :sic, :confirmed) }

      let(:scope) { report_scope }

      before do
        scope
        create(:ticket, :confirmed)

        # fora do range de data
        create(:ticket, :sic, :confirmed, confirmed_at: 31.days.ago)
        create(:ticket_department, answer: :answered, ticket: ticket_parent_no_children)
        create(:answer, :positioning, ticket: ticket_parent_no_children)

        allow(Reports::Tickets::AverageAnswerDepartmentPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::AverageAnswerDepartmentPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.average_answer_department.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        headers = Reports::Tickets::AverageAnswerDepartmentPresenter::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.sic.average_answer_department.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      it 'rows' do

        ticket = create(:ticket, :sic, :confirmed)

        ticket_department = create(:ticket_department, answer: :answered, ticket: ticket)
        department = ticket_department.department
        answer_department = create(:answer, :positioning, ticket: ticket)

        ticket_department2 = create(:ticket_department, answer: :answered, ticket: ticket)
        department2 = ticket_department2.department
        answer_department2 = create(:answer, :positioning, ticket: ticket)

        td_not_in_scope = create(:ticket_department, answer: :not_answered, ticket: ticket)
        department_not_in_scope = td_not_in_scope.department

        allow(service).to receive(:xls_add_row)

        expect(service).to receive(:xls_add_row).with(anything, [
          department.organ_acronym,
          department.title,
          presenter.average_time(department),
          presenter.amount_count(department)
        ])

        expect(service).to receive(:xls_add_row).with(anything, [
          department2.organ_acronym,
          department2.title,
          presenter.average_time(department2),
          presenter.amount_count(department2)
        ])

        expect(service).not_to receive(:xls_add_row).with(anything, [
          department_not_in_scope.organ_acronym,
          department_not_in_scope.title,
          presenter.average_time(department_not_in_scope),
          presenter.amount_count(department_not_in_scope)
        ])

        service.call
      end
    end
  end
end
