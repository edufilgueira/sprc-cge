namespace :departments do
  task create_or_update: :environment do

    departments_data = [
      {
        name: 'CONSELHO CONSULTIVO',
        acronym: 'CONSU',
        organ: Organ.find_by(acronym: 'ADAGRI')
      },
      {
        name: 'CONSELHO FISCAL',
        acronym: 'CONFI',
        organ: Organ.find_by(acronym: 'ADAGRI')
      },
      {
        name: 'DIRETORIA COLEGIADA',
        acronym: 'DICOL',
        organ: Organ.find_by(acronym: 'ADAGRI')
      },
      {
        name: 'DIRETORIA DE PLANEJAMENTO E GESTÃO',
        acronym: 'DIPLAG',
        organ: Organ.find_by(acronym: 'ADAGRI')
      },
      {
        name: 'DIRETORIA DE SANIDADE ANIMAL',
        acronym: 'DISAN',
        organ: Organ.find_by(acronym: 'ADAGRI')
      },


      {
        name: 'ASSESSORIA CONTÁBIL',
        acronym: 'ASCONT',
        organ: Organ.find_by(acronym: 'ADECE')
      },
      {
        name: 'ASSESSORIA EXECUTIVA',
        acronym: 'ASSEC',
        organ: Organ.find_by(acronym: 'ADECE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'ADECE')
      },
      {
        name: 'ASSESSORIA TÉCNICA',
        acronym: 'ASTEC',
        organ: Organ.find_by(acronym: 'ADECE')
      },
      {
        name: 'DIRETORIA DE AGRONEGÓCIO',
        acronym: 'DIAGRO',
        organ: Organ.find_by(acronym: 'ADECE')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO SOCIAL',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'AESP/CE')
      },
      {
        name: 'ASSESSORIA DE PLANEJAMENTO E GESTÃO',
        acronym: 'ASPLAG',
        organ: Organ.find_by(acronym: 'AESP/CE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'AESP/CE')
      },
      {
        name: 'CÉLULA DE ADMINISTRAÇÃO',
        acronym: 'CELAD',
        organ: Organ.find_by(acronym: 'AESP/CE')
      },
      {
        name: 'CÉLULA DE ALTOS ESTUDOS DE SEGURANÇA PÚBLICA',
        acronym: 'CAESP',
        organ: Organ.find_by(acronym: 'AESP/CE')
      },


      {
        name: 'CONSELHO DIRETOR',
        acronym: 'CDR',
        organ: Organ.find_by(acronym: 'ARCE')
      },
      {
        name: 'COORDENADORIA DE ENERGIA',
        acronym: 'CEE',
        organ: Organ.find_by(acronym: 'ARCE')
      },
      {
        name: 'COORDENADORIA DE PLANEJAMENTO E INFORMAÇÃO REGULATÓRIA',
        acronym: 'CPR',
        organ: Organ.find_by(acronym: 'ARCE')
      },
      {
        name: 'COORDENADORIA DE SANEAMENTO BÁSICO',
        acronym: 'CSB',
        organ: Organ.find_by(acronym: 'ARCE')
      },
      {
        name: 'COORDENADORIA DE TRANSPORTES',
        acronym: 'CTR',
        organ: Organ.find_by(acronym: 'ARCE')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'CAGECE')
      },
      {
        name: 'ASSESSORIA DE CONTROLE ADMINISTRATIVO',
        acronym: 'ASCAD',
        organ: Organ.find_by(acronym: 'CAGECE')
      },
      {
        name: 'ASSESSORIA DE LICITAÇÕES',
        acronym: 'ASLIC',
        organ: Organ.find_by(acronym: 'CAGECE')
      },
      {
        name: 'AUDITORIA E CONTROLES INTERNAS',
        acronym: 'AUDIN',
        organ: Organ.find_by(acronym: 'CAGECE')
      },
      {
        name: 'CENTRO DE EXCELÊNCIA',
        acronym: 'CENEX',
        organ: Organ.find_by(acronym: 'CAGECE')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: '',
        organ: Organ.find_by(acronym: 'CM')
      },
      {
        name: 'ASSESSORIA DE SAÚDE E ASSISTÊNCIA SOCIAL',
        acronym: '',
        organ: Organ.find_by(acronym: 'CM')
      },
      {
        name: 'ASSESSORIA ESTRATÉGICA',
        acronym: '',
        organ: Organ.find_by(acronym: 'CM')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: '',
        organ: Organ.find_by(acronym: 'CM')
      },
      {
        name: 'CÉLULA DE TECNOLOGIA DA INFORMAÇÃO E COMUNICAÇÃO',
        acronym: '',
        organ: Organ.find_by(acronym: 'CM')
      },


      {
        name: '1º GRUPAMENTO DE BOMBEIRO',
        acronym: '1º GRUPA',
        organ: Organ.find_by(acronym: 'CBMCE')
      },
      {
        name: '2º GRUPAMENTO DE BOMBEIRO',
        acronym: '2º GRUPA',
        organ: Organ.find_by(acronym: 'CBMCE')
      },
      {
        name: '3º GRUPAMENTO DE BOMBEIRO',
        acronym: '3º GRUPA',
        organ: Organ.find_by(acronym: 'CBMCE')
      },
      {
        name: '4º GRUPAMENTO DE BOMBEIRO',
        acronym: '4º GRUPA',
        organ: Organ.find_by(acronym: 'CBMCE')
      },
      {
        name: '5º GRUPAMENTO DE BOMBEIRO',
        acronym: '5º GRUPA',
        organ: Organ.find_by(acronym: 'CBMCE')
      },


      {
        name: 'ASSESSORIA EXECUTIVA',
        acronym: 'ASSEC',
        organ: Organ.find_by(acronym: 'CEARÁ PORTOS')
      },
      {
        name: 'COORDENADORIA DE ARTICULAÇÃO ADMINISTRATIVA',
        acronym: '',
        organ: Organ.find_by(acronym: 'CEARÁ PORTOS')
      },
      {
        name: 'COORDENADORIA DE COMERCIAL, PLANEJAMENTO E COMUNICAÇÃO SOCIAL',
        acronym: '',
        organ: Organ.find_by(acronym: 'CEARÁ PORTOS')
      },
      {
        name: 'COORDENADORIA DE DESENVOLVIMENTO DE INFRAESTRUTURA E SUPERESTRUTURA PORTUÁRIA',
        acronym: '',
        organ: Organ.find_by(acronym: 'CEARÁ PORTOS')
      },
      {
        name: 'COORDENADORIA DE ENGENHARIA E PROJETOS',
        acronym: '',
        organ: Organ.find_by(acronym: 'CEARÁ PORTOS')
      },


      {
        name: 'ASSEMBLÉIA GERAL',
        acronym: 'ASSEG',
        organ: Organ.find_by(acronym: 'CEASA')
      },
      {
        name: 'ASSESSORIA DE COMUNICAÇÃO E MARKETING',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'CEASA')
      },
      {
        name: 'ASSESSORIA DE CONTROLE INTERNO',
        acronym: '',
        organ: Organ.find_by(acronym: 'CEASA')
      },
      {
        name: 'ASSESSORIA DE IMPRENSA',
        acronym: 'ASIMP',
        organ: Organ.find_by(acronym: 'CEASA')
      },
      {
        name: 'ASSESSORIA ESPECIAL DE SEGURANÇA E LIMPEZA',
        acronym: 'ASSESL',
        organ: Organ.find_by(acronym: 'CEASA')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: '',
        organ: Organ.find_by(acronym: 'CED')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: '',
        organ: Organ.find_by(acronym: 'CED')
      },
      {
        name: 'COORDENADORIA ADMINISTRATIVO- FINANCEIRA',
        acronym: '',
        organ: Organ.find_by(acronym: 'CED')
      },
      {
        name: 'COORDENADORIA DE APOIO PEDAGÓGICO',
        acronym: '',
        organ: Organ.find_by(acronym: 'CED')
      },
      {
        name: 'DIRETORIA',
        acronym: '',
        organ: Organ.find_by(acronym: 'CED')
      },


      {
        name: 'ASSEMBLÉIA GERAL',
        acronym: 'ASSEG',
        organ: Organ.find_by(acronym: 'CEGÁS')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'CEGÁS')
      },
      {
        name: 'AUDITORIA INTERNA',
        acronym: 'AUDIN',
        organ: Organ.find_by(acronym: 'CEGÁS')
      },
      {
        name: 'CONSELHO DE ADMINISTRAÇÃO',
        acronym: 'CONAD',
        organ: Organ.find_by(acronym: 'CEGÁS')
      },
      {
        name: 'CONSELHO FISCAL',
        acronym: 'CONFIS',
        organ: Organ.find_by(acronym: 'CEGÁS')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'CGD')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'CGD')
      },
      {
        name: 'CÉLULA DE ATIVIDADE DE CAMPO',
        acronym: 'CEAC',
        organ: Organ.find_by(acronym: 'CGD')
      },
      {
        name: 'CÉLULA DE CONSELHO DE DISCIPLINA MILITAR',
        acronym: 'CEDIM',
        organ: Organ.find_by(acronym: 'CGD')
      },
      {
        name: 'CÉLULA DE CONSELHO DE JUSTIFICAÇÃO MILITAR',
        acronym: 'CEJUM',
        organ: Organ.find_by(acronym: 'CGD')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'CGE')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'CGE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'CGE')
      },
      {
        name: 'CÉLULA DE ACOMPANHAMENTO DAS CONTAS DE GOVERNO',
        acronym: 'CECON',
        organ: Organ.find_by(acronym: 'CGE')
      },
      {
        name: 'CÉLULA DE APURAÇÃO DE OUVIDORIA',
        acronym: 'CEAPO',
        organ: Organ.find_by(acronym: 'CGE')
      },


      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIAFI',
        organ: Organ.find_by(acronym: 'CODECE')
      },
      {
        name: 'DIRETORIA DE DESENVOLVIMENTO DE NEGÓCIOS',
        acronym: 'DIRDEN',
        organ: Organ.find_by(acronym: 'CODECE')
      },
      {
        name: 'DIRETORIA DE MINERAÇÃO',
        acronym: 'DIRMIN',
        organ: Organ.find_by(acronym: 'CODECE')
      },
      {
        name: 'DIRETOR PRESIDENTE',
        acronym: 'PRES',
        organ: Organ.find_by(acronym: 'CODECE')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO E MARKETING',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'COGERH')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'COGERH')
      },
      {
        name: 'AUDITORIA INTERNA',
        acronym: 'AUDIN',
        organ: Organ.find_by(acronym: 'COGERH')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVA E FINANCEIRA',
        acronym: 'DIAFI',
        organ: Organ.find_by(acronym: 'COGERH')
      },
      {
        name: 'DIRETORIA DE OPERAÇÕES',
        acronym: 'DIOPE',
        organ: Organ.find_by(acronym: 'COGERH')
      },


      {
        name: 'AUDITORIA INTERNA',
        acronym: 'AUDIN',
        organ: Organ.find_by(acronym: 'DAE')
      },
      {
        name: 'CONSELHO DELIBERATIVO',
        acronym: 'CD',
        organ: Organ.find_by(acronym: 'DAE')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIRAF',
        organ: Organ.find_by(acronym: 'DAE')
      },
      {
        name: 'DIRETORIA DE ARQUITETURA',
        acronym: 'DIARQ',
        organ: Organ.find_by(acronym: 'DAE')
      },
      {
        name: 'DIRETORIA DE ENGENHARIA',
        acronym: 'DIREN',
        organ: Organ.find_by(acronym: 'DAE')
      },


      {
        name: 'AUDITORIA INTERNA',
        acronym: 'AUDIN',
        organ: Organ.find_by(acronym: 'DER')
      },
      {
        name: 'CÉLULA CONTROLE DE FINANCEIRO',
        acronym: 'CECOF',
        organ: Organ.find_by(acronym: 'DER')
      },
      {
        name: 'CÉLULA DE ANÁLISE E CONSOLIDAÇÃO DE INFORMAÇÕES',
        acronym: 'CEINF',
        organ: Organ.find_by(acronym: 'DER')
      },
      {
        name: 'CÉLULA DE APOIO LOGÍSTICO',
        acronym: 'CELAL',
        organ: Organ.find_by(acronym: 'DER')
      },
      {
        name: 'CÉLULA DE AVALIAÇÃO E DESAPROPRIAÇÃO DE IMÓVEIS',
        acronym: 'CADIM',
        organ: Organ.find_by(acronym: 'DER')
      },


      {
        name: 'ASSESSORIA DE IMPRENSA E COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'DETRAN')
      },
      {
        name: 'COMISSÃO DE JULGAMENTO DA CONSISTÊNCIA DO AUTO DE INFRAÇÃO',
        acronym: 'COJAI',
        organ: Organ.find_by(acronym: 'DETRAN')
      },
      {
        name: 'COMISSÃO PERMANENTE DE AUDITORIA',
        acronym: 'COAUD',
        organ: Organ.find_by(acronym: 'DETRAN')
      },
      {
        name: 'COMISSÃO PERMANENTE DE PROCESSO ADMINISTRATIVO DISCIPLINAR',
        acronym: 'COPAD',
        organ: Organ.find_by(acronym: 'DETRAN')
      },
      {
        name: 'CONSELHO DE COORDENAÇÃO ADMINISTRATIVA',
        acronym: 'CCA',
        organ: Organ.find_by(acronym: 'DETRAN')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'EGP')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'EGP')
      },
      {
        name: 'ASSESSORIA JURÍDICA E INSTITUCIONAL',
        acronym: 'ASJURI',
        organ: Organ.find_by(acronym: 'EGP')
      },
      {
        name: 'CÉLULA ADMINISTRATIVA',
        acronym: 'CESAD',
        organ: Organ.find_by(acronym: 'EGP')
      },
      {
        name: 'CÉLULA ADMINISTRATIVA-FINANCEIRA',
        acronym: 'CEAFI',
        organ: Organ.find_by(acronym: 'EGP')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'EMATERCE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'EMATERCE')
      },
      {
        name: 'AUDITORIA',
        acronym: 'AUDIT',
        organ: Organ.find_by(acronym: 'EMATERCE')
      },
      {
        name: 'AUDITORIA INTERNA',
        acronym: 'AUDIN',
        organ: Organ.find_by(acronym: 'EMATERCE')
      },
      {
        name: 'CENTRO DE ATENDIMENTO AOS CLIENTES',
        acronym: 'CEAC-ACARAÚ',
        organ: Organ.find_by(acronym: 'EMATERCE')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'ESP')
      },
      {
        name: 'CENTRO DE COORDENAÇÃO DE RESIDÊNCIA MÉDICA',
        acronym: 'CERME',
        organ: Organ.find_by(acronym: 'ESP')
      },
      {
        name: 'CENTRO DE DESENVOLVIMENTO EDUCACIONAL EM SAÚDE',
        acronym: 'CEDES',
        organ: Organ.find_by(acronym: 'ESP')
      },
      {
        name: 'CENTRO DE DOCUMENTAÇÃO E BIBLIOTECA',
        acronym: 'CEDOB',
        organ: Organ.find_by(acronym: 'ESP')
      },
      {
        name: 'CENTRO DE EDUCAÇÃO PERMANENTE EM ATENÇÃO À SAÚDE',
        acronym: 'CEPEA',
        organ: Organ.find_by(acronym: 'ESP')
      },


      {
        name: 'ASSESSORIA DE INOVAÇÃO TECNOLÓGICA',
        acronym: 'ASINT',
        organ: Organ.find_by(acronym: 'ETICE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'ETICE')
      },
      {
        name: 'DIRETORIA DE CIDADANIA ELETRÔNICA',
        acronym: 'DICEL',
        organ: Organ.find_by(acronym: 'ETICE')
      },
      {
        name: 'DIRETORIA DE CONTROLADORIA',
        acronym: 'DICON',
        organ: Organ.find_by(acronym: 'ETICE')
      },
      {
        name: 'DIRETORIA DE PESSOAL E LOGÍSTICA',
        acronym: 'DIPEL',
        organ: Organ.find_by(acronym: 'ETICE')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'FUNCAP')
      },
      {
        name: 'CONSELHO DE ADMINISTRAÇÃO',
        acronym: 'CONAD',
        organ: Organ.find_by(acronym: 'FUNCAP')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIRAF',
        organ: Organ.find_by(acronym: 'FUNCAP')
      },
      {
        name: 'DIRETORIA CIENTÍFICA',
        acronym: 'DIREC',
        organ: Organ.find_by(acronym: 'FUNCAP')
      },
      {
        name: 'DIRETORIA DE INOVAÇÃO',
        acronym: 'DINOV',
        organ: Organ.find_by(acronym: 'FUNCAP')
      },


      {
        name: 'ASSESSORIA DE PLANEJAMENTO',
        acronym: 'ASPLAN',
        organ: Organ.find_by(acronym: 'FUNCEME')
      },
      {
        name: 'CONSELHO DE ADMINISTRAÇÃO',
        acronym: 'CONAD',
        organ: Organ.find_by(acronym: 'FUNCEME')
      },
      {
        name: 'CONSELHO FISCAL',
        acronym: 'CONFI',
        organ: Organ.find_by(acronym: 'FUNCEME')
      },
      {
        name: 'CONSELHO TÉCNICO-CIENTÍFICO',
        acronym: 'CONTEC',
        organ: Organ.find_by(acronym: 'FUNCEME')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIAFI',
        organ: Organ.find_by(acronym: 'FUNCEME')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'FUNTELC')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIAF',
        organ: Organ.find_by(acronym: 'FUNTELC')
      },
      {
        name: 'DIRETORIA DE PROGRAMAÇÃO',
        acronym: 'DIPRO',
        organ: Organ.find_by(acronym: 'FUNTELC')
      },
      {
        name: 'DIRETORIA TÉCNICA',
        acronym: 'DITEC',
        organ: Organ.find_by(acronym: 'FUNTELC')
      },
      {
        name: 'GERÊNCIA ADMINISTRATIVA',
        acronym: 'GERAD',
        organ: Organ.find_by(acronym: 'FUNTELC')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'GABGOV')
      },
      {
        name: 'ASSESSORIA DO GABINETE',
        acronym: 'ASGAB',
        organ: Organ.find_by(acronym: 'GABGOV')
      },
      {
        name: 'ASSESSORIA ESPECIAL DE ACOLHIMENTO AOS MOVIMENTOS SOCIAIS',
        acronym: 'ASMOV',
        organ: Organ.find_by(acronym: 'GABGOV')
      },
      {
        name: 'ASSESSORIA ESPECIAL DO GOVERNADOR',
        acronym: 'ASGOV',
        organ: Organ.find_by(acronym: 'GABGOV')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'GABGOV')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'GABVICE')
      },
      {
        name: 'ASSESSORIA DO GABINETE',
        acronym: 'ASGAB',
        organ: Organ.find_by(acronym: 'GABVICE')
      },
      {
        name: 'ASSESSORIA DO ORÇAMENTO PARTICIPATIVO',
        acronym: 'ASORP',
        organ: Organ.find_by(acronym: 'GABVICE')
      },
      {
        name: 'ASSESSORIA ESPECIAL DE PROGRAMAS E PROJETOS',
        acronym: 'ASPRO',
        organ: Organ.find_by(acronym: 'GABVICE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'GABVICE')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'IDACE')
      },
      {
        name: 'CÉLULA DE CARTOGRAFIA, GEOPROCESSAMENTO E DIAGNÓSTICO FUNDIÁRIO',
        acronym: 'CEGED',
        organ: Organ.find_by(acronym: 'IDACE')
      },
      {
        name: 'CÉLULA DE DESENVOLVIMENTO FUNDIÁRIO',
        acronym: 'CEDEF',
        organ: Organ.find_by(acronym: 'IDACE')
      },
      {
        name: 'CÉLULA DE GESTÃO FUNDIÁRIA',
        acronym: 'CEGEF',
        organ: Organ.find_by(acronym: 'IDACE')
      },
      {
        name: 'CONSELHO DE ADMINISTRAÇÃO',
        acronym: 'CONAD',
        organ: Organ.find_by(acronym: 'IDACE')
      },


      {
        name: 'DIRETORIA DE ESTUDOS ECONOMICOS',
        acronym: 'DIEC',
        organ: Organ.find_by(acronym: 'IPECE')
      },
      {
        name: 'DIRETORIA DE ESTUDOS SOCIAIS',
        acronym: 'DISOC',
        organ: Organ.find_by(acronym: 'IPECE')
      },
      {
        name: 'DIRETORIA GERAL',
        acronym: 'DIGER',
        organ: Organ.find_by(acronym: 'IPECE')
      },
      {
        name: 'GERÊNCIA DE ESTATÍSTICA, GEOGRAFIA E INFORMAÇÕES',
        acronym: 'GEGIN',
        organ: Organ.find_by(acronym: 'IPECE')
      },
      {
        name: 'GERÊNCIA DE SUPORTE ADMINISTRATIVO-FINANCEIRO',
        acronym: 'GERAD',
        organ: Organ.find_by(acronym: 'IPECE')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'ISSEC')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIRAF',
        organ: Organ.find_by(acronym: 'ISSEC')
      },
      {
        name: 'DIRETORIA TÉCNICA DE SAÚDE',
        acronym: 'DITES',
        organ: Organ.find_by(acronym: 'ISSEC')
      },
      {
        name: 'GERÊNCIA ADMINISTRATIVA',
        acronym: 'GERAD',
        organ: Organ.find_by(acronym: 'ISSEC')
      },
      {
        name: 'GERÊNCIA DE AUTORIZAÇÃO DE PROCEDIMENTOS',
        acronym: 'GEPRO',
        organ: Organ.find_by(acronym: 'ISSEC')
      },


      {
        name: 'CÉLULA ADMINISTRATIVO FINANCEIRA',
        acronym: 'CEAFI',
        organ: Organ.find_by(acronym: 'JUCEC')
      },
      {
        name: 'CÉLULA DE ANÁLISE TÉCNICA EM REGISTRO MERCANTIL',
        acronym: 'CEATE',
        organ: Organ.find_by(acronym: 'JUCEC')
      },
      {
        name: 'CÉLULA DE TECNOLOGIA DA INFORMAÇÃO E COMUNICAÇÃO',
        acronym: 'CETEI',
        organ: Organ.find_by(acronym: 'JUCEC')
      },
      {
        name: 'NÚCLEO DE ADMINISTRAÇÃO DE MATERIAL E PATRIMONIO',
        acronym: 'NUPAT',
        organ: Organ.find_by(acronym: 'JUCEC')
      },
      {
        name: 'NÚCLEO DE APOIO A PROJETOS ESPECIAIS',
        acronym: 'NUAPE',
        organ: Organ.find_by(acronym: 'JUCEC')
      },


      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'METROFOR')
      },
      {
        name: 'ASSESSORIA TÉCNICA',
        acronym: 'ASTEC',
        organ: Organ.find_by(acronym: 'METROFOR')
      },
      {
        name: 'AUDITORIA INTERNA',
        acronym: 'AUDIN',
        organ: Organ.find_by(acronym: 'METROFOR')
      },
      {
        name: 'DIRETORIA DE DESENVOLVIMENTO E TECNOLOGIA',
        acronym: 'DET',
        organ: Organ.find_by(acronym: 'METROFOR')
      },
      {
        name: 'DIRETORIA DE GESTÃO EMPRESARIAL',
        acronym: 'DIGEM',
        organ: Organ.find_by(acronym: 'METROFOR')
      },


      {
        name: 'ASSESSORIA DA QUALIDADE',
        acronym: 'ASQUA',
        organ: Organ.find_by(acronym: 'NUTEC')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'NUTEC')
      },
      {
        name: 'ASSESSORIA DE RELAÇÕES INSTITUCIONAIS',
        acronym: 'ASSIN',
        organ: Organ.find_by(acronym: 'NUTEC')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIAFI',
        organ: Organ.find_by(acronym: 'NUTEC')
      },
      {
        name: 'DIRETORIA DE EMPREENDEDORISMO E NEGÓCIOS',
        acronym: 'DIREN',
        organ: Organ.find_by(acronym: 'NUTEC')
      },


      {
        name: 'ACADEMIA DA POLÍCIA CIVIL DELEGADO WALDEMAR GIRÃO MAIA',
        acronym: 'APOC',
        organ: Organ.find_by(acronym: 'PC')
      },
      {
        name: 'ALMOXARIFADO',
        acronym: 'ALMOX',
        organ: Organ.find_by(acronym: 'PC')
      },
      {
        name: 'ASSESSORIA DE PLANEJAMENTO E COORDENAÇÃO',
        acronym: 'APC',
        organ: Organ.find_by(acronym: 'PC')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'PC')
      },
      {
        name: 'CARTORIO',
        acronym: 'CART-CAM',
        organ: Organ.find_by(acronym: 'PC')
      },


      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'PEFOCE')
      },
      {
        name: 'COORDENADORIA DE ANÁLISES LABORATÓRIAIS FORENSES',
        acronym: 'CALF',
        organ: Organ.find_by(acronym: 'PEFOCE')
      },
      {
        name: 'COORDENADORIA DE IDENTIFICAÇÃO HUMANA E PERÍCIAS BIOMÉTRICAS',
        acronym: 'CIHPB',
        organ: Organ.find_by(acronym: 'PEFOCE')
      },
      {
        name: 'COORDENADORIA DE MEDICINA-LEGAL',
        acronym: 'COMEL',
        organ: Organ.find_by(acronym: 'PEFOCE')
      },
      {
        name: 'COORDENADORIA DE PERÍCIA CRIMINAL',
        acronym: 'COPEC',
        organ: Organ.find_by(acronym: 'PEFOCE')
      },


      {
        name: 'ASSESSORIA DE ACOMPANHAMENTO DE PUBLICAÇÕES DE INTIMAÇÕES E NOTIFICAÇÕES',
        acronym: 'ASAPIN',
        organ: Organ.find_by(acronym: 'PGE')
      },
      {
        name: 'ASSESSORIA DE ANÁLISE, ELABORAÇÃO E REVISÃO DE CÁLCULOS JUDICIAIS E EXTRAJUDICIAIS',
        acronym: 'ACJ',
        organ: Organ.find_by(acronym: 'PGE')
      },
      {
        name: 'ASSESSORIA DE COMUNICAÇÃO E RELAÇÕES PÚBLICAS',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'PGE')
      },
      {
        name: 'ASSESSORIA DE CONTROLE DE MANDADOS JUDICIAIS',
        acronym: '',
        organ: Organ.find_by(acronym: 'PGE')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'PGE')
      },


      {
        name: '1º BATALHÃO POLICIAL MILITAR',
        acronym: '1º BPM',
        organ: Organ.find_by(acronym: 'PMCE')
      },
      {
        name: '2ª COMPANHIA DE POLICIAMENTO DE GUARDA',
        acronym: '2º COPOG',
        organ: Organ.find_by(acronym: 'PMCE')
      },
      {
        name: '2º BATALHÃO POLICIAL MILITAR',
        acronym: '2º BPM',
        organ: Organ.find_by(acronym: 'PMCE')
      },
      {
        name: '3º BATALHÃO POLICIAL MILITAR',
        acronym: '3º BPM',
        organ: Organ.find_by(acronym: 'PMCE')
      },
      {
        name: '4º BATALHÃO POLICIAL MILITAR',
        acronym: '4º BPM',
        organ: Organ.find_by(acronym: 'PMCE')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        name: 'ASSESASSESSSORIA DE COMUNICAÇÃOSORIA',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        name: 'CÉLULA DE DESENVOLVIMENTO SOCIAL E SUSTENTABILIDADE',
        acronym: 'CEDES',
        organ: Organ.find_by(acronym: 'SCIDADES')
      },
      {
        name: 'CÉLULA DE GESTÃO DO PROJETO DENDÊ',
        acronym: 'CEDEN',
        organ: Organ.find_by(acronym: 'SCIDADES')
      },


      {
        name: 'AGÊNCIA DE DEFESA AGROPECUÁRIA DO CEARÁ',
        acronym: 'ADAGRI',
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        name: 'ASSESSORIA ESTRATÉGICA E DE ARTICULAÇÃO',
        acronym: 'ASEST',
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        name: 'CÉLULA ACOMPANHAMENTO FINANCEIRO',
        acronym: 'CELAF',
        organ: Organ.find_by(acronym: 'SDA')
      },
      {
        name: 'CÉLULA AGRICULTURA DE SEQUEIRO',
        acronym: 'CEASE',
        organ: Organ.find_by(acronym: 'SDA')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SECITECE')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SECITECE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SECITECE')
      },
      {
        name: 'CÉLULA DE ARTICULAÇÃO INTERINSTITUCIONAL',
        acronym: 'CARIN',
        organ: Organ.find_by(acronym: 'SECITECE')
      },
      {
        name: 'CÉLULA DE DESENVOLVIMENTO DE RECURSOS HUMANOS',
        acronym: 'CERHU',
        organ: Organ.find_by(acronym: 'SECITECE')
      },


      {
        name: '10ª COORDENADORIA REGIONAL DE DESENVOLVIMENTO DA EDUCAÇÃO - RUSSAS',
        acronym: '10ª CREDE',
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        name: '11ª COORDENADORIA REGIONAL DE DESENVOLVIMENTO DA EDUCAÇÃO - JAGUARIBE',
        acronym: '11ª CREDE',
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        name: '12ª COORDENADORIA REGIONAL DE DESENVOLVIMENTO DA EDUCAÇÃO - QUIXADÁ',
        acronym: '12ª CREDE',
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        name: '13ª COORDENADORIA REGIONAL DE DESENVOLVIMENTO DA EDUCAÇÃO - CRATEÚS',
        acronym: '13ª CREDE',
        organ: Organ.find_by(acronym: 'SEDUC')
      },
      {
        name: '14ª COORDENADORIA REGIONAL DE DESENVOLVIMENTO DA EDUCAÇÃO - SENADOR POMPEU',
        acronym: '14ª CREDE',
        organ: Organ.find_by(acronym: 'SEDUC')
      },


      {
        name: 'ARQUIVO INTERMEDIÁRIO',
        acronym: 'AINT',
        organ: Organ.find_by(acronym: 'SECULT')
      },
      {
        name: 'ARQUIVO PÚBLICO DO ESTADO DO CEARÁ',
        acronym: '',
        organ: Organ.find_by(acronym: 'SECULT')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SECULT')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SECULT')
      },
      {
        name: 'BIBLIOTECA PÚBLICA GOVERNADOR MENESES PIMENTEL',
        acronym: 'BPGMP',
        organ: Organ.find_by(acronym: 'SECULT')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO E OUVIDORIA',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SEFAZ')
      },
      {
        name: 'ASSESSORIA DE ESTUDOS, PESQUISAS E DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SEFAZ')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SEFAZ')
      },
      {
        name: 'CAMPANHA SUA NOTA VALE DINHEIRO',
        acronym: '',
        organ: Organ.find_by(acronym: 'SEFAZ')
      },
      {
        name: 'CÉLULA DA DÍVIDA PÚBLICA',
        acronym: 'CEDIP',
        organ: Organ.find_by(acronym: 'SEFAZ')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO SOCIAL',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SEINFRA')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SEINFRA')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SEINFRA')
      },
      {
        name: 'CÉLULA DE ACOMPANHAMENTO DE PROJETOS',
        acronym: 'CEPRO',
        organ: Organ.find_by(acronym: 'SEINFRA')
      },
      {
        name: 'CÉLULA DE APOIO LOGÍSTICO',
        acronym: 'CELOG',
        organ: Organ.find_by(acronym: 'SEINFRA')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SEJUS')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SEJUS')
      },
      {
        name: 'CASA DE PRIVAÇÃO PROVISÓRIA DE LIBERDADE',
        acronym: '',
        organ: Organ.find_by(acronym: 'SEJUS')
      },
      {
        name: 'CASA DE PRIVAÇÃO PROVISÓRIA DE LIBERDADE AGENTE PENITENCIÁRIO LUCIANO ANDRADE DE LIMA',
        acronym: 'CAPPL',
        organ: Organ.find_by(acronym: 'SEJUS')
      },
      {
        name: 'CASA DE PRIVAÇÃO PROVISÓRIA DE LIBERDADE DESEMBARGADOR FRANCISCO ADALBERTO DE OLIVEIRA BARROS LEAL',
        acronym: 'CAPLAL',
        organ: Organ.find_by(acronym: 'SEJUS')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        name: 'ASSESSORIA DE PROJETOS ESPECIAIS',
        acronym: 'APESP',
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SEMA')
      },
      {
        name: 'CÉLULA DE ARTICULAÇÃO SOCIAL',
        acronym: '',
        organ: Organ.find_by(acronym: 'SEMA')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SEMACE')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SEMACE')
      },
      {
        name: 'BIBLIOTECA',
        acronym: 'BIBLIOTECA',
        organ: Organ.find_by(acronym: 'SEMACE')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIAF',
        organ: Organ.find_by(acronym: 'SEMACE')
      },
      {
        name: 'DIRETORIA DE CONTROLE E PROTEÇÃO AMBIENTAL',
        acronym: 'DICOP',
        organ: Organ.find_by(acronym: 'SEMACE')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        name: 'CÉLULA CONTÁBIL E FINANCEIRA',
        acronym: 'CECOF',
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        name: 'CÉLULA DE ACOMPANHAMENTO DOS CONTRATOS DE GESTÃO',
        acronym: 'CEACG',
        organ: Organ.find_by(acronym: 'SEPLAG')
      },
      {
        name: 'CÉLULA DE CAPTAÇÃO DE RECURSOS',
        acronym: 'CECAR',
        organ: Organ.find_by(acronym: 'SEPLAG')
      },


      {
        name: '10ª COORDENADORIA REGIONAL DE SAÚDE',
        acronym: 'CERES-LIMOEIRO DO NORTE',
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        name: '11ª COORDENADORIA REGIONAL DE SAÚDE',
        acronym: 'CERES-SOBRAL',
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        name: '12ª COORDENADORIA REGIONAL DE SAÚDE',
        acronym: 'CERES-ACARAÚ',
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        name: '13ª COORDENADORIA REGIONAL DE SAÚDE',
        acronym: 'CERES-TIANGUÁ',
        organ: Organ.find_by(acronym: 'SESA')
      },
      {
        name: '14ª COORDENADORIA REGIONAL DE SAÚDE',
        acronym: 'CERES-TAUÁ',
        organ: Organ.find_by(acronym: 'SESA')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SESPORTE')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SESPORTE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SESPORTE')
      },
      {
        name: 'CÉLULA DE DESENVOLVIMENTO DE RECURSOS HUMANOS',
        acronym: 'CERHU',
        organ: Organ.find_by(acronym: 'SESPORTE')
      },
      {
        name: 'CÉLULA DE ESPORTE DE AVENTURA, NATUREZA E MOTOR',
        acronym: 'CEANA',
        organ: Organ.find_by(acronym: 'SESPORTE')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SETUR')
      },
      {
        name: 'ASSESSORIA DE PLANEJAMENTO, ORÇAMENTO E CONTROLE',
        acronym: 'ASPOC',
        organ: Organ.find_by(acronym: 'SETUR')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SETUR')
      },
      {
        name: 'CÉLULA DE ACOMPANHAMENTO DE CONTRATOS E CONVÊNIOS',
        acronym: 'CEACC',
        organ: Organ.find_by(acronym: 'SETUR')
      },
      {
        name: 'CÉLULA DE CAPACITAÇÃO E QUALIFICAÇÃO',
        acronym: 'CECAQ',
        organ: Organ.find_by(acronym: 'SETUR')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SOHIDRA')
      },
      {
        name: 'DIRETORIA ADMINISTRATIVO-FINANCEIRA',
        acronym: 'DIAFI',
        organ: Organ.find_by(acronym: 'SOHIDRA')
      },
      {
        name: 'DIRETORIA DE ÁGUAS SUBTERRÂNEAS',
        acronym: 'DASUB',
        organ: Organ.find_by(acronym: 'SOHIDRA')
      },
      {
        name: 'DIRETORIA DE ÁGUAS SUPERFICIAIS',
        acronym: 'DAS',
        organ: Organ.find_by(acronym: 'SOHIDRA')
      },
      {
        name: 'NÚCLEO DE CONSTRUÇÃO DE POÇOS',
        acronym: 'NUCOP',
        organ: Organ.find_by(acronym: 'SOHIDRA')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SEAPA')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SEAPA')
      },
      {
        name: 'CÉLULA DE APOIO À AQUICULTURA CONTINENTAL',
        acronym: 'CEACO',
        organ: Organ.find_by(acronym: 'SEAPA')
      },
      {
        name: 'CÉLULA DE APOIO À AQUICULTURA MARINHA',
        acronym: 'CEAMA',
        organ: Organ.find_by(acronym: 'SEAPA')
      },
      {
        name: 'CÉLULA DE APOIO À PESCA ARTESANAL',
        acronym: 'CEPAR',
        organ: Organ.find_by(acronym: 'SEAPA')
      },


      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SRH')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SRH')
      },
      {
        name: 'CÉLULA ADMINISTRATIVA',
        acronym: 'CEADM',
        organ: Organ.find_by(acronym: 'SRH')
      },
      {
        name: 'CÉLULA DE CONTROLE SÓCIO-AMBIENTAL',
        acronym: 'CECON',
        organ: Organ.find_by(acronym: 'SRH')
      },
      {
        name: 'CÉLULA DE FISCALIZAÇÃO',
        acronym: 'CEFIS',
        organ: Organ.find_by(acronym: 'SRH')
      },


      {
        name: 'ASSESSORIA DE ANÁLISE ESTATÍSTICA E CRIMINAL',
        acronym: 'ANEC',
        organ: Organ.find_by(acronym: 'SSPDS')
      },
      {
        name: 'ASSESSORIA DE APOIO À PROCURADORIA GERAL DA JUSTIÇA',
        acronym: 'ASAPGJ',
        organ: Organ.find_by(acronym: 'SSPDS')
      },
      {
        name: 'ASSESSORIA DE COMUNICAÇÃO SOCIAL',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SSPDS')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SSPDS')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SSPDS')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        name: 'ASSESSORIA DE PLANEJAMENTO E DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ASPLAN2',
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        name: 'ASSESSORIA DE RELAÇÕES DO TRABALHO',
        acronym: 'ASPLAN3',
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'STDS')
      },
      {
        name: 'CÉLULA DE ADMINISTRAÇÃO',
        acronym: 'CELAD',
        organ: Organ.find_by(acronym: 'STDS')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SPD')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SPD')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SPD')
      },
      {
        name: 'COORDENADORIA ADMINISTRATIVO FINANCEIRA',
        acronym: 'COAFI',
        organ: Organ.find_by(acronym: 'SPD')
      },
      {
        name: 'COORDENADORIA DE INTERLOCUÇÃO INTERISTITUCIONAL',
        acronym: 'COINTER',
        organ: Organ.find_by(acronym: 'SPD')
      },


      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'ASSESSORIA DE DESENVOLVIMENTO INSTITUCIONAL',
        acronym: 'ADINS',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'CÉLULA DE ACOMPANHAMENTO E AVALIAÇÃO',
        acronym: 'CELAV',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'CÉLULA DE ADMINISTRAÇÃO',
        acronym: 'CELAD',
        organ: Organ.find_by(acronym: 'SDE')
      },


      {
        name: 'COORDENADORIA ADMINISTRATIVO-FINENCEIRA',
        acronym: 'COADF',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'COORDENADORIA DE ACORDOS E INVESTIMENTOS',
        acronym: 'CAIN',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'COORDENADORIA DE PEQUENOS NEGÓCIOS',
        acronym: 'COPN',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'COORDENADORIA DE POLÍTICAS E ESTRATÉGICAS',
        acronym: 'CPE',
        organ: Organ.find_by(acronym: 'SDE')
      },
      {
        name: 'COORDENADORIA DE PROMOÇÃO DE NEGOCIOS',
        acronym: 'CPN',
        organ: Organ.find_by(acronym: 'SDE')
      },


      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'URCA')
      },
      {
        name: 'ASSESSORIA TÉCNICA',
        acronym: 'ASTEC',
        organ: Organ.find_by(acronym: 'URCA')
      },
      {
        name: 'BIBLIOTECA CENTRAL',
        acronym: 'BICEN',
        organ: Organ.find_by(acronym: 'URCA')
      },
      {
        name: 'CENTRO DE CIÊNCIAS DA SAÚDE',
        acronym: 'CCS',
        organ: Organ.find_by(acronym: 'URCA')
      },
      {
        name: 'CENTRO DE CIÊNCIAS E TECNOLOGIA',
        acronym: 'CCT',
        organ: Organ.find_by(acronym: 'URCA')
      },


      {
        name: 'ASSESSORIA TÉCNICA',
        acronym: 'ASTEC',
        organ: Organ.find_by(acronym: 'UVA')
      },
      {
        name: 'BIBLIOTECA CENTRAL',
        acronym: 'BICEN',
        organ: Organ.find_by(acronym: 'UVA')
      },
      {
        name: 'CENTRO DE CIÊNCIAS AGRARIAS E BIOLOGIAS',
        acronym: '',
        organ: Organ.find_by(acronym: 'UVA')
      },
      {
        name: 'CENTRO DE CIÊNCIAS DA SAÚDE',
        acronym: 'CBPS',
        organ: Organ.find_by(acronym: 'UVA')
      },
      {
        name: 'CENTRO DE CIÊNCIAS EXATAS E TECNOLÓGICAS',
        acronym: 'CET',
        organ: Organ.find_by(acronym: 'UVA')
      },


      {
        name: 'ASSESSORIA TÉCNICA',
        acronym: 'ASTEC',
        organ: Organ.find_by(acronym: 'UECE')
      },
      {
        name: 'BIBLIOTECA CENTRAL',
        acronym: 'BC',
        organ: Organ.find_by(acronym: 'UECE')
      },
      {
        name: 'CENTRO DE CIÊNCIAS DA SAÚDE',
        acronym: 'CCS',
        organ: Organ.find_by(acronym: 'UECE')
      },
      {
        name: 'CENTRO DE CIÊNCIAS E TECNOLOGIA',
        acronym: 'CCT',
        organ: Organ.find_by(acronym: 'UECE')
      },
      {
        name: 'CENTRO DE ESTUDOS SOCIAIS APLICADOS',
        acronym: 'CESA',
        organ: Organ.find_by(acronym: 'UECE')
      },


      {
        name: 'ASSEMBLÉIA GERAL',
        acronym: 'ASSEG',
        organ: Organ.find_by(acronym: 'ZPE')
      },
      {
        name: 'ASSESSORIA DE COMUNICAÇÃO',
        acronym: 'ASCOM',
        organ: Organ.find_by(acronym: 'ZPE')
      },
      {
        name: 'ASSESSORIA DE PLANEJAMENTO',
        acronym: 'ASPLAN4',
        organ: Organ.find_by(acronym: 'ZPE')
      },
      {
        name: 'ASSESSORIA EXECUTIVA',
        acronym: 'ASSEC',
        organ: Organ.find_by(acronym: 'ZPE')
      },
      {
        name: 'ASSESSORIA JURÍDICA',
        acronym: 'ASJUR',
        organ: Organ.find_by(acronym: 'ZPE')
      }
    ]

    departments_data.each do |department_data|
      begin
      department = Department.find_or_initialize_by(name: department_data[:name], organ_id: department_data[:organ].id)
      department.update_attributes!(department_data)
        
      rescue 
        raise department_data.inspect 
      end

    end
  end
end
