require 'rails_helper'

describe Reports::Attendances::ServiceTypePresenter do
  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month.end_of_day }

  let(:scope) { Attendance.where(created_at: date_range) }

  subject(:presenter) { Reports::Attendances::ServiceTypePresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Attendances::ServiceTypePresenter).to receive(:new)

      presenter

      expect(Reports::Attendances::ServiceTypePresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    context 'count' do
      before do
        create(:attendance, :sic_completed)
        create(:attendance, :sic_completed)
        create(:attendance, :sou_forward)
      end

      it { expect(presenter.count(:sic_completed)).to eq(2) }
      it { expect(presenter.count(:sou_forward)).to eq(1) }
      it { expect(presenter.count(:sic_forward)).to eq(0) }
    end
  end
end
