require 'rails_helper'

describe Reports::Attendances::SummaryService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:default_scope) { Attendance.joins(:ticket).where(created_at: beginning_date..end_date.end_of_day) }

  let(:rejected_service_types) { Attendance.service_types.symbolize_keys.except(:sou_forward, :sic_forward, :sic_completed) }

  let(:presenter) { Reports::Attendances::SummaryPresenter.new(default_scope) }
  subject(:service) { Reports::Attendances::SummaryService.new(xls_workbook, beginning_date, end_date) }


  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Attendances::SummaryService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Attendances::SummaryService.call(xls_workbook, beginning_date, end_date)

      expect(Reports::Attendances::SummaryService).to have_received(:new).with(xls_workbook, beginning_date, end_date)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:out_range_attendance) { create(:attendance, :with_ticket, created_at: date.prev_month) }
      let(:attendance_sic_completed) { create(:attendance, :sic_completed) }
      let(:attendance_sic_forward) { create(:attendance, :sic_forward) }
      let(:attendance_sou_forward) { create(:attendance, :sou_forward) }

      let(:scope) { [attendance_sic_completed, attendance_sic_forward, attendance_sou_forward] }

      before do
        out_range_attendance
        scope

        rejected_service_types.each do |key, _|
          create(:attendance, key)
        end

        allow(Reports::Attendances::SummaryPresenter).to receive(:new).and_call_original
        service.call
      end


      it { expect(Reports::Attendances::SummaryPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.attendances.summary.sheet_name").slice(0, 25)

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.attendances.summary.title", begin: date.beginning_of_month, end: date.end_of_month) ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        allow(service).to receive(:xls_add_row)

        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.attendances.summary.total.sou'), presenter.total_sou_count ])
        expect(service).to receive(:xls_add_row).with(anything, [ I18n.t('services.reports.attendances.summary.total.sic'), presenter.total_sic_count ])

        service.call
      end
    end
  end
end
