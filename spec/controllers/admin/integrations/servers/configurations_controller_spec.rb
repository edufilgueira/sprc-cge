require 'rails_helper'

describe Admin::Integrations::Servers::ConfigurationsController do

  let(:integration_id) { :servers }

  let(:permitted_params) do
    [
      :arqfun_ftp_address,
      :arqfun_ftp_passive,
      :arqfun_ftp_dir,
      :arqfun_ftp_user,
      :arqfun_ftp_password,
      :arqfin_ftp_address,
      :arqfin_ftp_passive,
      :arqfin_ftp_dir,
      :arqfin_ftp_user,
      :arqfin_ftp_password,
      :rubricas_ftp_address,
      :rubricas_ftp_passive,
      :rubricas_ftp_dir,
      :rubricas_ftp_user,
      :rubricas_ftp_password,
      :month,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
