require 'rails_helper'

describe Reports::Attendances::ServiceTypeByUserPresenter do
  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month }

  let(:scope) { Attendance.where(created_at: date_range) }

  let(:service_types) { Attendance.service_types.symbolize_keys }

  subject(:presenter) { Reports::Attendances::ServiceTypeByUserPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Attendances::ServiceTypeByUserPresenter).to receive(:new)

      presenter

      expect(Reports::Attendances::ServiceTypeByUserPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    context 'rows' do
      let(:call_center) { create(:user, :operator_call_center) }

      let(:service_types_count_map) do
        service_types.map { |s| scope.where(created_by: call_center, service_type: s).count }
      end

      let(:row) do
        [call_center.name] + service_types_count_map
      end

      before do
        create(:attendance, :sic_forward, created_by_id: call_center.id)
        create(:attendance, :sic_completed, created_by_id: call_center.id)

        service_types.each do |key, _|
          create(:attendance, key, created_by_id: call_center.id)
        end
      end

      it { expect(presenter.row(call_center)).to eq(row) }
    end
  end
end
