require 'rails_helper'

describe Reports::AttendancesService do
  let(:date) { Date.today }
  let(:beginning_date) { Date.today.beginning_of_month.to_datetime }
  let(:end_date) { date.end_of_month.to_datetime }

  let(:report) { create(:attendance_report, starts_at: beginning_date, ends_at: end_date) }

  subject(:service) { Reports::AttendancesService.new(report.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::AttendancesService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::AttendancesService.call(report.id)

      expect(Reports::AttendancesService).to have_received(:new).with(report.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'file system' do

    let(:dir) { Rails.root.join('public', 'files', 'downloads', 'attendance_reports', report.id.to_s) }
    let(:filename) { "attendance_report_#{report.id}.xlsx" }
    let(:now) { Time.now }

    before do
      now
      allow(Time).to receive(:now){ now }

      FileUtils.rm_rf(dir) if File.exist?(dir)

      service.call
    end

    it { expect(File.exist?(dir)).to eq(true) }
    it { expect(Dir.entries(dir)).to include(filename) }

  end

  describe 'call service' do
    it 'summary' do
      allow(Reports::Attendances::SummaryService).to receive(:call)

      service.call

      expect(Reports::Attendances::SummaryService).to have_received(:call)
    end

    it 'sou' do
      allow(Reports::Attendances::SouService).to receive(:call)

      service.call

      expect(Reports::Attendances::SouService).to have_received(:call)
    end

    it 'sic' do
      allow(Reports::Attendances::SicService).to receive(:call)

      service.call

      expect(Reports::Attendances::SicService).to have_received(:call)
    end

    it 'service_type' do
      allow(Reports::Attendances::ServiceTypeService).to receive(:call)

      service.call

      expect(Reports::Attendances::ServiceTypeService).to have_received(:call)
    end

    it 'service_type_by_user' do
      allow(Reports::Attendances::ServiceTypeByUserService).to receive(:call)

      service.call

      expect(Reports::Attendances::ServiceTypeByUserService).to have_received(:call)
    end
  end
end
