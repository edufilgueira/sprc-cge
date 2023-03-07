FactoryBot.define do
  factory :integration_servers_configuration, class: 'Integration::Servers::Configuration' do
    arqfun_ftp_address "example.caiena.net"
    arqfun_ftp_passive false
    arqfun_ftp_dir "pub/servidores"
    arqfun_ftp_user "MyString"
    arqfun_ftp_password "MyString"
    arqfin_ftp_address "example.caiena.net"
    arqfin_ftp_passive false
    arqfin_ftp_dir "pub/servidores"
    arqfin_ftp_user "MyString"
    arqfin_ftp_password "MyString"
    rubricas_ftp_address "example.caiena.net"
    rubricas_ftp_passive false
    rubricas_ftp_dir "pub/servidores"
    rubricas_ftp_user "MyString"
    rubricas_ftp_password "MyString"

    schedule

    trait :invalid do
      arqfun_ftp_address ""
    end
  end
end
