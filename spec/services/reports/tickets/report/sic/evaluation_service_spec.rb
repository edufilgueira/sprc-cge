require 'rails_helper'

describe Reports::Tickets::Report::Sic::EvaluationService do
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

  let(:scope) { Evaluation.joins(answer: [:ticket]).where(tickets: { id: default_scope.ids }) }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }

  let(:ticket) { create(:ticket, :with_parent_sic, confirmed_at: date) }

  let(:answer_1) { create(:answer, ticket: ticket) }
  let(:answer_2) { create(:answer, ticket: ticket) }
  let(:answer_3) { create(:answer, ticket: ticket) }

  let(:evaluation_1) { create(:evaluation, answer: answer_1, evaluation_type: :sic) }
  let(:evaluation_2) { create(:evaluation, answer: answer_2, evaluation_type: :sic) }
  let(:evaluation_3) { create(:evaluation, answer: answer_3, evaluation_type: :sic) }



  let(:presenter) { Reports::Tickets::EvaluationPresenter.new(scope) }
  subject(:service) { Reports::Tickets::Report::Sic::EvaluationService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::EvaluationService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::EvaluationService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::EvaluationService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    it 'invokes presenter with scope' do
      scope = [evaluation_1, evaluation_2, evaluation_3]

      allow(Reports::Tickets::EvaluationPresenter).to receive(:new).and_call_original

      service.call

      expect(Reports::Tickets::EvaluationPresenter).to have_received(:new).with(match_array(scope))
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.evaluation.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sic.evaluation.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do

        evaluation_1

        questions = [
          :question_01_a,
          :question_01_b,
          :question_01_c,
          :question_01_d,
          :question_02,
          :question_03
        ]

        allow(service).to receive(:xls_add_row)

        questions.each do |question|
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.question_name(question,'sic'), presenter.question_average(question) ])
        end

        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sic.evaluation.total'), scope.count ])

        service.call
      end
    end
  end
end
