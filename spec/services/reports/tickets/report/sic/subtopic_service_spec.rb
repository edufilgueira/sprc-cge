require 'rails_helper'

describe Reports::Tickets::Report::Sic::SubtopicService do

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

  let(:presenter) { Reports::Tickets::SubtopicPresenter.new(report_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::SubtopicService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::SubtopicService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::SubtopicService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::SubtopicService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:topic_1) { create(:topic) }
      let(:topic_1_subtopic_1) { create(:subtopic, topic: topic_1) }
      let(:topic_1_subtopic_2) { create(:subtopic, topic: topic_1) }

      let(:topic_2) { create(:topic) }
      let(:topic_2_subtopic_1) { create(:subtopic, topic: topic_2) }
      let(:topic_2_subtopic_2) { create(:subtopic, topic: topic_2) }

      let(:ticket_topic_1) { create(:classification, :sic, topic: topic_1, subtopic: topic_1_subtopic_1).ticket }
      let(:ticket_topic_2) { create(:classification, :sic, topic: topic_2, subtopic: topic_2_subtopic_2).ticket }

      let(:scope) { report_scope }

      before do
        scope

        topic_1_subtopic_1
        topic_1_subtopic_2
        topic_2_subtopic_1
        topic_2_subtopic_2


        create(:ticket, :confirmed)

        # fora do range de data
        create(:ticket, :sic, :confirmed, confirmed_at: 31.days.ago)

        allow(Reports::Tickets::SubtopicPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::SubtopicPresenter).to have_received(:new).with(match_array(scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.subtopic.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      context 'header' do
        context 'when cge operator' do
          it 'include organ' do
            topic_title = I18n.t("services.reports.tickets.sic.subtopic.topic.title")
            subtopic_title = I18n.t("services.reports.tickets.sic.subtopic.subtopic.title")
            organ_title = I18n.t("services.reports.tickets.sic.subtopic.organ.title")
            count_title = I18n.t("services.reports.tickets.sic.subtopic.count.title")
            percentage_title = I18n.t("services.reports.tickets.sic.subtopic.percentage.title")

            allow(service).to receive(:xls_add_header)
            expect(service).to receive(:xls_add_header).with(anything, [ topic_title, subtopic_title, organ_title, count_title, percentage_title ])

            service.call
          end
        end
        context 'when sectoral operator' do
          let(:ticket_report) { create(:ticket_report, :sectoral) }
          it 'exclude organ' do
            topic_title = I18n.t("services.reports.tickets.sic.subtopic.topic.title")
            subtopic_title = I18n.t("services.reports.tickets.sic.subtopic.subtopic.title")
            count_title = I18n.t("services.reports.tickets.sic.subtopic.count.title")
            percentage_title = I18n.t("services.reports.tickets.sic.subtopic.percentage.title")

            allow(service).to receive(:xls_add_header)
            expect(service).to receive(:xls_add_header).with(anything, [ topic_title, subtopic_title, count_title, percentage_title ])

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
