namespace :budget_programs do
  task create_or_update: :environment do

    budget_programs_data = [
      {
        "theme": Theme.find_by(code: 1.01),
        "code": "002",
        "name": "EDUCAÇÃO FISCAL E CIDADANIA",
        organ: Organ.find_by(acronym: 'SEFAZ')
      },
      {
        "theme": Theme.find_by(code: 1.01),
        "code": "053",
        "name": "GESTÃO FISCAL E FINANCEIRA",
        organ: Organ.find_by(acronym: 'SEFAZ')
      },
      {
        "theme": Theme.find_by(code: 1.01),
        "code": "060",
        "name": "MODERNIZAÇÃO DA GESTÃO FISCAL",
        organ: Organ.find_by(acronym: 'SEFAZ')
      },
      {
        "theme": Theme.find_by(code: 1.02),
        "code": "015",
        "name": "GOVERNANÇA DO PACTO POR UM CEARÁ PACÍFICO",
        organ: Organ.find_by(acronym: 'GABVICE')
      },
      {
        "theme": Theme.find_by(code: 1.02),
        "code": "065",
        "name": "FORTALECIMENTO DO SISTEMA ESTADUAL DE PLANEJAMENTO",
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        "theme": Theme.find_by(code: 1.02),
        "code": "069",
        "name": "MODERNIZAÇÃO DA GESTÃO PÚBLICA ESTADUAL",
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        "theme": Theme.find_by(code: 1.02),
        "code": "070",
        "name": "GESTÃO E DESENVOLVIMENTO ESTRATÉGICO DE PESSOAS",
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        "theme": Theme.find_by(code: 1.02),
        "code": "081",
        "name": "COMUNICAÇÃO INSTITUCIONAL E APOIO ÀS POLÍTICAS PÚBLICAS",
        organ: Organ.find_by(acronym: 'CV')
      },
      {
        "theme": Theme.find_by(code: 1.02),
        "code": "021",
        "name": "FORTALECIMENTO INSTITUCIONAL DOS MUNICÍPIOS",
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        "theme": Theme.find_by(code: 1.02),
        "code": "038",
        "name": "FORTALECIMENTO DAS RELAÇÕES INSTITUCIONAIS DO PODER EXECUTIVO",
        organ: Organ.find_by(acronym: 'SRI')
      },
      {
        "theme": Theme.find_by(code: 1.03),
        "code": "051",
        "name": "DESENVOLVIMENTO DA AÇÃO PARLAMENTAR",
        organ: Organ.find_by(acronym: 'AL')
      },
      {
        "theme": Theme.find_by(code: 1.03),
        "code": "014",
        "name": "CONTROLE EXTERNO DA ADMINISTRAÇÃO PÚBLICA ESTADUAL",
        organ: Organ.find_by(acronym: 'TCE')
      },
      {
        "theme": Theme.find_by(code: 1.03),
        "code": "013",
        "name": "CONTROLE EXTERNO DA ADMINISTRAÇÃO MUNICIPAL",
        organ: Organ.find_by(acronym: 'TCM')
      },
      {
        "theme": Theme.find_by(code: 1.03),
        "code": "026",
        "name": "REGULAÇÃO DOS SERVIÇOS PÚBLICOS DELEGADOS",
        organ: Organ.find_by(acronym: 'ARCE')
      },
      {
        "theme": Theme.find_by(code: 1.03),
        "code": "047",
        "name": "AUDITORIA GOVERNAMENTAL",
        organ: Organ.find_by(acronym: 'CGE')
      },
      {
        "theme": Theme.find_by(code: 1.03),
        "code": "048",
        "name": "CONTROLADORIA GOVERNAMENTAL",
        organ: Organ.find_by(acronym: 'CGE')
      },
      {
        "theme": Theme.find_by(code: 1.03),
        "code": "049",
        "name": "PARTICIPAÇÃO E CONTROLE SOCIAL",
        organ: Organ.find_by(acronym: 'CGE')
      },
      {
        "theme": Theme.find_by(code: 2.01),
        "code": "072",
        "name": "PROTEÇÃO SOCIAL ESPECIAL",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 2.01),
        "code": "073",
        "name": "IMPLEMENTAÇÃO DO SISTEMA ÚNICO DE ASSISTÊNCIA SOCIAL",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 2.01),
        "code": "080",
        "name": "PROTEÇÃO SOCIAL BÁSICA",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 2.02),
        "code": "022",
        "name": "HABITAÇÃO DE INTERESSE SOCIAL",
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        "theme": Theme.find_by(code: 2.03),
        "code": "074",
        "name": "PROMOÇÃO E UNIVERSALIZAÇÃO DO ACESSO À JUSTIÇA",
        organ: Organ.find_by(acronym: 'DPGE')
      },
      {
        "theme": Theme.find_by(code: 2.03),
        "code": "054",
        "name": "PROMOÇÃO E DEFESA DOS DIREITOS HUMANOS",
        organ: Organ.find_by(acronym: 'GABGOV')
      },
      {
        "theme": Theme.find_by(code: 2.03),
        "code": "005",
        "name": "GARANTIA DOS DIREITOS HUMANOS E CIDADANIA",
        organ: Organ.find_by(acronym: 'SEJUS')
      },
      {
        "theme": Theme.find_by(code: 2.03),
        "code": "075",
        "name": "PROTEÇÃO E PROMOÇÃO DOS DIREITOS DE ADOLESCENTES EM ATENDIMENTO SOCIOEDUCATIVO",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 2.03),
        "code": "030",
        "name": "DESENVOLVIMENTO TERRITORIAL RURAL SUSTENTÁVEL E SOLIDÁRIO",
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        "theme": Theme.find_by(code: 2.04),
        "code": "084",
        "name": "GESTÃO DA POLÍTICA DE SEGURANÇA ALIMENTAR E NUTRICIONAL",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 2.04),
        "code": "033",
        "name": "PROMOÇÃO DA SEGURANÇA ALIMENTAR E NUTRICIONAL",
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        "theme": Theme.find_by(code: 3.01),
        "code": "029",
        "name": "DESENVOLVIMENTO DA AGROPECUÁRIA FAMILIAR",
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        "theme": Theme.find_by(code: 3.01),
        "code": "035",
        "name": "DESENVOLVIMENTO SUSTENTÁVEL DO AGRONEGÓCIO",
        organ: Organ.find_by(acronym: 'SEAPA')
      },
      {
        "theme": Theme.find_by(code: 3.01),
        "code": "052",
        "name": "DEFESA AGROPECUÁRIA ATUANTE NO ESTADO DO CEARÁ",
        organ: Organ.find_by(acronym: 'SEAPA')
      },
      {
        "theme": Theme.find_by(code: 3.02),
        "code": "011",
        "name": "PROMOÇÃO DA INDÚSTRIA MINERAL",
        organ: Organ.find_by(acronym: 'SEINFRA')
      },
      {
        "theme": Theme.find_by(code: 3.02),
        "code": "041",
        "name": "PROMOÇÃO E DESENVOLVIMENTO DA INDÚSTRIA CEARENSE",
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        "theme": Theme.find_by(code: 3.03),
        "code": "042",
        "name": "FORTALECIMENTO DO SETOR DE SERVIÇOS",
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        "theme": Theme.find_by(code: 3.04),
        "code": "010",
        "name": "INFRAESTRUTURA E LOGÍSTICA",
        organ: Organ.find_by(acronym: 'SEINFRA')
      },
      {
        "theme": Theme.find_by(code: 3.04),
        "code": "019",
        "name": "MOBILIDADE URBANA",
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        "theme": Theme.find_by(code: 3.04),
        "code": "037",
        "name": "GESTÃO E DISCIPLINAMENTO DO TRÂNSITO",
        organ: Organ.find_by(acronym: 'DETRAN')
      },
      {
        "theme": Theme.find_by(code: 3.05),
        "code": "028",
        "name": "DESENVOLVIMENTO E CONSOLIDAÇÃO DO DESTINO TURISTICO CEARÁ",
        organ: Organ.find_by(acronym: 'SETUR')
      },
      {
        "theme": Theme.find_by(code: 3.06),
        "code": "078",
        "name": "INCLUSÃO E DESENVOLVIMENTO DO TRABALHADOR",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 3.06),
        "code": "083",
        "name": "DESENVOLVIMENTO DO ARTESANATO",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 3.06),
        "code": "031",
        "name": "INCLUSÃO ECONÔMICA E ENFRENTAMENTO À POBREZA RURAL",
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        "theme": Theme.find_by(code: 3.07),
        "code": "082",
        "name": "EMPREENDEDORISMO E ECONOMIA SOLIDÁRIA",
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        "theme": Theme.find_by(code: 3.07),
        "code": "043",
        "name": "EMPREENDEDORISMO E PROTAGONISMO JUVENIL",
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        "theme": Theme.find_by(code: 3.08),
        "code": "034",
        "name": "DESENVOLVIMENTO INTEGRADO E SUSTENTÁVEL DA PESCA E AQUICULTURA",
        organ: Organ.find_by(acronym: 'SEAPA')
      },
      {
        "theme": Theme.find_by(code: 3.09),
        "code": "040",
        "name": "MELHORIA DE ESPAÇOS E EQUIPAMENTOS PÚBLICOS",
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        "theme": Theme.find_by(code: 4.01),
        "code": "016",
        "name": "OFERTA HÍDRICA PARA MÚLTIPLOS USOS",
        organ: Organ.find_by(acronym: 'SRH')
      },
      {
        "theme": Theme.find_by(code: 4.01),
        "code": "017",
        "name": "GESTÃO DOS RECURSOS HÍDRICOS",
        organ: Organ.find_by(acronym: 'SRH')
      },
      {
        "theme": Theme.find_by(code: 4.01),
        "code": "018",
        "name": "CLIMATOLOGIA, MEIO AMBIENTE E ENERGIAS RENOVÁVEIS",
        organ: Organ.find_by(acronym: 'FUNCEME')
      },
      {
        "theme": Theme.find_by(code: 4.02),
        "code": "027",
        "name": "REVITALIZAÇÃO DE ÁREAS DEGRADADAS",
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        "theme": Theme.find_by(code: 4.02),
        "code": "064",
        "name": "RESÍDUOS SÓLIDOS",
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        "theme": Theme.find_by(code: 4.02),
        "code": "066",
        "name": "CEARÁ MAIS VERDE",
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        "theme": Theme.find_by(code: 4.02),
        "code": "067",
        "name": "CEARÁ NO CLIMA",
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        "theme": Theme.find_by(code: 4.02),
        "code": "068",
        "name": "CEARA CONSCIENTE POR NATUREZA",
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        "theme": Theme.find_by(code: 4.03),
        "code": "009",
        "name": "MATRIZ ENERGÉTICA DO ESTADO DO CEARÁ",
        organ: Organ.find_by(acronym: 'SEINFRA')
      },
      {
        "theme": Theme.find_by(code: 5.01),
        "code": "079",
        "name": "GESTÃO DE POLÍTICAS PÚBLICAS DA EDUCAÇÃO",
        organ: Organ.find_by(acronym: 'CEE')
      },
      {
        "theme": Theme.find_by(code: 5.01),
        "code": "006",
        "name": "INCLUSÃO E EQUIDADE NA EDUCAÇÃO",
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        "theme": Theme.find_by(code: 5.01),
        "code": "008",
        "name": "ACESSO E APRENDIZAGEM DAS CRIANÇAS E JOVENS NA IDADE ADEQUADA",
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        "theme": Theme.find_by(code: 5.01),
        "code": "023",
        "name": "GESTÃO E DESENVOLVIMENTO DA EDUCAÇÃO BÁSICA",
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        "theme": Theme.find_by(code: 5.02),
        "code": "020",
        "name": "ENSINO INTEGRADO À EDUCAÇÃO PROFISSIONAL",
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        "theme": Theme.find_by(code: 5.02),
        "code": "058",
        "name": "DESENVOLVIMENTO DA EDUCAÇÃO PROFISSIONAL NOS NÍVEIS: FORMAÇÃO INICIAL E CONTINUADA, TÉCNICO E TECNOLÓGICO",
        organ: Organ.find_by(acronym: 'SECITECE')
      },
      {
        "theme": Theme.find_by(code: 5.03),
        "code": "071",
        "name": "GESTÃO E DESENVOLVIMENTO DA EDUCAÇÃO SUPERIOR",
        organ: Organ.find_by(acronym: 'SECITECE')
      },
      {
        "theme": Theme.find_by(code: 5.04),
        "code": "063",
        "name": "TECNOLOGIA DA INFORMAÇÃO E COMUNICAÇÃO ESTRATÉGICA DO CEARÁ",
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        "theme": Theme.find_by(code: 5.04),
        "code": "061",
        "name": "DESENVOLVIMENTO DA PRODUÇÃO CIENTÍFICA, DA DIFUSÃO TECNOLÓGICA, E DA CULTURA DE INOVAÇÃO",
        organ: Organ.find_by(acronym: 'SECITECE')
      },
      {
        "theme": Theme.find_by(code: 5.05),
        "code": "044",
        "name": "PROMOÇÃO DO ACESSO E FOMENTO À PRODUÇÃO E DIFUSÃO DA CULTURA CEARENSE",
        organ: Organ.find_by(acronym: 'SECULT')
      },
      {
        "theme": Theme.find_by(code: 5.05),
        "code": "045",
        "name": "PRESERVAÇÃO E PROMOÇÃO DA MEMÓRIA E DO PATRIMÔNIO CULTURAL CEARENSE",
        organ: Organ.find_by(acronym: 'SECULT')
      },
      {
        "theme": Theme.find_by(code: 5.05),
        "code": "046",
        "name": "FORTALECIMENTO DO SISTEMA ESTADUAL DE CULTURA DO CEARÁ",
        organ: Organ.find_by(acronym: 'SECULT')
      },
      {
        "theme": Theme.find_by(code: 5.05),
        "code": "077",
        "name": "TELEDIFUSÃO CULTURAL E INFORMATIVA",
        organ: Organ.find_by(acronym: 'FUNTELC')
      },
      {
        "theme": Theme.find_by(code: 6.01),
        "code": "055",
        "name": "FORTALECIMENTO DA GESTÃO, PARTICIPAÇÃO, CONTROLE SOCIAL E DESENVOLVIMENTO INSTITUCIONAL DO SUS",
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        "theme": Theme.find_by(code: 6.01),
        "code": "056",
        "name": "VIGILÂNCIA EM SAÚDE",
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        "theme": Theme.find_by(code: 6.01),
        "code": "057",
        "name": "ATENÇÃO À SAÚDE INTEGRAL E DE QUALIDADE",
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        "theme": Theme.find_by(code: 6.01),
        "code": "076",
        "name": "GESTÃO DO TRABALHO, DA EDUCAÇÃO E DA CIÊNCIA E TECNOLOGIA NA SAÚDE",
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        "theme": Theme.find_by(code: 6.02),
        "code": "050",
        "name": "ESPORTE E LAZER PARA A POPULAÇÃO",
        organ: Organ.find_by(acronym: 'SESPORTE')
      },
      {
        "theme": Theme.find_by(code: 6.02),
        "code": "086",
        "name": "CEARÁ NO ESPORTE DE RENDIMENTO",
        organ: Organ.find_by(acronym: 'SESPORTE')
      },
      {
        "theme": Theme.find_by(code: 6.03),
        "code": "032",
        "name": "ABASTECIMENTO DE ÁGUA E ESGOTAMENTO SANITÁRIO NO MEIO RURAL",
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        "theme": Theme.find_by(code: 6.03),
        "code": "025",
        "name": "ABASTECIMENTO DE ÁGUA, ESGOTAMENTO SANITÁRIO E DRENAGEM URBANA",
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        "theme": Theme.find_by(code: 7.01),
        "code": "001",
        "name": "GESTÃO DE RISCOS E DESASTRES",
        organ: Organ.find_by(acronym: 'SSPDS')
      },
      {
        "theme": Theme.find_by(code: 7.01),
        "code": "003",
        "name": "SEGURANÇA PÚBLICA INTEGRADA",
        organ: Organ.find_by(acronym: 'SSPDS')
      },
      {
        "theme": Theme.find_by(code: 7.01),
        "code": "007",
        "name": "SEGURANÇA PÚBLICA CIDADÃ",
        organ: Organ.find_by(acronym: 'SSPDS')
      },
      {
        "theme": Theme.find_by(code: 7.01),
        "code": "024",
        "name": "CONTROLE DISCIPLINAR DOS SISTEMAS DE SEGURANÇA PÚBLICA E PENITENCIÁRIO",
        organ: Organ.find_by(acronym: 'CGD')
      },
      {
        "theme": Theme.find_by(code: 7.02),
        "code": "036",
        "name": "EXCELÊNCIA NO DESEMPENHO DA PRESTAÇÃO JURISDICIONAL",
        organ: Organ.find_by(acronym: 'TJ')
      },
      {
        "theme": Theme.find_by(code: 7.02),
        "code": "039",
        "name": "INTEGRAÇÃO DO SISTEMA DE JUSTIÇA CRIMINAL (INTEGRA)",
        organ: Organ.find_by(acronym: 'TJ')
      },
      {
        "theme": Theme.find_by(code: 7.02),
        "code": "012",
        "name": "TUTELA DOS INTERESSES SOCIAIS E INDIVIDUAIS INDISPONÍVEIS",
        organ: Organ.find_by(acronym: 'PGJ')
      },
      {
        "theme": Theme.find_by(code: 7.02),
        "code": "004",
        "name": "INFRAESTRUTURA E GESTÃO DO SISTEMA PENITENCIÁRIO",
        organ: Organ.find_by(acronym: 'SEJUS')
      },
      {
        "theme": Theme.find_by(code: 7.03),
        "code": "085",
        "name": "PROTEÇÃO CONTRA O USO PREJUDICIAL DE DROGAS",
        organ: Organ.find_by(acronym: 'SPD')
      },


      #
      # programas orgamentários que não estão no pdf relacionado com tema
      #
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DO GABGOV'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DO GABVICE'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA PGE E VINCULADA'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SRH E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA CASA CIVIL E VINCULADA'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SECITECE E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SESPORTE'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA CIDADES E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SEPLAG E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA STDS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SPD'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SDE E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SEMA E VINCULADA'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SSPDS E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SEINFRA E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA DPGE'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DO TCM'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA CGD'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SEAPA E VINCULADA'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA CGE'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SETUR'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SECULT'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SESA E VINCULADA'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SEDUC E VINCULADA'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SDA E VINCULADAS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SEFAZ E VINCULADA'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA SEJUS'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DO CEE'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA PGJ'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DO TJ'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DA AL'
      },
      {
        code: 500,
        name: 'GESTÃO E MANUTENÇÃO DO TCE'
      },
      {
        code: 999,
        name: 'RESERVA DE CONTINGÊNCIA'
      },

      # Outros poderes da classificação
      {
        "code": 9999,
        "name": 'Outros',
        "other_organs": true
      }
   ]

    budget_programs_data.each do |budget_program_data|
      budget_program = BudgetProgram.find_or_initialize_by(name: budget_program_data[:name])
      budget_program.update_attributes!(budget_program_data)
    end
  end
end
