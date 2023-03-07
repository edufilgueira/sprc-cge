require 'rails_helper'

describe TransparencyHelper do

  let(:date) { Date.new(2017, 04) }

  describe 'transparency_select_options_from_model' do
    let(:model) { Integration::Constructions::Der }
    let(:attribute) { :trecho }
    let(:ordered) { model.all }
    let(:expected) { [attribute] }

    before do
      allow(model).to receive(:distinct).with(attribute) { ordered }
    
      allow(ordered).to receive(:pluck).with(attribute) { expected }
      allow(expected).to receive(:uniq).and_call_original
      allow(expected).to receive(:sort).and_call_original

      transparency_select_options_from_model(model, attribute)
    end

    
    it { expect(model).to have_received(:distinct).with(attribute) }
    it { expect(ordered).to have_received(:pluck).with(attribute) }
    it { expect(expected).to have_received(:uniq) }
    
  end

  it 'transparency_open_data_spreadsheet_download_path' do
    filename = 'name'

    expected_download_path = "/files/downloads/integration/open_data/#{filename}"
    file_path = Rails.root.join('public', 'files', 'downloads', 'integration', 'open_data', filename)

    allow(File).to receive(:exists?).with(file_path).and_return(true)
    result = transparency_open_data_spreadsheet_download_path(filename)

    expect(result).to eq(expected_download_path)

    # deve retornar nil caso não exista o arquivo de download

    allow(File).to receive(:exists?).with(file_path).and_return(false)

    result = transparency_open_data_spreadsheet_download_path(filename)

    expect(result).to eq(nil)
  end

  it 'transparency_spreadsheet_download_path' do
    transparency_area = 'contracts/contracts'
    transparency_file_prefix = 'contratos'

    year_month = l(date, format: "%Y%m")
    extension = 'xlsx'

    expected_download_path = "/files/downloads/integration/#{transparency_area}/#{year_month}/#{transparency_file_prefix}_#{year_month}.#{extension}"
    file_path = Rails.root.join('public', 'files', 'downloads', 'integration', transparency_area, year_month, "#{transparency_file_prefix}_#{year_month}.#{extension}")

    allow(File).to receive(:exists?).with(file_path).and_return(true)
    result = transparency_spreadsheet_download_path('contracts/contracts', transparency_file_prefix, date.year, date.month, extension)

    expect(result).to eq(expected_download_path)

    # deve retornar nil caso não exista o arquivo de download

    allow(File).to receive(:exists?).with(file_path).and_return(false)

    result = transparency_spreadsheet_download_path('contracts/contracts', transparency_file_prefix, date.year, date.month, extension)

    expect(result).to eq(nil)
  end

  it 'transparency_supports_domain_select_options' do
    scope = Integration::Supports::Function.all
    id_column_name = :codigo_funcao
    title_column_name = :titulo

    create(:integration_supports_function)

    expected = Integration::Supports::Function.all.map{|f| [f.titulo, f.codigo_funcao]}
    result = transparency_supports_domain_select_options(scope, id_column_name, title_column_name)

    expect(result).to eq(expected)
  end

  it 'transparency_export_worksheet_formats' do
    expected = Transparency::Export.worksheet_formats.keys.map { |f| [ I18n.t("transparency_export.worksheet_formats.#{f}"), f] }

    result = transparency_export_worksheet_formats

    expect(result).to eq(expected)
  end
end
