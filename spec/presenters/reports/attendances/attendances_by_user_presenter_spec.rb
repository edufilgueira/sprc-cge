require 'rails_helper'

describe Reports::Attendances::AttendancesByUserPresenter do
  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month }

  let(:scope) { Attendance.joins(:ticket) }

  subject(:presenter) { Reports::Attendances::AttendancesByUserPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Attendances::AttendancesByUserPresenter).to receive(:new)

      presenter

      expect(Reports::Attendances::AttendancesByUserPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    context 'count' do
      let(:call_center_1) { create(:user, :operator_call_center) }
      let(:call_center_2) { create(:user, :operator_call_center) }

      before do
        create(:attendance, :with_ticket, created_by_id: call_center_1.id)
        create(:attendance, :with_ticket, created_by_id: call_center_1.id)
      end

      it { expect(presenter.count(call_center_1)).to eq(2) }
      it { expect(presenter.count(call_center_2)).to eq(0) }
    end
  end
end
