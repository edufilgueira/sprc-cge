#
# Rake para popular a lista de órgãos da administração.
#
# É do tipo 'create_or_update' pois não destrói dados.
#

# cd /app/sprc/current && RAILS_ENV=production bundle exec rake organs:create_or_update
namespace :organs do
  task create_or_update: :environment do

    organs_data = [
      ['ADAGRI', 'Agência de Defesa Agropecuária do Estado do Ceará', '832'],
      ['ADECE', 'Agência de Desenvolvimento do Estado do Ceará'],
      ['AESP/CE', 'Academia Estadual de Segurança Pública do Ceará', '102'],
      ['ARCE', 'Agência Reguladora de Serviços Públicos Delegados do Estado do Ceará', '612'],
      ['CAGECE', 'Companhia de Água e Esgoto do Ceará'],
      ['CV', 'Casa Civil', '161'],
      ['CM', 'Casa Militar', '141'],
      ['CBMCE', 'Corpo de Bombeiros Militar do Estado do Ceará', '381'],
      ['CEARÁ PORTOS', 'Companhia de Integração Portuária do Ceará'],
      ['CEASA', 'Centrais de Abastecimento do Ceará S/A'],
      ['CED', 'Centro de Educação à Distância', '222'],
      ['CEGÁS', 'Companhia de Gás do Ceará'],
      ['CGD', 'Controladoria Geral de Disciplina dos órgãos de Segurança Pública e Sistema Penitenciário', '129'],
      ['CGE', 'Controladoria e Ouvidoria Geral do Estado', '051'],
      ['CODECE', 'Companhia de Desenvolvimento do Ceará'],
      ['COGERH', 'Companhia de Gestão dos Recursos Hídricos do Ceará'],
      ['COSCO', 'Coordenadoria de Correição'],
      ['DAE', 'Departamento de Arquitetura e Engenharia', '643'],
      ['DER', 'Departamento Estadual de Rodovias', '642'],
      ['DETRAN', 'Departamento Estadual de Trânsito', '502'],
      ['EGP', 'Escola de Gestão Pública do Estado do Ceará', '126'],
      ['EMATERCE', 'Empresa de Assistência Técnica e Extensão Rural do Ceará', '512'],
      ['ESP', 'Escola de Saúde Pública', '782'],
      ['ETICE', 'Empresa de Tecnologia da Informação do Ceará', '622'],
      ['FUNCAP', 'Fundação Cearense de Apoio ao Desenvolvimento Científico e Tecnológico', '492'],
      ['FUNCEME', 'Fundação Cearense de Meteorologia e Recursos Hídricos', '592'],
      ['FUNTELC', 'Fundação de Teleducação do Ceará', '452'],
      ['GABGOV', 'Gabinete do Governador', '111'],
      ['GABVICE', 'Gabinete do Vice-Governador', '151'],
      ['IDACE', 'Instituto de Desenvolvimento Agrário do Ceará', '602'],
      ['IPECE', 'Instituto de Pesquisa e Estratégia Econômica do Ceara', '632'],
      ['ISSEC', 'Instituto de Saúde dos Servidores do Estado do Ceará', '472'],
      ['JUCEC', 'Junta Comercial do Estado do Ceará', '672'],
      ['METROFOR', 'Companhia Cearense de Transportes Metropolitanos'],
      ['NUTEC', 'Fundação Núcleo de Tecnologia Industrial do Ceará', '682'],
      ['PC', 'Polícia Civil', '201'],
      ['PEFOCE', 'Perícia Forense do Estado do Ceará', '202'],
      ['PGE', 'Procuradoria Geral do Estado', '131'],
      ['PMCE', 'Polícia Militar', '371'],
      ['SCIDADES', 'Secretaria das Cidades', '061'],
      ['SDA', 'Secretaria do Desenvolvimento Agrário', '211'],
      ['SECITECE', 'Secretaria da Ciência, Tecnologia e Educação Superior', '321'],
      ['SEDUC', 'Secretaria da Educação', '221'],
      ['SECULT', 'Secretaria da Cultura', '271'],
      ['SEFAZ', 'Secretaria da Fazenda', '191'],
      ['SEINFRA', 'Secretaria da Infraestrutura', '391'],
      ['SEJUS', 'Secretaria da Justiça e Cidadania', '181'],
      ['SEMA', 'Secretaria Estadual do Meio Ambiente', '134'],
      ['SEMACE', 'Superintendência Estadual do Meio Ambiente', '702'],
      ['SEAS', 'Superintendência do Sistema Estadual de Atendimento Socioeducativo', '130'],
      ['SEPLAG', 'Secretaria do Planejamento e Gestão', '122'],
      ['SESA', 'Secretaria da Saúde', '241'],
      ['SESPORTE', 'Secretaria do Esporte', '081'],
      ['SETUR', 'Secretaria do Turismo', '281'],
      ['SOHIDRA', 'Superintendência de Obras Hidráulicas', '792'],
      ['SEAPA', 'Secretaria da Agricultura, Pesca e Aquicultura', '128'],
      ['SRH', 'Secretaria dos Recursos Hídricos', '291'],
      ['SSPDS', 'Secretaria da Segurança Pública e Defesa Social', '101'],
      ['STDS', 'Secretaria do Trabalho e Desenvolvimento Social', '123'],
      ['SPD', 'Secretaria Especial de Políticas sobre Drogas', '133'],
      ['SDE', 'Secretaria do Desenvolvimento Econômico', '252'],
      ['URCA', 'Fundação Universidade Regional do Cariri', '432'],
      ['UVA', 'Fundação Universidade Estadual Vale do Acaraú', '442'],
      ['UECE', 'Fundação Universidade Estadual do Ceará', '522'],
      ['ZPE', 'Companhia Administradora da Zona de Processamento de Exportação do Ceará'],
      ['CIPP S/A', 'Ceará Portos'],
      ['CEE', 'Conselho Estadual de Educação'],
      ['OEDH', 'Ouvidoria Estadual de Direitos Humanos'],
      ['SRI', 'Secretaria de Relações Institucionais'],
      ['AL', 'Assembléia Legislativa'],
      ['TCE', 'Tribunal de Contas do Estado'],
      ['TCM', 'Tribunal de Contas dos Municípios'],
      ['DPGE', 'Defensoria Pública Geral do Estado'],
      ['TJ', 'Tribunal de Justiça'],
      ['PGJ', 'Procuradoria Geral da Justiça']
    ]

    organs_data.each do |organ_data|
      organ_acronym = organ_data[0]
      organ_name = organ_data[1]
      organ_code = organ_data[2]

      organ = Organ.find_or_initialize_by(acronym: organ_acronym)
      organ.name = organ_name
      organ.code = organ_code

      organ.save
    end
  end

  task change_cpad_to_cosco: :environment do
    organ = Organ.find(17)
    organ.update(name: 'Coordenadoria de Correição', acronym: 'COSCO')
  end

  task change_coord_to_couvi: :environment do
    organ = Organ.find(107)
    organ.update(acronym: 'COUVI')
  end
end
