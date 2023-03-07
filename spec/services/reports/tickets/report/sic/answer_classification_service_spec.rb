require 'rails_helper'

describe Reports::Tickets::Report::Sic::AnswerClassificationService do

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
    scope.where(attendances: { id: nil}).or(scope.where(attendances: { service_type: [:sic_forward, :sou_forward] }))
  end

  let!(:attendance_sic_completed) do
    ticket_immediate_answer = create(:ticket, :sic, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  # Essa situação acontece quando uma manifestação gerada por atendimento é convertida para solicitação
  let!(:attendance_sou_forward_with_ticket_sic) do
    ticket_immediate_answer = create(:ticket, :sic, :with_parent_sic, :immediate_answer)
    create(:attendance, :sou_forward, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::AnswerClassificationPresenter.new(report_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::AnswerClassificationService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::AnswerClassificationService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::AnswerClassificationService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::AnswerClassificationService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let!(:ticket_child_replied) { create(:ticket, :sic, :with_parent_sic, :replied) }
      let(:scope) { report_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

      before do
        create(:ticket, :with_parent_sic)
        create(:ticket, :confirmed, :sic)
        create(:ticket, :confirmed)
        create(:ticket, :invalidated)
        create(:classification, :other_organs).ticket
        create(:ticket, :confirmed, :sic, :with_parent_sic, organ: organ_dpge)

        allow(Reports::Tickets::AnswerClassificationPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::AnswerClassificationPresenter).to have_received(:new).with(match_array(scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sou.answer_classification.sheet_name").slice(0, 25)

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sou.answer_classification.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      context 'rows' do
        it 'all answer_classifications' do
          create(:ticket, :sic, :replied)

          allow(service).to receive(:xls_add_row)

          total = presenter.answer_classification_count(:legacy_classification)
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.answer_classification_str(:legacy_classification), total, presenter.answer_percentage(total) ])

          answer_classification = 'sic_attended_personal_info'

          total = presenter.answer_classification_count(answer_classification)
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.answer_classification_str(answer_classification), total, presenter.answer_percentage(total) ])

          expect(service).to receive(:xls_add_row).with(anything, [ I18n.t("services.reports.tickets.sic.answer_classification.total"), presenter.total ])

          service.call
        end
      end
    end
  end
end
