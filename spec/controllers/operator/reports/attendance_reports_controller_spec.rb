require 'rails_helper'

describe Operator::Reports::AttendanceReportsController do

  let(:user) { create(:user, :operator_call_center_supervisor) }

  let(:resources) { create_list(:attendance_report, 2, user: user) }

  let(:permitted_params) do
    [
      :title,
      :starts_at,
      :ends_at
    ]
  end

  let(:valid_params) do
    {
      attendance_report: attributes_for(:attendance_report)
    }
  end

  it_behaves_like 'controllers/operator/base/index' do
    it_behaves_like 'controllers/operator/base/index/xhr'
    it_behaves_like 'controllers/operator/base/index/paginated'
    it_behaves_like 'controllers/operator/base/index/search'
  end

  it_behaves_like 'controllers/operator/base/new'

  it_behaves_like 'controllers/operator/base/create' do

    context 'authorized' do
      before { sign_in(user) }

      it 'invokes service' do
        service = double
        allow(Reports::AttendancesService).to receive(:delay) { service }
        allow(service).to receive(:call)

        post(:create, params: valid_params)

        attendance_report = AttendanceReport.last
        expect(service).to have_received(:call).with(attendance_report.id)
      end
    end
  end

  it_behaves_like 'controllers/operator/base/show' do
    it { is_expected.to be_kind_of(Operator::BaseTicketSpreadsheetController) }
  end

  it_behaves_like 'controllers/operator/base/destroy'
end
