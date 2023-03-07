require 'rails_helper'

describe Reports::Attendances::ServiceTypeService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:default_scope) { Attendance.where(created_at: beginning_date..end_date.end_of_day) }

  let(:service_types) { Attendance.service_types.symbolize_keys }

  let(:presenter) { Reports::Attendances::ServiceTypePresenter.new(default_scope) }
  subject(:service) { Reports::Attendances::ServiceTypeService.new(xls_workbook, beginning_date, end_date) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Attendances::ServiceTypeService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Attendances::ServiceTypeService.call(xls_workbook, beginning_date, end_date)

      expect(Reports::Attendances::ServiceTypeService).to have_received(:new).with(xls_workbook, beginning_date, end_date)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:out_range_attendance) { create(:attendance, created_at: date.prev_month) }

      before do
        out_range_attendance

        service_types.each { |key, _| create(:attendance, key) }

        allow(Reports::Attendances::ServiceTypePresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Attendances::ServiceTypePresenter).to have_received(:new).with(match_array(default_scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.attendances.service_type.sheet_name").slice(0, 25)

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        title = [ I18n.t("services.reports.attendances.service_type.title") ]

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, title)

        service.call
      end

      it 'rows' do
        service_types.each { |key, _| create(:attendance, key) }
        allow(service).to receive(:xls_add_row)

        service.call

        service_types.each do |key, _|
          label = Attendance.human_attribute_name("service_type.#{key}")
          expect(service).to have_received(:xls_add_row).with(anything, [ label, 1 ])
        end
      end
    end
  end
end
