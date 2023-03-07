require 'rails_helper'

describe Reports::Tickets::Report::Sou::OrganService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { ticket_report.filtered_scope }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::Sou::OrganPresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sou::OrganService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sou::OrganService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sou::OrganService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sou::OrganService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:ticket_parent_no_children) { create(:ticket, :confirmed) }
      let(:scope) { ticket_report.filtered_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES) }

      before do
        create(:ticket, :confirmed, :sic)
        create(:ticket, :invalidated)
        create(:classification, :other_organs).ticket
        create(:ticket, :confirmed, :with_parent, organ: organ_dpge)

        allow(Reports::Tickets::Sou::OrganPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Tickets::Sou::OrganPresenter).to have_received(:new).with(match_array(scope), ticket_report) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sou.organ.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'does not create sheet when operator sectoral' do
        ticket_report.update(user: create(:user, :operator_sou_sectoral))

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).not_to receive(:add_worksheet)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sou.organ.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        create(:executive_organ)
        organ_disabled = create(:executive_organ, :disabled)
        create(:ticket, :confirmed, :with_parent, organ: organ_dpge)
        create(:ticket, :confirmed, :with_parent, organ: organ_disabled)

        allow(service).to receive(:xls_add_row)

        ExecutiveOrgan.enabled.where.not(id: ExecutiveOrgan.dpge).find_each do |organ|
          organ_count = presenter.organ_count(organ)
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.organ_str(organ), organ_count, presenter.organ_percentage(organ_count)])
        end

        Organ.disabled.find_each do |organ|
          expect(service).not_to receive(:xls_add_row).with(anything, [ presenter.organ_str(organ), presenter.organ_count(organ), anything ])
        end

        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sou.organ.total'), presenter.total_count ])

        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.tickets.sou.organ.empty'), presenter.organ_count(nil) ])

        expect(service).not_to receive(:xls_add_row).with(anything, [ presenter.organ_str(ExecutiveOrgan.dpge), presenter.organ_count(ExecutiveOrgan.dpge) ])

        service.call
      end
    end
  end
end
