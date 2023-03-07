require 'rails_helper'

describe CreateGrossExportSpreadsheet do
  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }
  let(:gross_export) { create(:gross_export, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date} }) }
  let(:topic) { create(:topic, :no_characteristic) }

  subject(:create_gross_export_spreadsheet) { CreateGrossExportSpreadsheet.new(gross_export.id) }

  it 'invalid gross_export' do
    expect { CreateGrossExportSpreadsheet.call(0) }.to_not raise_error
    expect(CreateGrossExportSpreadsheet.call(0)).to eq nil
  end

  context 'file' do
    it 'creates base gross_export dir' do
      topic
      dir = Rails.root.join('public', 'files', 'downloads', 'gross_export', gross_export.id.to_s)
      FileUtils.rm_rf(dir) if File.exist?(dir)

      subject.call

      expect(File.exist?(dir)).to eq(true)
    end

    it 'overrides existing directory' do
      topic
      base_dir_path = ['public', 'files', 'downloads', 'gross_export', gross_export.id.to_s].join('/').to_s

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
        Reports::Tickets::GrossExport::SummaryService,
        Reports::Tickets::GrossExport::SicService
      ]
    end

    let(:sou_sheet_name) do
      [
        Reports::Tickets::GrossExport::SummaryService,
        Reports::Tickets::GrossExport::SouService
      ]
    end

    context 'sic' do
      let(:gross_export) { create(:gross_export, :sic) }

      it { expect(create_gross_export_spreadsheet.send(:sheets)).to eq(sic_sheet_name)}
    end

    context 'sou' do
      it 'sou_type' do
        expect(create_gross_export_spreadsheet.send(:sheets)).to eq(sou_sheet_name)
      end
    end
  end
end
