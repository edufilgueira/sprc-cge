require 'rails_helper'

describe Reports::Attendances::ServiceTypeByUserService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:default_scope) { Attendance.where(created_at: beginning_date..end_date.end_of_day) }

  let(:service_types) { Attendance.service_types.symbolize_keys }

  let(:presenter) { Reports::Attendances::ServiceTypeByUserPresenter.new(default_scope) }
  subject(:service) { Reports::Attendances::ServiceTypeByUserService.new(xls_workbook, beginning_date, end_date) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Attendances::ServiceTypeByUserService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Attendances::ServiceTypeByUserService.call(xls_workbook, beginning_date, end_date)

      expect(Reports::Attendances::ServiceTypeByUserService).to have_received(:new).with(xls_workbook, beginning_date, end_date)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:out_range_attendance) { create(:attendance, created_at: date.prev_month) }

      before do
        out_range_attendance

        service_types.each { |key, _| create(:attendance, key) }

        allow(Reports::Attendances::ServiceTypeByUserPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Attendances::ServiceTypeByUserPresenter).to have_received(:new).with(match_array(default_scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.attendances.service_type_by_user.sheet_name").slice(0, 25)

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      it 'header' do
        header_name = I18n.t("services.reports.attendances.service_type_by_user.headers.name")
        service_type_headers = service_types.keys.map { |key| Attendance.human_attribute_name("service_type.#{key}")}

        headers = [header_name] + service_type_headers

        allow(service).to receive(:xls_add_header)
        expect(service).to receive(:xls_add_header).with(anything, headers)

        service.call
      end

      context 'rows' do
        let(:call_center_1) { create(:user, :operator_call_center) }
        let(:call_center_2) { create(:user, :operator_call_center) }
        let(:call_center_supervisor) { create(:user, :operator_call_center_supervisor) }

        let(:operators) { [call_center_1, call_center_2, call_center_supervisor] }

        before do
          create(:attendance, :sic_forward, created_by_id: call_center_1.id)
          create(:attendance, :sic_completed, created_by_id: call_center_2.id)
          create(:attendance, :sic_forward, created_by_id: call_center_supervisor.id)

          service_types.each do |key, _|
            create(:attendance, key, created_by_id: call_center_1.id)
          end

          allow(service).to receive(:xls_add_row)
          service.call
        end

        it 'by operator' do
          operators.each do |operator|
            expect(service).to have_received(:xls_add_row).with(anything, presenter.row(operator))
          end
        end
      end
    end
  end
end
