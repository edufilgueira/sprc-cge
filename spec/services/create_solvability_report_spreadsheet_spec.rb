require 'rails_helper'

describe CreateSolvabilityReportSpreadsheet do
  let(:solvability_report) { create(:solvability_report) }

  subject(:create_solvability_report_spreadsheet) { CreateSolvabilityReportSpreadsheet.new(solvability_report.id) }

  it 'invalid solvability_report' do
    expect { CreateSolvabilityReportSpreadsheet.call(0) }.to_not raise_error
    expect(CreateSolvabilityReportSpreadsheet.call(0)).to eq nil
  end

  context 'file' do
    it 'creates base solvability_report dir' do
      dir = Rails.root.join('public', 'files', 'downloads', 'solvability_report', solvability_report.id.to_s)
      FileUtils.rm_rf(dir) if File.exist?(dir)

      subject.call

      expect(File.exist?(dir)).to eq(true)
    end

    it 'overrides existing directory' do
      base_dir_path = ['public', 'files', 'downloads', 'solvability_report', solvability_report.id.to_s].join('/').to_s

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

  context 'sheets' do
    let(:sic_sheet_name) do
      [
        Reports::Tickets::Solvability::SicService
      ]
    end

    let(:sou_sheet_name) do
      [
        Reports::Tickets::Solvability::SouService
      ]
    end

    context 'sic' do
      let(:solvability_report) { create(:solvability_report, :sic) }

      it { expect(create_solvability_report_spreadsheet.send(:sheets)).to eq(sic_sheet_name)}
    end

    context 'sou' do
      it 'sou_type' do
        expect(create_solvability_report_spreadsheet.send(:sheets)).to eq(sou_sheet_name)
      end
    end
  end
end
