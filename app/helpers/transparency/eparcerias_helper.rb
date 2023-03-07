module Transparency::EparceriasHelper

  def transparency_eparcerias_configuration_import_types_for_select
    transparency_eparcerias_import_type_keys.map do |import_type|
      [ I18n.t("integration/eparcerias/configuration.import_types.#{import_type}"), import_type ]
    end
  end

  def transparency_eparcerias_work_plan_download_path(work_plan_attachment)
    download_path = "/files/downloads/integration/eparcerias/work_plan_attachments/#{work_plan_attachment.id}/#{work_plan_attachment.file_name}"

    file_path = Rails.root.join('public', 'files', 'downloads', 'integration', 'eparcerias', 'work_plan_attachments', work_plan_attachment.id.to_s, work_plan_attachment.file_name)

    File.exists?(file_path) ? download_path : nil
  end

  private

  def transparency_eparcerias_import_type_keys
    Integration::Eparcerias::Configuration.import_types.keys
  end
end
