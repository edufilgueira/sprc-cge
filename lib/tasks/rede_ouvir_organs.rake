#
# Rake para popular a lista de rede ouvir da administração.
#
# É do tipo 'create_or_update' pois não destrói dados.
#

# cd /app/sprc/current && RAILS_ENV=production bundle exec rake rede_ouvir_organs:create_or_update
namespace :rede_ouvir_organs do
  task create_or_update: :environment do

    rede_ouvir_organs_data = [
      [RedeOuvirOrgan::REDE_OUVIR_CGE_ACRONYM, 'Rede Ouvir - Gestão estadual'],
      ['MINISTÉRIO PÚBLICO', 'Ministério Público'],
      ['DEFENSORIA PÚBLICA', 'Defensoria Pública'],
      ['ASSEMBLEIA LEGISLATIVA', 'Assembleia Legislativa'],
      ['TCE', 'Tribunal de Contas do Estado do Ceará'],
      ['CAMARA DE VEREADORES', 'Camara dos Vereadores'],
      ['OAB', 'Ouvidoria da OAB/CE '],
      ['UVC', 'União dos Vereadores e Câmaras do Ceará'],
      ['TJCE', 'Poder Judiciário do Estado do Ceará'],
      ['PREFEITURA DE FORTALEZA', 'Prefeitura de Fortaleza'],
      ['APRECE', 'Associação dos Municípios do Estado do Ceará'],
      ['ABO-CE', 'Associação Brasileira de Ouvidores/Ombudsman Seccional Ceará'],
      ['ARACATI', 'Prefeitura Municipal de Aracati']
    ]

    rede_ouvir_organs_data.each do |rede_ouvir_data|
      rede_ouvir_acronym = rede_ouvir_data[0]
      rede_ouvir_name = rede_ouvir_data[1]

      rede_ouvir = RedeOuvirOrgan.find_or_initialize_by(acronym: rede_ouvir_acronym)
      rede_ouvir.name = rede_ouvir_name
      rede_ouvir.ignore_cge_validation = true

      rede_ouvir.save
    end
  end
end
