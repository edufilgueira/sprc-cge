require 'rails_helper'

describe Reports::Tickets::Report::Sou::DenunciationTypeService do
  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}, finalized: 1 }) }
  let(:default_scope) { ticket_report.filtered_scope }
  let!(:organ_dpge) { create(:executive_organ, :dpge) }

  let(:presenter) { Reports::Tickets::Sou::DenunciationTypePresenter.new(default_scope, ticket_report) }
  subject(:service) { Reports::Tickets::Report::Sou::DenunciationTypeService.new(xls_workbook, ticket_report) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::Report::Sou::DenunciationTypeService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::Report::Sou::DenunciationTypeService.call(xls_workbook, ticket_report)

      expect(Reports::Tickets::Report::Sou::DenunciationTypeService).to have_received(:new).with(xls_workbook, ticket_report)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    it 'invokes presenter with scope' do
      ticket = create(:ticket, :with_parent)

      scope = ticket_report.filtered_scope.without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES)

      create(:ticket, :confirmed, :with_parent, organ: organ_dpge)

      allow(Reports::Tickets::Sou::DenunciationTypePresenter).to receive(:new).and_call_original

      service.call

      expect(Reports::Tickets::Sou::DenunciationTypePresenter).to have_received(:new).with(scope, ticket_report)
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.tickets.sou.denunciation_type.sheet_name")

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.tickets.sou.denunciation_type.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        create(:ticket, :with_parent)

        denunciation_types = [
          :in_favor_of_the_state,
          :against_the_state,
          :without_type
        ]

        denunciation_types.each do |denunciation_type|
          total_denunciation_type = presenter.denunciation_type_count(denunciation_type)
          expect(service).to receive(:xls_add_row).with(anything, [ presenter.denunciation_type_name(denunciation_type), total_denunciation_type, presenter.denunciation_type_percentage(total_denunciation_type) ])
        end

        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t("services.reports.tickets.sou.denunciation_type.rows.total"), presenter.denunciation_type_count(:total)])

        service.call
      end
    end
  end
end
