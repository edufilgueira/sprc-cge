require 'rails_helper'

describe Reports::Tickets::Report::Sic::OrganService do

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
    scope.where(attendances: { id: nil }).or(scope.where(attendances: { service_type: :sic_forward }))
  end

  let!(:attendance_sic_completed) do
    ticket_immediate_answer = create(:ticket, :sic, :with_parent_sic, :immediate_answer)
    create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
  end

  let(:presenter) { Reports::Tickets::Sic::OrganPresenter.new(report_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sic::OrganService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sic::OrganService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sic::OrganService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sic::OrganService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let!(:ticket_child) { create(:ticket, :sic, :with_parent_sic) }
      let!(:ticket_parent_no_children) { create(:ticket, :confirmed, :sic) }
      let(:scope) { report_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

      before do
        create(:ticket, :confirmed, :sic)
        create(:ticket, :invalidated)
        create(:classification, :other_organs).ticket

        allow(Reports::Tickets::Sic::OrganPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sic::OrganPresenter).to have_received(:new).with(match_array(scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sic.organ.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'does not create sheet when operator sectoral' do
        ticket_report.update(user: create(:user, :operator_sic_sectoral))

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).not_to receive(:add_worksheet)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sic.organ.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      context 'tables' do
        let(:organ) { create(:executive_organ) }
        let(:other_organ) { create(:executive_organ) }
        before do
          ticket_sou = create(:ticket, :confirmed, :with_organ, description: 'ticket_sou', organ: organ)
          create(:attendance, ticket: ticket_sou, service_type: :sou_forward)

          ticket_sectoral_attendance = create(:ticket, :confirmed, :sic, :in_sectoral_attendance, :with_organ, description: 'ticket_sectoral_attendance', organ: organ)
          create(:attendance, ticket: ticket_sectoral_attendance)

          ticket_replied = create(:ticket, :sic, :replied, :with_organ, description: 'ticket_replied', organ: organ)
          create(:attendance, ticket: ticket_replied)

          ticket_invalidated = create(:ticket, :sic, :invalidated, :with_organ, description: 'ticket_invalidated', organ: organ)
          create(:attendance, ticket: ticket_invalidated)

          ticket_sou_other = create(:ticket, :confirmed, :with_organ, description: 'ticket_sou', organ: other_organ)
          create(:attendance, ticket: ticket_sou_other, service_type: :sou_forward)

          ticket_sectoral_attendance_other = create(:ticket, :confirmed, :sic, :in_sectoral_attendance, :with_organ, description: 'ticket_sectoral_attendance', organ: other_organ)
          create(:attendance, ticket: ticket_sectoral_attendance_other)

          ticket_attendance_other = create(:ticket, :sic, :replied, :with_organ, description: 'ticket_attendance_other', organ: other_organ, call_center_status: :with_feedback)
          answer_attendance = create(:answer, ticket: ticket_attendance_other)
          create(:attendance, :with_organs, service_type: :sic_completed, ticket: ticket_attendance_other, answer: answer_attendance)

          create(:ticket, :confirmed, :sic, :in_sectoral_attendance, :with_organ, description: 'ticket_sectoral_attendance', organ: organ)
        end

        it 'rows call center organ demand' do
          allow(service).to receive(:xls_add_row)

          expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sic.organ.call_center_demand') ])

          total = presenter.call_center_organ_demand_count.values.sum
          presenter.call_center_organ_demand_count.each do |organ, demand|
            expect(service).to receive(:xls_add_row).with(anything, [ organ, demand, presenter.calc_percentage(demand, total) ])
          end

          expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sic.organ.total'), total ])

          service.call
        end

        it 'rows call center organ forwarded' do
          allow(service).to receive(:xls_add_row)

          expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sic.organ.call_center_organ_forwarded') ])

          total = presenter.call_center_organ_forwarded_count.values.sum
          presenter.call_center_organ_forwarded_count.each do |organ, demand|
            expect(service).to receive(:xls_add_row).with(anything, [ organ, demand, presenter.calc_percentage(demand, total) ])
          end

          expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sic.organ.total'), total ])

          service.call
        end

        it 'rows organs demand' do
          allow(service).to receive(:xls_add_row)

          expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sic.organ.organs_demand') ])

          total = presenter.organs_demand_count.values.sum
          presenter.organs_demand_count.each do |organ, demand|
            expect(service).to receive(:xls_add_row).with(anything, [ organ, demand, presenter.calc_percentage(demand, total) ])
          end

          expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sic.organ.total'), total ])

          service.call
        end
      end
    end
  end
end
