require 'rails_helper'

describe Reports::Attendances::SicService do

  let(:xls_package) { ::Axlsx::Package.new }
  let(:xls_workbook) { xls_package.workbook }

  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:default_scope) { Attendance.joins(:ticket).where(created_at: beginning_date..end_date.end_of_day) }

  let(:rejected_service_types) { Attendance.service_types.symbolize_keys.except(:sic_forward, :sic_completed) }

  let(:presenter) { Reports::Attendances::AttendancesByUserPresenter.new(default_scope) }
  subject(:service) { Reports::Attendances::SicService.new(xls_workbook, beginning_date, end_date) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Attendances::SicService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Attendances::SicService.call(xls_workbook, beginning_date, end_date)

      expect(Reports::Attendances::SicService).to have_received(:new).with(xls_workbook, beginning_date, end_date)
      expect(service).to have_received(:call)
    end
  end

  describe 'call service' do

    context 'invokes presenter with scope' do
      let(:attendance_sic_forward) { create(:attendance, :sic_forward) }
      let(:attendance_sic_completed) { create(:attendance, :sic_completed) }

      let(:scope) { [attendance_sic_forward, attendance_sic_completed] }

      before do
        scope

        rejected_service_types.each do |key, _|
          create(:attendance, key)
        end

        allow(Reports::Attendances::AttendancesByUserPresenter).to receive(:new).and_call_original

        service.call
      end


      it { expect(Reports::Attendances::AttendancesByUserPresenter).to have_received(:new).with(match_array(scope)) }
    end

    context 'worksheet' do
      it 'sheet_name' do
        expected = I18n.t("services.reports.attendances.sic.sheet_name").slice(0, 25)

        allow_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet)
        expect_any_instance_of(Axlsx::Workbook).to receive(:add_worksheet).with(name: expected)

        service.call
      end

      context 'headers' do
        it 'add_attendance_header' do
          title = [ I18n.t("services.reports.attendances.sic.attendance_title") ]

          allow(service).to receive(:xls_add_header)
          expect(service).to receive(:xls_add_header).with(anything, title)

          service.call
        end

        it 'add_returned_phone_header' do
          title = [
            I18n.t("services.reports.attendances.sic.returned_phone_title"),
            I18n.t("services.reports.attendances.sic.returned_phone_header_with_success_title"),
            I18n.t("services.reports.attendances.sic.returned_phone_header_without_success_title"),
            I18n.t("services.reports.attendances.sic.returned_phone_header_attemps_title"),
            I18n.t("services.reports.attendances.sic.returned_phone_header_total_protocols_title")
          ]

          allow(service).to receive(:xls_add_header)
          expect(service).to receive(:xls_add_header).with(anything, title)

          service.call
        end

        it 'add_returned_whatsapp_header' do
          title = [
            I18n.t("services.reports.attendances.sic.returned_whatsapp_title"),
            I18n.t("services.reports.attendances.sic.returned_whatsapp_header_total_returned_title")
          ]

          allow(service).to receive(:xls_add_header)
          expect(service).to receive(:xls_add_header).with(anything, title)

          service.call
        end
      end

      context 'rows' do
        let(:call_center_1) { create(:user, :operator_call_center) }
        let(:call_center_2) { create(:user, :operator_call_center) }
        let(:call_center_whatsapp) { create(:user, :operator_call_center) }
        let(:call_center_supervisor) { create(:user, :operator_call_center_supervisor) }

        before do
          create(:attendance, :sic_forward, created_by_id: call_center_1.id)
          create(:attendance, :sic_completed, created_by_id: call_center_2.id)
          create(:attendance, :sic_forward, created_by_id: call_center_2.id)
          create(:attendance, :sic_forward, created_by_id: call_center_supervisor.id)

          ticket_phone_return = create(:ticket, answer_type: :phone, answer_phone: 'teste 123', ticket_type: :sic)
          ticket_whatsapp_return = create(:ticket, answer_type: :whatsapp, answer_whatsapp: 'teste 123', ticket_type: :sic)

          attendace_response_failure_1 = create(:attendance_response, response_type: :failure, ticket_id: ticket_phone_return.id)
          attendace_response_failure_2 = create(:attendance_response, response_type: :failure, ticket_id: ticket_phone_return.id)
          attendace_response_success_1 = create(:attendance_response, response_type: :success, ticket_id: ticket_phone_return.id)
          attendace_response_success_2 = create(:attendance_response, response_type: :success, ticket_id: ticket_whatsapp_return.id)

          create(:ticket_log, action: :attendance_response, resource: attendace_response_failure_1, ticket_id: ticket_phone_return.id, responsible: call_center_1)
          create(:ticket_log, action: :attendance_response, resource: attendace_response_failure_2, ticket_id: ticket_phone_return.id, responsible: call_center_1)
          create(:ticket_log, action: :attendance_response, resource: attendace_response_success_1, ticket_id: ticket_phone_return.id, responsible: call_center_1)
          create(:ticket_log, action: :attendance_response, resource: attendace_response_failure_2, ticket_id: ticket_whatsapp_return.id, responsible: call_center_whatsapp)

          rejected_service_types.each do |key, _|
            create(:attendance, key, created_by_id: call_center_1.id)
          end

          allow(service).to receive(:xls_add_row)
          service.call
        end

        context 'attendances_by_user' do
          it { expect(service).to have_received(:xls_add_row).with(anything, [ call_center_1.name, 1 ]) }
          it { expect(service).to have_received(:xls_add_row).with(anything, [ call_center_2.name, 2 ]) }
          it { expect(service).to have_received(:xls_add_row).with(anything, [ call_center_supervisor.name, 1 ]) }
        end

        context 'phone_returned_by_user_presenter' do
          it { expect(service).to have_received(:xls_add_row).with(anything, [ call_center_1.name, 1, 2, 3, 1 ]) }
        end

        context 'phone_returned_by_user_presenter' do
          it { expect(service).to have_received(:xls_add_row).with(anything, [ call_center_whatsapp.name, 1 ]) }
        end
      end
    end
  end
end
