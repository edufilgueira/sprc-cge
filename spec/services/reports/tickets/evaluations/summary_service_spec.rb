require 'rails_helper'

describe Reports::Tickets::Evaluations::SummaryService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:evaluation_export) { create(:evaluation_export, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}}) }
  let(:default_scope) { evaluation_export.filtered_scope }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:rejected_service_types) { Attendance.service_types.symbolize_keys.except(:sou_forward, :sic_forward, :sic_completed) }

  let(:presenter) { Reports::Tickets::Evaluations::SummaryPresenter.new(default_scope) }
  let(:ticket_type) { :sou } 
  subject(:service) { Reports::Tickets::Evaluations::SummaryService.new(xls_workbook, evaluation_export.id) }


  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Evaluations::SummaryService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Evaluations::SummaryService.call(xls_workbook, evaluation_export.id)

      expect(Reports::Tickets::Evaluations::SummaryService).to have_received(:new).with(xls_workbook, evaluation_export.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:sic_ticket) { create(:ticket, :confirmed, ticket_type: :sic)}
      let(:answer_sou) { create(:answer, ticket: sic_ticket, evaluation: create(:evaluation, :sic))}

      let(:sou_ticket) { create(:ticket, :confirmed, :replied, ticket_type: :sou)}
      let(:answer_sou) { create(:answer, ticket: sou_ticket, evaluation: create(:evaluation))}


      let(:scope) { evaluation_export.filtered_scope }

      before do
        scope

        allow(Reports::Tickets::Evaluations::SummaryPresenter).to receive(:new).and_call_original
        service.call
      end


      it { expect(Reports::Tickets::Evaluations::SummaryPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.evaluations.summary.sheet_name").slice(0, 25)

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do

        title = [ I18n.t("services.reports.tickets.evaluations.summary.title", type: ticket_type.upcase, begin: date.beginning_of_month, end: "#{date.end_of_month} 23:59"), " "]
        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      context 'rows' do
        before do
          allow(service).to receive(:xls_add_row)
          allow(service).to receive(:xls_add_header)
        end


        context 'sic' do
          let(:evaluation_export) { create(:evaluation_export, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date}}) }

          before { service.call }

          it { expect(service).to have_received(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.evaluations.summary.total.sic'), presenter.scope_count ], ["bold", "bold"]) }
          it { expect(service).not_to have_received(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.evaluations.summary.total.sou'), presenter.scope_count ]) }
        end

        context 'sou' do

          before { service.call }

          it { expect(service).to have_received(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.evaluations.summary.total.sou'), presenter.scope_count ], ["bold", "bold"]) }
          it { expect(service).not_to have_received(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.evaluations.summary.total.sic'), presenter.scope_count ]) }
        end

        it 'questions average' do

          questions = [
            :question_01_a,
            :question_01_b,
            :question_01_c,
            :question_01_d,
            :question_02,
            :question_03
          ]

          expect(service).to receive(:xls_add_header).with(anything, [ I18n.t('services.reports.tickets.evaluations.summary.satisfaction'), "Resultado" ])

          questions.each do |question|
            expect(service).to receive(:xls_add_row).with(anything, [ presenter.question_name(question,'sou'), presenter.question_average(question) ])
          end

          service.call
        end
      end
    end
  end
end
