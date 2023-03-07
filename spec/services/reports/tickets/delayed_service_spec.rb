require 'rails_helper'

describe Reports::Tickets::DelayedService do
  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  subject(:service) { Reports::Tickets::DelayedService.new(beginning_date, end_date) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::DelayedService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::DelayedService.call(beginning_date, end_date)

      expect(Reports::Tickets::DelayedService).to have_received(:new).with(beginning_date, end_date)
      expect(service).to have_received(:call)
    end
  end

  describe 'file system' do

    let(:dir) { Rails.root.join('public', 'files', 'downloads', 'reports', 'delayed') }
    let(:filename) { "delayed_#{Time.now.to_i}.xlsx" }
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
    it 'sou' do
      allow(Reports::Tickets::Delayed::SouService).to receive(:call)

      service.call

      expect(Reports::Tickets::Delayed::SouService).to have_received(:call)
    end

    it 'sic' do
      allow(Reports::Tickets::Delayed::SouService).to receive(:call)

      service.call

      expect(Reports::Tickets::Delayed::SouService).to have_received(:call)
    end
  end
end
