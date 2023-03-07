require 'rails_helper'

describe Reports::Tickets::Report::Sou::AnswerClassificationService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { ticket_report.filtered_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::AnswerClassificationPresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sou::AnswerClassificationService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sou::AnswerClassificationService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sou::AnswerClassificationService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sou::AnswerClassificationService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:ticket_child_replied) { create(:ticket, :with_parent, :replied) }
      let(:scope) { default_scope }

      before do
        create(:ticket, :with_parent)
        create(:ticket, :confirmed)
        create(:ticket, :confirmed, :sic)
        create(:ticket, :invalidated)
        create(:classification, :other_organs).ticket
        create(:ticket, :confirmed, :with_parent, organ: organ_dpge)

        allow(Reports::Tickets::AnswerClassificationPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::AnswerClassificationPresenter).to have_received(:new).with(scope, ticket_report) }
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

      it 'rows' do
        create(:ticket, :replied)

        allow(service).to receive(:xls_add_row)

          total = presenter.answer_classification_count(:legacy_classification)
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.answer_classification_str(:legacy_classification), total, presenter.answer_percentage(total) ])

        without_classification_count = presenter.answer_classification_count(nil)
        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sou.answer_classification.empty'), without_classification_count, presenter.answer_percentage(without_classification_count) ])

        default_scope.distinct.pluck(:answer_classification).compact.each do |answer_classification|
          total = presenter.answer_classification_count(answer_classification)
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.answer_classification_str(answer_classification), total, presenter.answer_percentage(total)])
        end

        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t("services.reports.tickets.sou.answer_classification.total"), presenter.total ])

        service.call
      end
    end
  end
end
