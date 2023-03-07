require 'rails_helper'

describe Reports::Tickets::Report::Sic::GenderService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:default_scope) { ticket_report.filtered_scope }
  let(:report_scope) do
    scope = default_scope.left_joins(parent: :attendance)
    scope.where(attendances: { id: nil}).or(scope.where(attendances: { service_type: :sic_forward }))
  end

  let!(:attendance_sic_completed) do
    ticket_immediate_answer = create(:ticket, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::Sic::GenderPresenter.new(report_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::GenderService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::GenderService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::GenderService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::GenderService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :sic, :with_parent) }
      let!(:ticket_parent_no_children) { create(:ticket, :sic, :confirmed) }

      let(:scope) { report_scope }

      before do
        scope

        create(:ticket, :invalidated)
        create(:classification, :other_organs).ticket
        create(:ticket, :confirmed, :with_parent, organ: organ_dpge)

        allow(Reports::Tickets::Sic::GenderPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sic::GenderPresenter).to have_received(:new).with(match_array(scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.gender.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        headers = Reports::Tickets::Sic::GenderPresenter::COLUMNS.map do |column|
          I18n.t("services.reports.tickets.sic.gender.headers.#{column}")
        end

        allow(service).to receive(:xls_add_header)

        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        keys = Ticket.genders.keys + [nil]

        keys.each do |gender|
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.gender_str(gender), presenter.gender_count(gender), presenter.gender_percentage(gender)])
        end

        service.call
      end
    end
  end
end
