require 'rails_helper'

describe Reports::Tickets::EvaluationsService do
  let(:date) { Date.today }
  let(:beginning_date) { Date.today.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:report) { create(:evaluation_export, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}}) }

  subject(:service) { Reports::Tickets::EvaluationsService.new(report.id) }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Reports::Tickets::EvaluationsService).to receive(:new) { service }
      allow(service).to receive(:call)

      Reports::Tickets::EvaluationsService.call(report.id)

      expect(Reports::Tickets::EvaluationsService).to have_received(:new).with(report.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'file system' do
    it 'overrides existing directory' do
      base_dir_path = ['public', 'files', 'downloads', 'evaluation_export', report.id.to_s].join('/').to_s

      base_dir = Rails.root.join(base_dir_path)
      test_file_path = base_dir.join('test_file').to_s

      FileUtils.mkpath(base_dir.to_s)

      FileUtils.touch(test_file_path)
      expect(File.exist?(test_file_path)).to eq(true)

      subject.call

      expect(File.exist?(base_dir.to_s)).to eq(true)
      expect(File.exist?(test_file_path)).to eq(false)
    end
  end

  describe 'call service' do
    it 'summary' do
      allow(Reports::Tickets::Evaluations::SummaryService).to receive(:call)

      service.call

      expect(Reports::Tickets::Evaluations::SummaryService).to have_received(:call)
    end

    context 'sou' do
      before do
        allow(Reports::Tickets::Evaluations::SouService).to receive(:call)
        allow(Reports::Tickets::Evaluations::SicService).to receive(:call)

        service.call
      end

      it { expect(Reports::Tickets::Evaluations::SouService).to have_received(:call) }
      it { expect(Reports::Tickets::Evaluations::SicService).not_to have_received(:call) }
    end

    context 'sic' do
      let(:report) { create(:evaluation_export, filters: { ticket_type: :sic, confirmed_at: { start: beginning_date, end: end_date}}) }

      before do
        allow(Reports::Tickets::Evaluations::SicService).to receive(:call)
        allow(Reports::Tickets::Evaluations::SouService).to receive(:call)

        service.call
      end

      it { expect(Reports::Tickets::Evaluations::SicService).to have_received(:call) }
      it { expect(Reports::Tickets::Evaluations::SouService).not_to have_received(:call) }
    end
  end
end
