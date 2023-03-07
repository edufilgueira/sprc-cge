require 'rails_helper'

describe Reports::Tickets::Report::Sic::AverageAnswerSubDepartmentService do

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

  let(:presenter) { Reports::Tickets::AverageAnswerSubDepartmentPresenter.new(report_scope) }
  subject(:service) { Reports::Tickets::Report::Sic::AverageAnswerSubDepartmentService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::AverageAnswerSubDepartmentService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::AverageAnswerSubDepartmentService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::AverageAnswerSubDepartmentService).to have_received(:new).with(xls_workbook, ticket_report)
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

        allow(Reports::Tickets::AverageAnswerSubDepartmentPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::AverageAnswerSubDepartmentPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.average_answer_sub_department.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        headers = Reports::Tickets::AverageAnswerSubDepartmentPresenter::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.sic.average_answer_sub_department.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      it 'rows' do

        ticket = create(:ticket, :sic, :confirmed)

        ticket_department = create(:ticket_department, answer: :answered, ticket: ticket)
        department = ticket_department.department
        sub_department = create(:sub_department, department: department)
        create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department)
        answer_department = create(:answer, :positioning, ticket: ticket)

        ticket_department2 = create(:ticket_department, answer: :answered, ticket: ticket)
        department2 = ticket_department2.department
        sub_department2 = create(:sub_department, department: department2)
        create(:ticket_department_sub_department, ticket_department: ticket_department2, sub_department: sub_department2)
        answer_department2 = create(:answer, :positioning, ticket: ticket)

        td_not_in_scope = create(:ticket_department, answer: :not_answered, ticket: ticket)
        department_not_in_scope = td_not_in_scope.department
        sub_department_not_in_scope = create(:sub_department, department: department_not_in_scope)
        create(:ticket_department_sub_department, ticket_department: td_not_in_scope, sub_department: sub_department_not_in_scope)

        allow(service).to receive(:xls_add_row)

        expect(service).to receive(:xls_add_row).with(anything, [
          sub_department.department_organ_acronym,
          sub_department.title,
          presenter.average_time(sub_department),
          presenter.amount_count(sub_department)
        ])

        expect(service).to receive(:xls_add_row).with(anything, [
          sub_department2.department_organ_acronym,
          sub_department2.title,
          presenter.average_time(sub_department2),
          presenter.amount_count(sub_department2)
        ])

        expect(service).not_to receive(:xls_add_row).with(anything, [
          sub_department_not_in_scope.department_organ_acronym,
          sub_department_not_in_scope.title,
          presenter.average_time(sub_department_not_in_scope),
          presenter.amount_count(sub_department_not_in_scope)
        ])

        service.call
      end
    end
  end
end
