require 'rails_helper'

describe Reports::Attendances::SummaryPresenter do
  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month }

  let(:scope) { Attendance.joins(:ticket) }

  subject(:presenter) { Reports::Attendances::SummaryPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Attendances::SummaryPresenter).to receive(:new)

      presenter

      expect(Reports::Attendances::SummaryPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    context 'total_sou_count' do
      let(:rejected_service_types) { Attendance.service_types.symbolize_keys.except(:sou_forward) }

      before do
        create(:attendance, :sou_forward)
        create(:attendance, :sou_forward)

        rejected_service_types.each { |key, _| create(:attendance, key) }
      end

      it { expect(presenter.total_sou_count).to eq(2) }
    end

    context 'total_sic_count' do
      let(:rejected_service_types) { Attendance.service_types.symbolize_keys.except(:sic_forward, :sic_completed) }

      before do
        create(:attendance, :sic_forward)
        create(:attendance, :sic_completed)

        rejected_service_types.each { |key, _| create(:attendance, key) }
      end

      it { expect(presenter.total_sic_count).to eq(2) }
    end
  end
end
