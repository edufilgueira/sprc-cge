require 'rails_helper'

describe Reports::Tickets::Report::Sou::SubDepartmentService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) do
    ticket_report.filtered_scope.without_other_organs
      .without_internal_status(Ticket::INVALIDATED_STATUSES)
  end
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::SubDepartmentPresenter.new(default_scope, ticket_report) }

  subject(:service) { Reports::Tickets::Report::Sou::SubDepartmentService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sou::SubDepartmentService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sou::SubDepartmentService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sou::SubDepartmentService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:department_1) { create(:department) }
      let(:department_1_sub_department_1) { create(:sub_department, department: department_1) }
      let(:department_1_sub_department_2) { create(:sub_department, department: department_1) }

      let(:department_2) { create(:department) }
      let(:department_2_sub_department_1) { create(:sub_department, department: department_2) }
      let(:department_2_sub_department_2) { create(:sub_department, department: department_2) }

      let(:ticket_department_1) { create(:classification, department: department_1, sub_department: department_1_sub_department_1).ticket }
      let(:ticket_department_2) { create(:classification, department: department_2, sub_department: department_2_sub_department_2).ticket }

      let(:scope) do
        default_scope
      end

      before do
        department_1_sub_department_1
        department_1_sub_department_2
        department_2_sub_department_1
        department_2_sub_department_2

        create(:ticket, :confirmed, :sic)
        create(:ticket, :invalidated)
        create(:classification, :other_organs).ticket
        create(:ticket, :confirmed, :with_parent, organ: organ_dpge)

        allow(Reports::Tickets::SubDepartmentPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::SubDepartmentPresenter).to have_received(:new).with(scope, ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sou.sub_department.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        headers = Reports::Tickets::SubDepartmentPresenter::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.sou.sub_department.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, headers)

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
