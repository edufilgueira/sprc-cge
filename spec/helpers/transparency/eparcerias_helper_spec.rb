require 'rails_helper'

describe Transparency::EparceriasHelper do

  it 'transparency_eparcerias_configuration_import_types_for_select' do
    expected =
      Integration::Eparcerias::Configuration.import_types.keys.map do |import_type|
        [ I18n.t("integration/eparcerias/configuration.import_types.#{import_type}"), import_type ]
      end

    expect(transparency_eparcerias_configuration_import_types_for_select).to eq(expected)
  end

  it 'transparency_eparcerias_work_plan_download_path' do
    work_plan_attachment = build(:integration_eparcerias_work_plan_attachment)
    expected_download_path = "/files/downloads/integration/eparcerias/work_plan_attachments/#{work_plan_attachment.id}/#{work_plan_attachment.file_name}"

    file_path = Rails.root.join('public', 'files', 'downloads', 'integration', 'eparcerias', 'work_plan_attachments', work_plan_attachment.id.to_s, work_plan_attachment.file_name)

    allow(File).to receive(:exists?).with(file_path).and_return(true)
    result = transparency_eparcerias_work_plan_download_path(work_plan_attachment)

    expect(result).to eq(expected_download_path)

    # deve retornar nil caso não exista o arquivo de download

    allow(File).to receive(:exists?).with(file_path).and_return(false)

    result = transparency_eparcerias_work_plan_download_path(work_plan_attachment)

    expect(result).to eq(nil)
  end
end
