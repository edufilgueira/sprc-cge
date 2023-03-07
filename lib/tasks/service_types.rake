namespace :service_types do
  task create_or_update: :environment do

    service_types_data = [
      {
        code: 747,
        name: 'OUVIDORIA'
      },
      {
        code: 1017,
        name: 'ALCOOLEMIA'
      },
      {
        code: 1040,
        name: 'CONSULTA'
      },
      {
        code: 1309,
        name: 'DIVÓRCIO'
      },
      {
        code: 1442,
        name: 'DIVÓRCIO'
      },
      {
        code: 2386,
        name: 'TESTE PPD'
      },
      {
        code: 2551,
        name: 'ESTATÍSTICAS'
      },
      {
        code: 30,
        name: 'EMISSÃO DE CERTIDÃO DE ACUMULAÇÃO DE CARGOS/FUNÇÕES/EMPREGOS PÚBLICOS.'
      },
      {
        code: 31,
        name: 'DECLARAÇÃO DE RENDIMENTO DO SERVIDOR PÚBLICO ESTADUAL PARA FINS DE AQUISIÇÃO DE IMÓVEIS/FINANCIAMENTO'
      },
      {
        code: 32,
        name: 'DECLARAÇÃO DE PERCENTUAIS DE REAJUSTE DO SERVIDOR PÚBLICO ESTADUAL'
      },
      {
        code: 34,
        name: 'EMISSÃO DE CERTIDÃO OU DECLARAÇÃO DE TEMPO DE CONTRIBUIÇÃO JUNTO AO SUPSEC'
      },
      {
        code: 35,
        name: 'ANÁLISE DA AVERBAÇÃO DE TEMPO DE CONTRIBUIÇÃO JUNTO AO SUPSEC'
      },
      {
        code: 36,
        name: 'ANÁLISE DA DESAVERBAÇÃO DE TEMPO DE CONTRIBUIÇÃO JUNTO AO SUPSEC'
      },
      {
        code: 37,
        name: 'EMISSÃO DE CERTIDÃO NEGATIVA OU POSITIVA DE BENEFÍCIO PREVIDENCIÁRIO JUNTO AO SUPSEC'
      },
      {
        code: 42,
        name: 'PRESTAÇÃO DE INFORMAÇÕES GERAIS SOBRE O SUPSEC'
      },
      {
        code: 44,
        name: 'ANÁLISE E IMPLANTAÇÃO DE ABONO DE PERMANÊNCIA PARA OS SEGURADOS DO SUPSEC'
      },
      {
        code: 45,
        name: 'PERÍCIA PARA ADMISSÃO NO SERVIÇO PÚBLICO.'
      },
      {
        code: 47,
        name: 'PERÍCIA PARA LICENÇA GESTANTE DE MILITARES'
      },
      {
        code: 48,
        name: 'PERÍCIA PARA LICENÇA PARA TRATAMENTO DE SAÚDE.'
      },
      {
        code: 49,
        name: 'PERÍCIA PARA LICENÇA POR MOTIVO DE DOENÇA EM PESSOA DA FAMÍLIA.'
      },
      {
        code: 50,
        name: 'PERÍCIA DOMICILIAR/HOSPITALAR, APENAS PARA SERVIDORES CIVIS.'
      },
      {
        code: 51,
        name: 'PERÍCIA PARA APOSENTADORIA POR INVALIDEZ.'
      },
      {
        code: 52,
        name: 'PERÍCIA PARA REFORMA POR INVALIDEZ.'
      },
      {
        code: 53,
        name: 'EMISSÃO DE LAUDO PERICIAL PARA RESGATE DE SEGUROS.'
      },
      {
        code: 54,
        name: 'AVALIAÇÃO/ORIENTAÇÃO PSICOSSOCIAL.'
      },
      {
        code: 56,
        name: 'SERVIÇOS DA COPEM PARA INTERIOR DO ESTADO, APENAS PARA SERVIDORES CIVIS.'
      },
      {
        code: 4777,
        name: 'PRÓTESES'
      },
      {
        code: 57,
        name: 'PERÍCIA PARA READAPTAÇÃO DE FUNÇÃO.'
      },
      {
        code: 58,
        name: 'PERÍCIA PARA REMOÇÃO.'
      },
      {
        code: 59,
        name: 'PERÍCIA MÉDICA ESPECIAL.'
      },
      {
        code: 60,
        name: 'PERÍCIA MÉDICA ORTOPÉDICA.'
      },
      {
        code: 61,
        name: 'PERÍCIA PARA DESLIGAMENTO DO SERVIÇO MILITAR'
      },
      {
        code: 62,
        name: 'PERÍCIA PARA COMPROVAÇÃO DE INVALIDEZ E EMISSÃO DE LAUDO.'
      },
      {
        code: 63,
        name: 'PERÍCIA PARA REINTEGRAÇÃO / REINCLUSÃO NO SERVIÇO PÚBLICO.'
      },
      {
        code: 64,
        name: 'PERÍCIA PARA COMPROVAR APTIDÕES PARA CURSOS DIVERSOS E PROMOÇÃO DE OFICIAIS E PRAÇAS'
      },
      {
        code: 65,
        name: 'PERÍCIA PARA ATESTADO DE ORIGEM.'
      },
      {
        code: 66,
        name: 'PERÍCIA PARA REVERSÃO DE REFORMA POR INVALIDEZ.'
      },
      {
        code: 67,
        name: 'PERÍCIA PARA REVERSÃO DE APOSENTADORIA POR INVALIDEZ.'
      },
      {
        code: 68,
        name: 'REDESENHO DE PROCESSOS CORPORATIVOS E/OU VOLTADOS PARA O CIDADÃO'
      },
      {
        code: 69,
        name: 'ANÁLISE DE MINUTAS DE DECRETO DE ESTRUTURA ORGANIZACIONAL E/OU DE REGULAMENTO'
      },
      {
        code: 72,
        name: 'ELABORAÇÃO / ATUALIZAÇÃO DE PLANEJAMENTO ESTRATÉGICO'
      },
      {
        code: 88,
        name: 'LEILÃO DE BENS MÓVEIS'
      },
      {
        code: 89,
        name: 'ALIENAÇÃO BENS IMÓVEIS'
      },
      {
        code: 93,
        name: 'EFETIVAÇÃO DE CADASTRO DE VEÍCULOS NO SISTEMA DE GESTÃO DE FROTA - SIGEF.'
      },
      {
        code: 95,
        name: 'ASSESSORIA EM PROJETOS ESPECIAIS.'
      },
      {
        code: 96,
        name: 'PRÊMIO CEARÁ DE CIDADANIA ELETRÔNICA.'
      },
      {
        code: 110,
        name: 'BANCO DE TALENTOS - TALENTOS.'
      },
      {
        code: 113,
        name: 'IMPLANTAÇÃO DO SISTEMA DE GESTÃO DE ALMOXARIFADO - SIGA.'
      },
      {
        code: 114,
        name: 'IMPLANTAÇÃO DO SISTEMA DE GESTÃO DE FROTA - SIGEF.'
      },
      {
        code: 126,
        name: 'AUTOAVALIAÇÃO'
      },
      {
        code: 127,
        name: 'CARTA DE SERVIÇOS AO CIDADÃO'
      },
      {
        code: 128,
        name: 'INSTRUMENTO PADRÃO DE PESQUISA DE SATISFAÇÃO - IPPS'
      },
      {
        code: 130,
        name: 'SIMPLIFICAÇÃO DE PROCESSOS'
      },
      {
        code: 136,
        name: 'ACOMPANHAMENTO DA EXECUÇÃO ORÇAMENTÁRIA.'
      },
      {
        code: 137,
        name: 'ELABORAÇÃO DA LEI DE DIRETRIZES ORÇAMENTÁRIAS'
      },
      {
        code: 138,
        name: 'ELABORAÇÃO DO PROJETO DE LEI ORÇAMENTÁRIA ANUAL'
      },
      {
        code: 155,
        name: 'EXAMES DE ANÁLISES CLÍNICAS - CAPITAL'
      },
      {
        code: 156,
        name: 'CARTÃO SAÚDE ISSEC'
      },
      {
        code: 157,
        name: 'INCLUSÃO DE DEPENDENTE'
      },
      {
        code: 178,
        name: 'CITOLOGIA ONCÓTICA/ COLPOSCOPIA/ TONOMETRIA/ECG NO ATO DA CONSULTA MÉDICA'
      },
      {
        code: 184,
        name: 'EXAMES RADIOLÓGICOS,DESINTOMETRIA ÒSSEA - CAPITAL'
      },
      {
        code: 185,
        name: 'ODONTOLOGIA - CAPITAL'
      },
      {
        code: 191,
        name: 'EXAME DE ULTRASSONOGRAFIA - CAPITAL'
      },
      {
        code: 193,
        name: 'TOMOGRAFIA, RESSONÂNCIA MAGNÉTICA,CARDIOLOGIA,ENDOSCOPIA,NEUROLOGIA,PNEUMOLOGIA,OFTALMOLOGIA,OTORRINO - INTERIOR.'
      },
      {
        code: 196,
        name: 'PARTO NORMAL E CESÁREA'
      },
      {
        code: 197,
        name: 'CONSULTA MÉDICA ELETIVA'
      },
      {
        code: 206,
        name: 'SERVIÇO DE ROTAS DE ÔNIBUS PARA O TRANSPORTE DE FUNCIONÁRIOS DO CENTRO ADMINISTRATIVO DO CAMBEBA'
      },
      {
        code: 214,
        name: 'ODONTOLOGIA - INTERIOR'
      },
      {
        code: 221,
        name: 'ANUÁRIO ESTATÍSTICO DO CEARÁ'
      },
      {
        code: 222,
        name: 'ACOMPANHAMENTO DO RATEIO DO ICMS DOS MUNICÍPIOS'
      },
      {
        code: 223,
        name: 'RELATÓRIO DE PERFORMANCE DO IPECE'
      },
      {
        code: 224,
        name: 'TOMOGRAFIA,RESSONÂNCIA MAGNÉTICA,CINTILOGRAFIA, MEDICINA NUCLEAR,CARDIOLOGIA,ENDOSCOPIA,NEUROLOGIA,PNEUMOLOGIA,OFTALMOLOGIA,OTORRINO -CAPITAL'
      },
      {
        code: 225,
        name: 'CEARÁ EM NÚMEROS'
      },
      {
        code: 226,
        name: 'ARTIGOS CIENTÍFICOS'
      },
      {
        code: 228,
        name: 'PROJETOS MULTISETORIAIS DO BANCO MUNDIAL COM O CEARÁ COORDENADOS PELO IPECE.'
      },
      {
        code: 231,
        name: 'PERFIL BÁSICO MUNICIPAL'
      },
      {
        code: 237,
        name: 'PERFIL BÁSICO REGIONAL'
      },
      {
        code: 239,
        name: 'ATENDIMENTO ÀS PESSOAS PORTADORAS DE DEFICIENCIA MENTAL E AUDITIVA.'
      },
      {
        code: 241,
        name: 'PAINEL DE INDICADORES SOCIAIS E ECONÔMICOS: OS 10 MAIORES E MENORES'
      },
      {
        code: 242,
        name: 'IPECE INFORME'
      },
      {
        code: 248,
        name: 'CEARÁ EM MAPAS'
      },
      {
        code: 249,
        name: 'CEARÁ EM MAPAS INTERATIVO'
      },
      {
        code: 251,
        name: 'MAPA BÁSICO DO CEARÁ'
      },
      {
        code: 254,
        name: 'ASSESSORIA TÉCNICA'
      },
      {
        code: 255,
        name: 'CAPACITAÇÃO'
      },
      {
        code: 256,
        name: 'ACOMPANHAMENTO CADUNICO'
      },
      {
        code: 260,
        name: 'LAUDÊMIO/ FOROS ANUAIS'
      },
      {
        code: 261,
        name: 'NOTAS TÉCNICAS - ESTUDOS SOCIAIS'
      },
      {
        code: 262,
        name: 'TEXTOS PARA DISCUSSÃO - ESTUDOS SOCIAIS'
      },
      {
        code: 264,
        name: 'INDICADORES SOCIAIS DO CEARÁ'
      },
      {
        code: 265,
        name: 'PARECER TÉCNICO SOBRE OS LIMITES MUNICIPAIS DO ESTADO DO CEARÁ'
      },
      {
        code: 267,
        name: 'ACERVO DE IMAGENS DE SATÉLITE DO CEARÁ'
      },
      {
        code: 268,
        name: 'TEXTOS PARA DISCUSSÃO - ESTUDOS DE GEOGRAFIA'
      },
      {
        code: 271,
        name: 'ÍNDICE DE DESENVOLVIMENTO MUNICIPAL (IDM)'
      },
      {
        code: 272,
        name: 'ÍNDICE DE DESENVOLVIMENTO SOCIAL (IDS)'
      },
      {
        code: 274,
        name: 'ASSESSORIA NA ÁREA DE GEOPROCESSAMENTO'
      },
      {
        code: 275,
        name: 'SITE DO IPECE'
      },
      {
        code: 278,
        name: 'BANCO DE DADOS CIPP'
      },
      {
        code: 279,
        name: 'BLOG DO IPECE'
      },
      {
        code: 282,
        name: 'SISTEMA WIKIPECE'
      },
      {
        code: 285,
        name: 'ATENDIMENTO DE DEMANDAS POR INFORMAÇÃO SOCIOECONÔMICAS E GEOGRÁFICAS DO ESTADO DO CEARÁ'
      },
      {
        code: 292,
        name: 'INTERNAMENTO DE URGÊNCIA/EMERGÊNCIA - CAPITAL'
      },
      {
        code: 293,
        name: 'INTERNAMENTO ELETIVO - CAPITAL'
      },
      {
        code: 295,
        name: 'PROCESSOS DE PAGAMENTO DA REDE CREDENCIADA'
      },
      {
        code: 296,
        name: 'PROCESSOS DA REDE CREDENCIADA'
      },
      {
        code: 309,
        name: 'BOLETINS DA CONJUNTURA ECONÔMICA DO CEARÁ'
      },
      {
        code: 310,
        name: 'BOLETINS DA EVOLUÇÃO DO INPC'
      },
      {
        code: 311,
        name: 'PIB ESTADUAL'
      },
      {
        code: 312,
        name: 'PIB MUNICIPAL'
      },
      {
        code: 313,
        name: 'PIB TRIMESTRAL'
      },
      {
        code: 314,
        name: 'INDICADORES ECONÔMICOS DO CEARÁ'
      },
      {
        code: 315,
        name: 'ÍNDICE MUNICIPAL DE ALERTA'
      },
      {
        code: 316,
        name: 'RADAR DA INDÚSTRIA'
      },
      {
        code: 318,
        name: 'RADAR DO COMÉRCIO'
      },
      {
        code: 319,
        name: 'RADAR DO COMERCIO EXTERIOR'
      },
      {
        code: 321,
        name: 'SÍNTESE DOS INDICADORES ECONÔMICOS'
      },
      {
        code: 322,
        name: 'NOTAS TÉCNICAS - ESTUDOS ECONÔMICOS'
      },
      {
        code: 323,
        name: 'TEXTOS PARA DISCUSSÃO - ESTUDOS ECONÔMICOS'
      },
      {
        code: 324,
        name: 'ASSESSORIA AO PPA - PLANO PLURI ANUAL'
      },
      {
        code: 325,
        name: 'ASSESSORIA ÀS CÂMERAS SETORIAIS DOS SETORES PRODUTIVOS - COORDENAÇÃO DA ADECE.'
      },
      {
        code: 327,
        name: 'ASSESSORIA AO GMAIS - GRUPO DE MONITORAMENTO E AÇÕES INTERINTITUCIONAL E SETORIAL'
      },
      {
        code: 330,
        name: 'HOSPEDAGEM DE SERVIDOR (COLOCATION)'
      },
      {
        code: 334,
        name: 'HOSPEDAGEM DE SITES'
      },
      {
        code: 337,
        name: 'HOSPEDAGEM DE BANCO DE DADOS'
      },
      {
        code: 338,
        name: 'HOSPEDAGEM DE APLICAÇÕES'
      },
      {
        code: 339,
        name: 'VPN (VIRTUAL PRIVATE NETWORK)'
      },
      {
        code: 340,
        name: 'ADMINISTRAÇÃO DO DOMÍNIO CE.GOV.BR'
      },
      {
        code: 341,
        name: 'CONEXÃO À GIGAFOR E CINTURÃO DIGITAL DO CEARÁ (CDC) - CONFIGURAÇÃO DE SWITCHES DE ACESSO'
      },
      {
        code: 342,
        name: 'CONEXÃO À GIGAFOR E CINTURÃO DIGITAL DO CEARÁ (CDC) - CONFIGURAÇÃO DE RÁDIOS'
      },
      {
        code: 343,
        name: 'CONEXÃO À GIGAFOR E AO CINTURÃO DIGITAL DO CEARÁ (CDC) - CONFIGURAÇÃO DE SWITCHES DWDM'
      },
      {
        code: 344,
        name: 'HOSPEDAGEM DE APLICAÇÕES NO MAINFRAME'
      },
      {
        code: 345,
        name: 'TRANSMISSÃO DE ARQUIVOS DO MAINFRAME'
      },
      {
        code: 346,
        name: 'PSICOLOGIA, FONOAUDIOLOGIA E FISIOTERAPIA - CAPITAL'
      },
      {
        code: 347,
        name: 'PSICOLOGIA, FONOAUDIOLOGIA E FISIOTERAPIA - INTERIOR'
      },
      {
        code: 351,
        name: 'EVENTOS DE FORMAÇÃO A DISTÂNCIA PARA O SERVIDOR / EMPREGADO PÚBLICO.'
      },
      {
        code: 352,
        name: 'FINANCIAMENTO DE CURSOS DE PÓS-GRADUAÇÃO (ESPECIALIZAÇÃO, MESTRADO, DOUTORADO E PÓS-DOUTORADO).'
      },
      {
        code: 353,
        name: 'AFASTAMENTO PARA CURSOS DE PÓS-GRADUAÇÃO (ESPECIALIZAÇÃO, MESTRADO, DOUTORADO E PÓS-DOUTORADO).'
      },
      {
        code: 354,
        name: 'BOLSAS/DESCONTOS EM CURSOS DE GRADUAÇÃO, PARA SERVIDORES/EMPREGADOS PÚBLICOS E SEUS DEPENDENTES.'
      },
      {
        code: 355,
        name: 'PROGRAMA QUALIDADE DE VIDA - AÇÕES SÓCIO-CULTURAIS, SENSIBILIZAÇÃO E CONSCIENTIZAÇÃO DESTINADAS AO SERVIDOR/EMPREGADO PÚBLICO.'
      },
      {
        code: 356,
        name: 'EVENTOS DE FORMAÇÃO PRESENCIAL PARA O SERVIDOR / EMPREGADO PÚBLICO.'
      },
      {
        code: 358,
        name: 'MEDALHA DO MÉRITO FUNCIONAL E PRÊMIO DO MÉRITO FUNCIONAL.'
      },
      {
        code: 359,
        name: 'CONEXÃO À GIGAFOR E CINTURÃO DIGITAL DO CEARÁ (CDC), VIA FIBRA ÓPTICA'
      },
      {
        code: 360,
        name: 'CONEXÃO À GIGAFOR E CINTURÃO DIGITAL DO CEARÁ (CDC), ATRAVÉS DE RÁDIO PRÉ-WIMAX'
      },
      {
        code: 361,
        name: 'HOSPEDAGEM DE CORREIO ELETRÔNICO (WEBMAIL)'
      },
      {
        code: 362,
        name: 'VIDEOCONFERÊNCIA'
      },
      {
        code: 363,
        name: 'ADESÃO AO PONTO DE TROCA DE TRÁFEGO - PTT'
      },
      {
        code: 364,
        name: 'INSTALAÇÃO, CONEXÃO E MANUTENÇÃO DO PONTO DE TROCA DE TRÁFEGO - PTT'
      },
      {
        code: 365,
        name: 'CENTRAL DE SERVIÇOS'
      },
      {
        code: 368,
        name: 'MONITORAMENTO DAS AQUISIÇÕES DE TIC.'
      },
      {
        code: 382,
        name: 'ATLAS DO POTENCIAL EÓLICO DO CEARÁ'
      },
      {
        code: 383,
        name: 'SOLICITAÇÕES DE SERVIÇOS DE TELEFONIA FIXA E AQUISIÇÃO DE NOVAS LINHAS.'
      },
      {
        code: 398,
        name: 'TABELA DE CUSTOS UNIFICADA SEINFRA'
      },
      {
        code: 409,
        name: 'REAJUSTE E REVISÃO TARIFÁRIA'
      },
      {
        code: 421,
        name: 'PEDIDO DE RENÚNCIA DE PERMISSIONÁRIO DO SETOR DE TRANSPORTE RODOVIÁRIO INTERMUNICIPAL DE PASSAGEIROS'
      },
      {
        code: 423,
        name: 'AUTORIZAÇÃO DE TRÂNSITO'
      },
      {
        code: 425,
        name: 'AUTORIZAÇÃO DE TRÂNSITO - AET (SIMPLIFICADA)'
      },
      {
        code: 427,
        name: 'MEIA PASSAGEM ESTUDANTIL (GESTÃO)'
      },
      {
        code: 432,
        name: 'SOLICITAÇÕES DE OUVIDORIA E MEDIAÇÃO DE CONFLITOS'
      },
      {
        code: 435,
        name: 'CALIBRAÇÃO DE ALICATE AMPERÍMETRO'
      },
      {
        code: 437,
        name: 'CALIBRAÇÃO DE AMPERÍMETRO'
      },
      {
        code: 438,
        name: 'CALIBRAÇÃO DE CALIBRADOR'
      },
      {
        code: 440,
        name: 'CALIBRAÇÃO DE DÉCADA RESISTIVA'
      },
      {
        code: 441,
        name: 'CALIBRAÇÃO DE FONTE DE TENSÃO E CORRENTE'
      },
      {
        code: 442,
        name: 'CALIBRAÇÃO DE MEGÔMETRO'
      },
      {
        code: 443,
        name: 'CALIBRAÇÃO DE MULTÍMETRO'
      },
      {
        code: 444,
        name: 'CALIBRAÇÃO DE MULTIMEDIDOR'
      },
      {
        code: 445,
        name: 'CALIBRAÇÃO DE OHMÍMETRO'
      },
      {
        code: 446,
        name: 'CALIBRAÇÃO DE PONTE KELVIN'
      },
      {
        code: 447,
        name: 'CALIBRAÇÃO DE PONTE WHEATSTONE'
      },
      {
        code: 448,
        name: 'CALIBRAÇÃO DE PONTE DE RESISTÊNCIA'
      },
      {
        code: 449,
        name: 'CALIBRAÇÃO DE TERRÔMETRO'
      },
      {
        code: 450,
        name: 'CALIBRAÇÃO DE VOLTÍMETRO'
      },
      {
        code: 457,
        name: 'FISCALIZAÇÃO DOS SERVIÇOS DE ABASTECIMENTO DE ÁGUA E ESGOTAMENTO SANITÁRIO'
      },
      {
        code: 478,
        name: 'EXAME DE LESÃO CORPORAL'
      },
      {
        code: 479,
        name: 'EXAME DE CORPO DE DELITO EM SITUACÃO DE FLAGRANTE - LESÃO CORPORAL'
      },
      {
        code: 480,
        name: 'EXAME PERICIAL PARA FINS DE DPVAT'
      },
      {
        code: 481,
        name: 'EXAME DE SANIDADE EM LESÃO CORPORAL OU DPVAT'
      },
      {
        code: 482,
        name: 'EXAME DE CORPO DE DELITO PARA VERIFICAÇÃO DE EMBRIAGUEZ'
      },
      {
        code: 483,
        name: 'EXAME DE CORPO DE DELITO EM SANIDADE MENTAL'
      },
      {
        code: 485,
        name: 'EXAME DE CORPO DE DELITO EM CASOS DE VIOLÊNCIA DOMÉSTICA CONTRA MULHER, CRIANCA E ADOLESCENTE'
      },
      {
        code: 486,
        name: 'NECROPSIA MÉDICO-LEGAL'
      },
      {
        code: 487,
        name: 'EXAME DE OSSADA OU CORPOS CARBONIZADOS'
      },
      {
        code: 489,
        name: 'EMISSÃO DA CERTIDÃO DE REGULARIDADE FISCAL'
      },
      {
        code: 504,
        name: 'ADIÇÃO DE CATEGORIA(CARTEIRA DE HABILITAÇÃO)'
      },
      {
        code: 506,
        name: 'ACOLHIMENTO DAS DEMANDAS ORIUNDAS DA OUVIDORIA GERAL DO ESTADO E CARTAS POPULARES.'
      },
      {
        code: 507,
        name: 'ELABORAÇÃO DOS PROCESSOS DE PRESTAÇÃO DE CONTAS DOS PROGRAMAS PROJOVEM DO ESTADO DO CEARÁ PARA O GOVERNO FEDERAL E ÓRGÃOS DE CONTROLE INTERNO E EXTERNO.'
      },
      {
        code: 515,
        name: 'GERENCIAMENTO DOS PROGRAMAS PROJOVEM NO GOVERNO DO ESTADO DO CEARÁ.'
      },
      {
        code: 526,
        name: 'ALTERAÇÃO DE CARACTERÍSTICAS SEM LAUDO CSV'
      },
      {
        code: 535,
        name: 'BAIXA DE VEÍCULO'
      },
      {
        code: 536,
        name: 'PERMISSÃO INTERNACIONAL PARA DIRIGIR(CARTEIRA INTERNACIONAL)'
      },
      {
        code: 538,
        name: 'CALENDÁRIO DE LICENCIAMENTO'
      },
      {
        code: 539,
        name: 'CNH DEFINITIVA(CARTEIRA DE HABILITAÇÃO)'
      },
      {
        code: 543,
        name: 'CERTIDÃO (NADA CONSTA)'
      },
      {
        code: 544,
        name: 'LICENCIAMENTO ANUAL'
      },
      {
        code: 549,
        name: 'PRIMEIRO REGISTRO'
      },
      {
        code: 553,
        name: 'REGRAVAÇÃO DE CHASSI'
      },
      {
        code: 560,
        name: 'RECURSOS DE INFRAÇÕES DE TRÂNSITO'
      },
      {
        code: 561,
        name: 'EXAME DE CONSTATAÇÃO DA PRESENÇA DE ESPERMA EM AMOSTRAS BIOLÓGICAS.'
      },
      {
        code: 562,
        name: 'DETERMINAÇÃO DE PERFIS GENÉTICOS PARA IDENTIFICAÇÃO CIVIL DE CADÁVERES.'
      },
      {
        code: 563,
        name: 'IDENTIFICAÇÃO DE PERFIS GENÉTICOS EM CASOS DE CRIMES SEXUAIS.'
      },
      {
        code: 564,
        name: 'LIBERAÇÃO DE VEÍCULOS'
      },
      {
        code: 565,
        name: 'LIBERAÇÃO DE DOCUMENTOS APREENDIDOS NAS OPERAÇÕES DE FISCALIZAÇÃO'
      },
      {
        code: 566,
        name: 'APREENSÃO DE CNHS(CARTEIRA DE HABILITAÇÃO) RECOLHIDAS NAS OPERAÇÕES DE FISCALIZAÇÃO'
      },
      {
        code: 568,
        name: 'EMISSÃO DE DOCUMENTO DE ARRECADAÇÃO ESTADUAL PARA RECOLHIMENTO DE TRIBUTO LANÇADO EM AUTO DE INFRAÇÃO'
      },
      {
        code: 569,
        name: 'RESTITUIÇÃO DE PAGAMENTO DE TAXA E MULTA DO DETRAN/CE.'
      },
      {
        code: 571,
        name: 'DENÚNCIA OU REPRESENTAÇÃO CONTRA SERVIDOR PÚBLICO DA SECRETARIA DA FAZENDA - SEFAZ'
      },
      {
        code: 578,
        name: 'MULTAS DE INFRAÇÃO À LEGISLAÇÃO DE TRÂNSITO E DE TRANSPORTE.'
      },
      {
        code: 579,
        name: 'LEILÃO DE VEÍCULO APREENDIDOS EM FISCALIZAÇÃO DE TRÂNSITO E NÃO RECLAMADOS NO PRAZO DE 90 DIAS'
      },
      {
        code: 582,
        name: 'ORIENTAÇÕES E ACOMPANHAMENTO DAS POLÍTICAS TRANSVERSAIS DE GOVERNO PARA A PROMOÇÃO DA IGUALDADE RACIAL'
      },
      {
        code: 599,
        name: 'BUSCA DE ANTERIORIDADE E PEDIDO DE REGISTRO DE MARCA JUNTO AO INSTITUTO NACIONAL DE PRORPIEDADE INDUSTRIAL-INPI'
      },
      {
        code: 600,
        name: 'ACOMPANHAMENTO DO PEDIDO DE REGISTRO DE MARCA'
      },
      {
        code: 603,
        name: 'ANÁLISE DOS ATOS DE NOMEAÇÃO E EXONERAÇÃO DOS SERVIDORES DO PRIMEIRO ESCALÃO.'
      },
      {
        code: 606,
        name: 'ANÁLISE JURÍDICA DOS EDITAIS DE LICITAÇÃO, DISPENSAS E INEXIGIBILIDADES, BEM COMO A PRODUÇÃO DOS PARECERES RESPECTIVOS.'
      },
      {
        code: 608,
        name: 'ANÁLISE JURÍDICA DAS PORTARIAS DO GABGOV E PRODUÇÃO DE PARECERES.'
      },
      {
        code: 609,
        name: 'FORNECIMENTO DA LISTA DE AUTORIDADES DA ADMINISTRAÇÃO DIRETA E INDIRETA DO GOVERNO DO ESTADO DO CEARÁ (1º, 2º E 3º ESCALÃO)'
      },
      {
        code: 610,
        name: 'DISPONIBILIZAÇÃO DE MESTRES DE CERIMÔNIA DO GABINETE DO GOVERNADOR PARA APRESENTAÇÃO EM EVENTOS OFICIAIS DO GOVERNO DO ESTADO DO CEARÁ.'
      },
      {
        code: 611,
        name: 'VISITA OFICIAL DE AUTORIDADES AO ESTADO DO CEARÁ'
      },
      {
        code: 612,
        name: 'EXPEDIÇÃO DE CONVITES OFICIAIS'
      },
      {
        code: 613,
        name: 'SISTEMA DE POSTAGEM ELETRÔNICA - SPE'
      },
      {
        code: 614,
        name: 'COMPOSIÇÃO DE MESA OU PALCO DE HONRA'
      },
      {
        code: 615,
        name: 'SERVIÇOS DE CERIMONIAL AO GOVERNADOR EM EVENTOS OFICIAIS.'
      },
      {
        code: 617,
        name: 'SERVIÇO SOCIAL'
      },
      {
        code: 619,
        name: 'INCLUSÃO DE VEÍCULO NA FROTA DAS TRANSPORTADORAS'
      },
      {
        code: 620,
        name: 'EXCLUSÃO DE VEÍCULO DA FROTA DAS TRANSPORTADORAS.'
      },
      {
        code: 621,
        name: 'EXCLUSÃO DE VEÍCULO DA FROTA DAS TRANSPORTADORAS.'
      },
      {
        code: 622,
        name: 'AUTORIZAÇÃO PARA FRETAMENTO CONTÍNUO.'
      },
      {
        code: 623,
        name: 'RENOVAÇÃO DE CADASTRO DE TRANSPORTADORA DE FRETAMENTO.'
      },
      {
        code: 624,
        name: 'RENOVAÇÃO DE CADASTRO DE TRANSPORTADORA DE LINHA REGULAR OU REGULAR COMPLEMENTAR.'
      },
      {
        code: 625,
        name: 'REGISTRO DE TRANSPORTADORAS NA MODALIDADE FRETAMENTO.'
      },
      {
        code: 626,
        name: 'PAGAMENTO DOS BOLETOS DO SEGURO DE RESPONSABILIDADE CIVIL.'
      },
      {
        code: 627,
        name: 'VISTORIA ANUAL DE VEÍCULO.'
      },
      {
        code: 628,
        name: 'DEFESA DE AUTO DE TRANSPORTE.'
      },
      {
        code: 629,
        name: 'AUTORIZAÇÃO DE TRANSPORTE PARA O SERVIÇO REGULAR OU REGULAR COMPLEMENTAR.'
      },
      {
        code: 636,
        name: 'ATENDIMENTO E ENCAMINHAMENTO À VITIMAS DE RACISMO, RACISMO INSTITUCIONAL, DISCRIMINAÇÃO E XENOFOBIA.'
      },
      {
        code: 639,
        name: 'ORIENTAÇÃO ÀS PREFEITURAS PARA A CRIAÇÃO DOS CONSELHOS MUNICIPAIS DE POLÍTICAS DE IGUALDADE RACIAL (COMPIR).'
      },
      {
        code: 641,
        name: 'ISENÇÃO DO ICMS PARA TÁXI'
      },
      {
        code: 642,
        name: 'ELABORAÇÃO DE MINIAGENDA DE VIAGEM INTERNACIONAL DO GOVERNADOR.'
      },
      {
        code: 649,
        name: 'ANÁLISE JURÍDICA DE CONTRATOS FIRMADOS ENTRE O GABGOV E EMPRESAS OU ENTIDADES DA SOCIEDADE CIVIL.'
      },
      {
        code: 650,
        name: 'ELABORAÇÃO DE PORTARIAS E PARECERES JURÍDICOS REFERENTES À DESIGNAÇÃO DE COLABORADORES EVENTUAIS.'
      },
      {
        code: 652,
        name: 'ELABORAÇÃO E ANÁLISE DE TERMOS DE COOPERAÇÃO TÉCNICA E CONVÊNIOS FIRMADOS ENTRE O GABGOV, OUTROS ÓRGÃOS DA ADMINISTRAÇÃO PÚBLICA E EMPRESAS.'
      },
      {
        code: 675,
        name: 'ELABORAÇÃO DA REDAÇÃO DA PATENTE-PESSOA FÍSICA'
      },
      {
        code: 676,
        name: 'ELABORAÇÃO DA REDAÇÃO DA PATENTE-PESSOA JURÍDICA'
      },
      {
        code: 680,
        name: 'PROGRAMA ESTADUAL DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS - PREVINA'
      },
      {
        code: 685,
        name: 'CONSULTORIA NA ÁREA DE PROPRIEDADE INDUSTRIAL DE INOVAÇÃO'
      },
      {
        code: 686,
        name: 'PEDIDO DE REGISTRO DE INDICAÇÃO GEOGRAFICA'
      },
      {
        code: 689,
        name: 'CERTIFICAÇÃO DE SISTEMA DE GESTÃO DA QUALIDADE ISO 9001'
      },
      {
        code: 707,
        name: 'DETERMINAÇÃO DE FIBRA BRUTA EM ALIMENTOS'
      },
      {
        code: 712,
        name: 'LAUDO TÉCNICO'
      },
      {
        code: 716,
        name: 'PERMISSÃO PARA DIRIGIR ( 1º HABILITAÇÃO)'
      },
      {
        code: 718,
        name: 'MUDANÇA DE CATEGORIA'
      },
      {
        code: 721,
        name: '2ª VIA CNH(CARTEIRA DE HABILITAÇÃO)'
      },
      {
        code: 725,
        name: 'ENCONTROS DE CONVIVÊNCIA (COFFEE-BREAK, COQUETEL, ALMOÇO, JANTAR, ETC).'
      },
      {
        code: 727,
        name: 'EXPEDIÇÃO DE 2º VIA DE LAUDO PERICIAL.'
      },
      {
        code: 728,
        name: 'IDENTIFICAÇÃO DE PERFIS GENÉTICOS DEIXADOS EM LOCAIS DE CRIMES VARIADOS (CRIMINALÍSTICA BIOLÓGICA) E COMPARAÇÃO COM SUSPEITOS'
      },
      {
        code: 729,
        name: 'EXAME DE CONSTATAÇÃO DA PRESENÇA DE ESPERMA EM MANCHAS.'
      },
      {
        code: 730,
        name: 'EXAME DE CONSTATAÇÃO DA PRESENÇA DE SANGUE HUMANO EM MANCHAS.'
      },
      {
        code: 732,
        name: 'EXAME DE DETECÇÃO DA PRESENÇA DO HORMÔNIO GONADOTROFINA CORIÔNICA (HCG) EM AMOSTRAS DE URINA.'
      },
      {
        code: 733,
        name: 'EXAME DE CONSTATAÇÃO DA PRESENÇA DE CORPOS ESTRANHOS DE ORIGEM BIOLÓGICA EM ALIMENTOS.'
      },
      {
        code: 744,
        name: 'PROMOÇÃO E PARTICIPAÇÃO NO FÓRUM NACIONAL DE SECRETÁRIOS E GESTORES ESTADUAIS DE JUVENTUDE'
      },
      {
        code: 746,
        name: 'PROMOÇÃO DO FÓRUM ESTADUAL DE GESTORES MUNICIPAIS DE JUVENTUDE DO CEARÁ'
      },
      {
        code: 748,
        name: 'PROMOÇÃO DA SEMANA ESTADUAL DE MOBILIZAÇÃO DA JUVENTUDE'
      },
      {
        code: 749,
        name: 'REALIZAR REUNIÕES DE NIVELAMENTO DE INFORMAÇÃO SOBRE POLÍTICAS PÚBLICAS DE JUVENTUDE E INTEGRAÇÃO COM AS DEMAIS COORDENADORIAS DO GABINETE DO GOVERNADOR'
      },
      {
        code: 752,
        name: 'REALIZAR REUNIÕES DE NIVELAMENTO DE INFORMAÇÃO SOBRE POLÍTICAS PÚBLICAS DE JUVENTUDE E INTEGRAÇÃO COM AS ENTIDADES E MOVIMENTOS ESTUDANTIS DO CEARÁ'
      },
      {
        code: 753,
        name: 'PROMOÇÃO DO ENCONTRO DA REDE DE CONSELHOS MUNICIPAIS DE JUVENTUDE DO ESTADO DO CEARÁ'
      },
      {
        code: 754,
        name: 'REALIZAÇÃO DE REUNIÕES DO CONSELHO ESTADUAL DE POLÍTICAS PÚBLICAS DE JUVENTUDE DO ESTADO DO CEARÁ'
      },
      {
        code: 755,
        name: 'REALIZAÇÃO DE FÓRUNS DE POLÍTICAS PÚBLICAS DE JUVENTUDE DURANTE O GOVERNO NA MINHA CIDADE'
      },
      {
        code: 756,
        name: 'REALIZAÇÃO DO FESTIVAL DOS GRÊMIOS ESTUDANTIS DO CEARÁ'
      },
      {
        code: 929,
        name: 'QUALIDADE DE AREIA'
      },
      {
        code: 757,
        name: 'CURSOS DE QUALIFICAÇÃO DE GESTORES MUNICIPAIS EM POLÍTICAS PÚBLICAS DE JUVENTUDE'
      },
      {
        code: 758,
        name: 'COMEMORAÇÃO DO DIA DO ESTUDANTE'
      },
      {
        code: 760,
        name: 'SERVIÇO DE PSICOLOGIA'
      },
      {
        code: 761,
        name: 'REALIZAR ORIENTAÇÕES ÀS PREFEITURAS PARA CRIAÇÃO DOS CONSELHOS MUNICIPAIS DE JUVENTUDE'
      },
      {
        code: 762,
        name: 'REALIZAR ORIENTAÇÕES ÀS PREFEITURAS PARA CRIAÇÃO DOS ÓRGÃOS MUNICIPAIS DE JUVENTUDE'
      },
      {
        code: 763,
        name: 'ATENDIMENTOS A PREFEITOS E SECRETÁRIOS MUNICIPAIS E A SECRETÁRIOS E GESTORES DO ESTADO DO CEARÁ'
      },
      {
        code: 765,
        name: 'ACOMPANHAMENTO DO PROGRAMA 021 - PROMOÇÃO DE POLÍTICAS DE JUVENTUDE'
      },
      {
        code: 767,
        name: 'ACOMPANHAMENTO E ATUALIZAÇÃO DOS MAPPS DA COJUV'
      },
      {
        code: 771,
        name: 'ALTERAÇÃO DE CARACTERÍSTICAS COM LAUDO CSV'
      },
      {
        code: 772,
        name: 'LIBERAÇÃO DE ANIMAIS APREENDIDOS'
      },
      {
        code: 775,
        name: 'VISTORIA VEICULAR'
      },
      {
        code: 778,
        name: 'ASPECTO EM ÓLEO DIESEL(VISUAL)'
      },
      {
        code: 779,
        name: 'CINZAS EM CERAS E OUTROS'
      },
      {
        code: 780,
        name: 'COR-(COLORIMETRO)-EM OLEOS E GRAXAS NATURAIS'
      },
      {
        code: 781,
        name: 'COR EM OLEO DIESEL-ASTM D1500/ABNT 14483'
      },
      {
        code: 782,
        name: 'DENSIDADE EM OLÉO ISOLANTE E LCC E OUTROS'
      },
      {
        code: 785,
        name: 'EXTRAÇÃO DE OLEOS/GORDURAS DE SEMENTE PARA CARACTERIZAÇÃO'
      },
      {
        code: 786,
        name: 'MUDANÇA DE CATEGORIA'
      },
      {
        code: 789,
        name: 'SERVIÇO DE COMPRAS'
      },
      {
        code: 790,
        name: 'IMPUREZAS INSOLÚVEIS EM CERA DE CARNAÚBA E DE ABELHA.'
      },
      {
        code: 791,
        name: 'INDICE E ACIDEZ OU INDICE DE NEUTRALIZAÇÃO EM MATERIAS DIVERSOS'
      },
      {
        code: 796,
        name: 'MUDANÇA DE MUNICÍPIO'
      },
      {
        code: 797,
        name: 'INDICE DE SAPONIFICAÇÃO EM OLÉOS E GRAXAS'
      },
      {
        code: 798,
        name: 'MASSA ESPECÍFICA EM OLEO DIESEL ABNT 7148,14065/ASTM D 1298,D4052'
      },
      {
        code: 803,
        name: 'PH EM OLÉOS E OUTROS'
      },
      {
        code: 809,
        name: 'TEOR ALCOOLICO EM GASOLINA'
      },
      {
        code: 812,
        name: 'VISCOSIDADE EM LCC.'
      },
      {
        code: 813,
        name: 'VISCOSIDADE EM OLEO DIESEL,ABNT 10441,ASTM D-445'
      },
      {
        code: 814,
        name: 'ALTERAÇÃO DE DADOS DO PROPRIETÁRIO'
      },
      {
        code: 815,
        name: 'ATUALIZAÇÃO DE ENDEREÇO'
      },
      {
        code: 816,
        name: 'VEÍCULO DE COLEÇÃO'
      },
      {
        code: 817,
        name: 'UPLICIDADE DE CHASSI'
      },
      {
        code: 818,
        name: 'MONITORAMENTO DAS POLÍTICAS PÚBLICAS DE GARANTIA DE DIREITOS PARA A PESSOA IDOSA E A PESSOA COM DEFICIÊNCIA'
      },
      {
        code: 819,
        name: 'PLACAS ESPECIAIS'
      },
      {
        code: 820,
        name: 'FOMENTAR A CRIAÇÃO DOS CONSELHOS MUNICIPAIS DE DIREITOS DA PESSOA COM DEFICIÊNCIA JUNTO ÀS PREFEITURAS DO ESTADO DO CEARÁ'
      },
      {
        code: 821,
        name: 'PLACA RESERVADA'
      },
      {
        code: 822,
        name: '2ª VIA DO CRV OU DO CRLV'
      },
      {
        code: 823,
        name: 'ALCALINIDADE EM ÁGUA E EFLUENTES (TOTAL/PARCIAL)'
      },
      {
        code: 824,
        name: 'ATENDIMENTO AOS SERVIDORES DO PALÁCIO DA ABOLIÇÃO.'
      },
      {
        code: 826,
        name: 'TRANSFERÊNCIA DE PROPRIEDADE'
      },
      {
        code: 828,
        name: 'DESENVOLVIMENTO E ADAPTAÇÃO DE SISTEMAS.'
      },
      {
        code: 829,
        name: 'RENOVAÇÃO DA CNH(CARTEIRA DE HABILITAÇÃO)'
      },
      {
        code: 830,
        name: 'SERVIÇO DE ENFERMAGEM'
      },
      {
        code: 832,
        name: 'PROVIMENTO DE INFRA-ESTRUTURA.'
      },
      {
        code: 834,
        name: 'RECEPÇÃO E ACOMPANHAMENTO AO GOVERNADOR NAS REUNIÕES DO MAPP (MONITORAMENTO DE AÇÕES E PROGRAMAS PRIORITÁRIOS)'
      },
      {
        code: 836,
        name: 'SETOR DE FINANÇAS'
      },
      {
        code: 838,
        name: 'REPRESENTAÇÃO DO GOVERNADOR DO ESTADO DO CEARÁ EM EVENTOS OFICIAIS E NÃO OFICIAIS'
      },
      {
        code: 839,
        name: 'SERVIÇO DE MASTOLOGIA'
      },
      {
        code: 840,
        name: 'ORGANIZAÇÃO DA ESTRUTURA LOGÍSTICA PARA A REALIZAÇÃO DE EVENTOS DO GOVERNADOR DO ESTADO DO CEARÁ.'
      },
      {
        code: 843,
        name: 'ATLAS ELETRÔNICO DOS RECURSOS HÍDRICOS DO ESTADO DO CEARÁ'
      },
      {
        code: 850,
        name: 'ACOMPANHAMENTO DAS POLÍTICAS PÚBLICAS DE JUVENTUDE'
      },
      {
        code: 851,
        name: 'GESTÃO DOS PROGRAMAS NACIONAIS DE INCLUSÃO DE JOVENS (PROJOVEM URBANO E PROJOVEM CAMPO)'
      },
      {
        code: 852,
        name: 'CENTRO CIRÚRGICO'
      },
      {
        code: 853,
        name: 'ATENDER A PREFEITOS E A SECRETÁRIOS MUNICIPAIS'
      },
      {
        code: 855,
        name: 'ENCAMINHAMENTO DE OFÍCIOS COM A FREQUÊNCIA DOS SERVIDORES CEDIDOS AO GABINETE DO GOVERNADOR.'
      },
      {
        code: 862,
        name: 'CENTRO DE ESTUDOS DR.ROCHA FURTADO'
      },
      {
        code: 866,
        name: 'ACOMPANHAR O GOVERNADOR NO EVENTO DA PARADA MILITAR DO DIA 7 DE SETEMBRO'
      },
      {
        code: 868,
        name: 'AGRADECIMENTO DOS CONVITES DESTINADOS AO GOVERNADOR E SECRETÁRIO-CHEFE DO GABINETE DO GOVERNADOR'
      },
      {
        code: 869,
        name: 'POSSE DO GOVERNADOR E DO VICE-GOVERNADOR DO ESTADO E NOMEAÇÃO DO SECRETARIADO'
      },
      {
        code: 871,
        name: 'ELABORAÇÃO DOS ATOS DE NOMEAÇÃO, DESIGNAÇÃO, EXONERAÇÃO E CESSÃO DE EFEITOS RELATIVOS AOS CARGOS DE DIRIGENTES MÁXIMOS DO PODER EXECUTIVO EST'
      },
      {
        code: 876,
        name: 'ALCALINIDADE LIVRE EM PRODUTOS DE LIMPEZA'
      },
      {
        code: 879,
        name: 'CONCENTRAÇÃO DE ÁCIDO MURIÁTICO OU DE ÁCIDO CLORÍDRICO'
      },
      {
        code: 880,
        name: 'CONCENTRAÇÃO DE ÁCIDO ACETICO'
      },
      {
        code: 885,
        name: 'CONCENTRAÇÃO DE HIDROXIDO DE SÓDIO/SODA CAUSTICA'
      },
      {
        code: 887,
        name: 'CLORO ATIVO EM HIPOCLORITO DE SÓDIO E ÁGUA SANITÁRIA'
      },
      {
        code: 891,
        name: 'ÍNDICE DE ACIDEZ OU ÍNDICE DE NEUTRALIZAÇÃO EM MATERIAS DIVERSOS'
      },
      {
        code: 892,
        name: 'INSOLUVEIS EM PRODUTOS DE LIMPEZA'
      },
      {
        code: 894,
        name: 'MATÉRIA ATIVA ANIÔNICA OU CATIÔNICA EM PRODUTOS DE LIMPEZA ÁCIDO SULFÔNICO E COSMÉTICO'
      },
      {
        code: 896,
        name: 'REALIZAÇÃO DE COTAÇÃO ELETRÔNICA'
      },
      {
        code: 898,
        name: 'PH EM MATERIAS DIVERSOS'
      },
      {
        code: 902,
        name: 'PREPARO DE SOLUÇÃO'
      },
      {
        code: 907,
        name: 'VOLUME DE ÁGUA OXIGENADA/PEROXIDO DE HIDROGENIO.'
      },
      {
        code: 908,
        name: 'CLORO ATIVO EM HIPOCLORITO DE CÁLCIO'
      },
      {
        code: 910,
        name: 'DENSIDADE/MASSA ESPECIFICA(DENSIMETRO OU PICNOMETRO)/PROD. DE LIMPEZA E COSMÉTICO.'
      },
      {
        code: 913,
        name: 'VISCOSIDADE EM PRODUTOS DE LIMPEZA E OUTROS'
      },
      {
        code: 914,
        name: 'CONCESSÃO DE BOLSAS - AGENTES DE LEITURA'
      },
      {
        code: 916,
        name: 'COMPOSIÇÃO GRANULOMÉTRICA DE UM AGREGADO MIÚDO (AREIA)'
      },
      {
        code: 917,
        name: 'COMPOSIÇÃO GRANULOMÉTRICA DE UM AGREGADO GRAÚDO (BRITA)'
      },
      {
        code: 918,
        name: 'MASSA UNITÁRIA EM ESTADO SOLTO DO AGREGADO MIÚDO (AREIA)'
      },
      {
        code: 919,
        name: 'MASSA UNITÁRIA EM ESTADO SOLTO DO AGREGADO GRAÚDO (BRITA)'
      },
      {
        code: 920,
        name: 'MASSA ESPECÍFICA DE AGREGADO MIÚDO (AREIA)'
      },
      {
        code: 921,
        name: 'MASSA ESPECÍFICA DE AGREGADO GRAÚDO (BRITA)'
      },
      {
        code: 922,
        name: 'MASSA UNITÁRIA EM ESTADO COMPACTADO DO AGREGADO GRAÚDO (BRITA)'
      },
      {
        code: 923,
        name: 'INCHAMENTO DE AREIA'
      },
      {
        code: 924,
        name: 'AVALIAÇÃO DE IMPUREZAS ORGÂNICAS EM AREIA'
      },
      {
        code: 925,
        name: 'TEOR DE ARGILA EM TORRÕES DE AGREGADO MIÚDO (AREIA)'
      },
      {
        code: 926,
        name: 'TEOR DE ARGILA EM TORRÕES DE AGREGADO GRAÚDO (BRITA)'
      },
      {
        code: 927,
        name: 'TEOR DE MATERIAL PULVERULENTO EM AGREGADO MIÚDO (AREIA)'
      },
      {
        code: 928,
        name: 'TEOR DE MATERIAL PULVERULENTO EM AGREGADO GRAÚDO (BRITA)'
      },
      {
        code: 930,
        name: 'ÍNDICE DE FORMA PELO MÉTODO DO PAQUÍMETRO (BRITA)'
      },
      {
        code: 931,
        name: 'ATENDER ÀS ORGANIZAÇÕES DA SOCIEDADE CIVIL QUE ATUEM NA ÁREA DOS DIREITOS HUMANOS.'
      },
      {
        code: 932,
        name: 'UMIDADE (ABSORÇÃO) DO AGREGADO MIÚDO (AREIA)'
      },
      {
        code: 933,
        name: 'FORMAÇÃO DE LEITORES - PROJETO AGENTES DE LEITURA'
      },
      {
        code: 934,
        name: 'UMIDADE (ABSORÇÃO) DO AGREGADO GRAÚDO (BRITA)'
      },
      {
        code: 935,
        name: 'ABSORÇÃO DE ÁGUA DO AGREGADO GRAÚDO'
      },
      {
        code: 936,
        name: 'ABRASÃO "LOS ANGELES" DE AGREGADO'
      },
      {
        code: 937,
        name: 'ÍNDICE DE FORMA PARA LASTRO PADRÃO'
      },
      {
        code: 938,
        name: 'TOLERÂNCIA DE PARTÍCULAS LAMELARES PARA LASTRO PADRÃO'
      },
      {
        code: 939,
        name: 'FINURA DO CIMENTO'
      },
      {
        code: 940,
        name: 'TEMPO DE INÍCIO E FIM DE PEGA'
      },
      {
        code: 941,
        name: 'EXPANSIBILIDADE DE VOLUME "LE CHATELIER"- CIMENTO'
      },
      {
        code: 943,
        name: 'RESISTÊNCIA À COMPRESSÃO AXIAL-CIMENTO'
      },
      {
        code: 944,
        name: 'ATENDER A SECRETÁRIOS E GESTORES DO ESTADO DO CEARÁ'
      },
      {
        code: 945,
        name: 'MASSA ESPECÍFICA - CIMENTO'
      },
      {
        code: 946,
        name: 'RESISTÊNCIA À COMPRESSÃO EM CORPOS-DE-PROVA CILÍNDRICOS DE CONCRETO E ARGAMASSA'
      },
      {
        code: 947,
        name: 'RESISTÊNCIA À COMPRESSÃO DIAMETRAL DE CORPO DE PROVA CILÍNDRICO DE CONCRETO ARMADO'
      },
      {
        code: 948,
        name: 'DOSAGEM DE UM TRAÇO DE CONCRETO A PARTIR DE MISTURAS EXPERIMENTAIS COM 01 AGREGADO MIÚDO E GRAÚDO'
      },
      {
        code: 950,
        name: 'APOIAR ATIVIDADES ACADÊMICAS NA ÁREA DOS DIREITOS HUMANOS'
      },
      {
        code: 951,
        name: 'RESISTÊNCIA À COMPRESSÃO DE TESTEMUNHO'
      },
      {
        code: 953,
        name: 'ABSORÇÃO DE ÁGUA POR IMERSÃO, ÍNDICE DE VAZIOS E MASSA ESPECÍFICA EM ARGAMASSAS DE CONCRETO ENDURECIDOS.'
      },
      {
        code: 954,
        name: 'CARBONATAÇÃO'
      },
      {
        code: 955,
        name: 'RESISTÊNCIA À ADERÊNCIA DE ARGAMASSA COLANTE - CURA NORMAL'
      },
      {
        code: 956,
        name: 'RESISTÊNCIA À ADERÊNCIA DE ARGAMASSA COLANTE - CURA IMERSA EM ÁGUA'
      },
      {
        code: 957,
        name: 'RESISTÊNCIA À ADERÊNCIA DE ARGAMASSA COLANTE - CURA EM ESTUFA'
      },
      {
        code: 958,
        name: 'RESISTÊNCIA DE ADERÊNCIA IN LOCO EM ARGAMASSA'
      },
      {
        code: 959,
        name: 'TEMPO EM ABERTO EM ARGAMASSA COLANTE'
      },
      {
        code: 960,
        name: 'RESISTÊNCIA À COMPRESSÃO EM PREMOLDADOS PARA PAVIMENTAÇÃO'
      },
      {
        code: 961,
        name: 'ABSORÇÃO DE ÁGUA EM POSTES E CRUZETAS DE CONCRETO'
      },
      {
        code: 962,
        name: 'UMIDADE E ABSORÇÃO EM BLOCOS VAZADOS DE CONCRETO PARA ALVENARIA'
      },
      {
        code: 963,
        name: 'RESISTÊNCIA À COMPRESSÃO DE BLOCOS VAZADOS DE CONCRETO PARA ALVENARIA - COM LARGURA DE 09 CM'
      },
      {
        code: 964,
        name: 'RESISTÊNCIA À COMPRESSÃO DE BLOCOS VAZADOS DE CONCRETO PARA ALVENARIA - COM LARGURA DE 14 CM'
      },
      {
        code: 965,
        name: 'RESISTÊNCIA À COMPRESSÃO DE BLOCOS VAZADOS DE CONCRETO PARA ALVENARIA - COM LARGURA DE 19 CM'
      },
      {
        code: 966,
        name: 'VARIAÇÃO DIMENSIONAL LINEAR EM BLOCOS VAZADOS DE CONCRETO'
      },
      {
        code: 967,
        name: 'RESISTÊNCIA À COMPRESSÃO EM TIJOLO MACIÇO'
      },
      {
        code: 968,
        name: 'RESISTÊNCIA À COMPRESSÃO EM BLOCO CERÂMICO COM A MENOR FACE DESTINADA AO ASSENTAMENTO.'
      },
      {
        code: 969,
        name: 'RESISTÊNCIA À COMPRESSÃO EM BLOCO CERÂMICO COM A MAIOR FACE DESTINADA AO ASSENTAMENTO.'
      },
      {
        code: 971,
        name: 'MASSA E ABSORÇÃO EM TELHAS TIPO CAPA E CANAL'
      },
      {
        code: 973,
        name: 'ABSORÇÃO DE ÁGUA EM BLOCO DE SOLO-CIMENTO'
      },
      {
        code: 975,
        name: 'RESISTÊNCIA À COMPRESSÃO EM BLOCO CERÂMICO COM LARGURA DE 09 CM'
      },
      {
        code: 976,
        name: 'RESISTÊNCIA À COMPRESSÃO EM BLOCO CERÂMICO COM LARGURA DE 14 CM'
      },
      {
        code: 977,
        name: 'RESISTÊNCIA À COMPRESSÃO EM BLOCO CERÂMICO COM LARGURA DE 19 CM'
      },
      {
        code: 980,
        name: 'ABSORÇÃO DE ÁGUA EM REVESTIMENTO CERÂMICO'
      },
      {
        code: 981,
        name: 'ENSAIO DE TRAÇÃO EM BARRAS E FIOS DE AÇO (VERGALHÃO)'
      },
      {
        code: 984,
        name: 'ENSAIO DE TRAÇÃO EM CHAPA SOLDADA'
      },
      {
        code: 985,
        name: 'FINURA DA CAL'
      },
      {
        code: 986,
        name: 'INDICAÇÃO DE CONDUTOR INFRATOR'
      },
      {
        code: 987,
        name: 'CONCESSÃO DE PASSAGEM AÉREA'
      },
      {
        code: 988,
        name: 'ELABORAÇÃO DE PORTARIAS: ALIMENTAÇÃO, TRANSPORTE, BOLSA ESTÁGIO, NOMEAÇÃO E EXONERAÇÃO, E CONCESSÃO DE DIÁRIAS E AJUDA DE CUSTO.'
      },
      {
        code: 989,
        name: 'ELABORAÇÃO DA FOLHA DE PAGAMENTO DOS SERVIDORES E ESTAGIÁRIOS'
      },
      {
        code: 990,
        name: 'EXAME RESIDUOGRÁFICO EM AMOSTRAS COLETADAS EM SUSPEITOS - PESQUISA DE CHUMBO EM MÃOS.'
      },
      {
        code: 991,
        name: 'PROGRAMA DE CONTROLE DO CÂNCER DO COLO DO ÚTERO'
      },
      {
        code: 992,
        name: 'GESTÃO DO CONTRATO DE TERCEIRIZAÇÃO DE MÃO-DE-OBRA'
      },
      {
        code: 994,
        name: 'EXAME RESIDUOGRÁFICO - COLETA E PESQUISA DE CHUMBO EM MÃOS E INDUMENTOS.'
      },
      {
        code: 997,
        name: 'EXAME DE CONSTATAÇÃO - ADULTERAÇÃO EM BEBIDAS ALCOÓLICAS'
      },
      {
        code: 998,
        name: 'EXAME DE CONSTATAÇÃO-ADULTERAÇÃO EM COMBUSTÍVEIS'
      },
      {
        code: 999,
        name: 'EXAME DE CONSTATAÇÃO - ADULTERAÇÃO EM PERFUME'
      },
      {
        code: 1001,
        name: 'EXAME FÍSICO DESCRITIVO EM INDUMENTOS/VESTES.'
      },
      {
        code: 1003,
        name: 'EXAME FÍSICO DESCRITIVO DE CORPOS ESTRANHOS EM GÊNEROS ALIMENTÍCIOS.'
      },
      {
        code: 1004,
        name: 'EXAME METALOGRÁFICO - SERIAL DE ARMA DE FOGO.'
      },
      {
        code: 1005,
        name: 'EXAME QUÍMICO QUALITATIVO - IDENTIFICAÇÃO DE ÁLCOOL EM BEBIDA'
      },
      {
        code: 1006,
        name: 'EXAME QUÍMICO QUALITATIVO PARA IDENTIFICAÇÃO DE ÁCIDOS.'
      },
      {
        code: 1007,
        name: 'EXAME QUÍMICO QUALITATIVO PARA IDENTIFICAÇÃO DE ÁLCALIS.'
      },
      {
        code: 1008,
        name: 'EXAME QUÍMICO QUALITATIVO - IDENTIFICAÇÃO DE COBRE, OURO OU PRATA'
      },
      {
        code: 1009,
        name: 'EXAME QUÍMICO QUALITATIVO - IDENTIFICAÇÃO DE EXPLOSIVOS.'
      },
      {
        code: 1010,
        name: 'EXAME QUÍMICO QUALITATIVO - IDENTIFICAÇÃO DE SUBSTÂNCIAS INFLAMÁVEIS.'
      },
      {
        code: 1012,
        name: 'IDENTIFICAÇÃO DE CANNABIS SATIVA L. (MACONHA) E HAXIXE'
      },
      {
        code: 1013,
        name: 'IDENTIFICAÇÃO DE COCAÍNA (EM PÓ E NA FORMA PÉTREA)'
      },
      {
        code: 1014,
        name: 'IDENTIFICAÇÃO DE ECSTASY (MDMA)'
      },
      {
        code: 1015,
        name: 'IDENTIFICAÇÃO MEDICAMENTO COMPRIMIDO DIAZEPAM, CLONAZEPAM (RIVOTRIL), BROMAZEPAM, NITRAZEPAM, FLUNITRAZEPAM (ROPNOL), TRIEXAFENIDIL (ARTANE)'
      },
      {
        code: 1016,
        name: 'IDENTIFICAÇÃO DE ÁCIDO LISÉRGICO LSD'
      },
      {
        code: 1018,
        name: 'PDU (PESQUISA DE DROGAS EM URINA)'
      },
      {
        code: 1019,
        name: 'PDS (PESQUISA DE DROGAS EM SANGUE)'
      },
      {
        code: 1022,
        name: 'IDENTIFICAÇÃO DE VOLÁTEIS COMPONENTES DO LOLÓ, LANÇA-PERFUME E COLAS'
      },
      {
        code: 1023,
        name: 'ACOMPANHAR E DIVULGAR AOS SERVIDORES DO GABINETE DO GOVERNADOR AS DELIBERAÇÕES E ATIVIDADES DO GRUPO TÉCNICO DE GESTÃO DE DES. DE PESSOAS.'
      },
      {
        code: 1024,
        name: 'INTERNAÇÃO ELETIVA CLÍNICA'
      },
      {
        code: 1025,
        name: 'EMERGÊNCIA OBSTÉTRICA'
      },
      {
        code: 1026,
        name: 'ATENDIMENTO DE URGÊNCIA E EMERGÊNCIA'
      },
      {
        code: 1029,
        name: 'SETOR DE ARQUIVO MÉDICO E ESTATÍSTICO'
      },
      {
        code: 1032,
        name: 'MANUTENÇÃO E CONFIGURAÇÃO DA CENTRAL DE TELEFONIA FIXA DO PALACIO DA ABOLIÇÃO'
      },
      {
        code: 1033,
        name: 'SUPORTE À TV POR ASSINATURA DO GOVERNADOR, RESIDÊNCIA OFICIAL E ESCRITÓRIO EM BRASÍLIA.'
      },
      {
        code: 1035,
        name: 'SISTEMA DE AUTOMAÇÃO'
      },
      {
        code: 1037,
        name: 'SUPORTE AO ESCRITÓRIO DO GABINETE DO GOVERNADOR'
      },
      {
        code: 1047,
        name: 'CADASTRAMENTO DE PROPOSTA DE EMPENHO'
      },
      {
        code: 1048,
        name: 'SOLICITAÇÃO DE CRIAÇÃO DE CONTA DE CORREIO ELETRÔNICO DA DEFENSORIA PÚBLICA'
      },
      {
        code: 1049,
        name: 'FOMENTAR A CRIAÇÃO DOS CONSELHOS MUNICIPAIS DE DIREITOS DO IDOSO DO ESTADO DO CEARÁ.'
      },
      {
        code: 1050,
        name: 'CONCESSÃO DE SUPRIMENTO DE FUNDOS'
      },
      {
        code: 1053,
        name: 'EXAMES LABORATORIAIS'
      },
      {
        code: 1054,
        name: 'LABORATÓRIO DE PATOLOGIA'
      },
      {
        code: 1055,
        name: 'ESPECIALIZAÇÃO LATO SENSU'
      },
      {
        code: 1065,
        name: 'SEGURO-DESEMPREGO EMPREGADO DOMÉSTICO'
      },
      {
        code: 1066,
        name: 'SEGURO-DESEMPREGO DESEMPREGO FORMAL'
      },
      {
        code: 1067,
        name: 'SEGURO-DESEMPREGO BOLSA QUALIFICAÇÃO'
      },
      {
        code: 1069,
        name: 'SEGURO-DESEMPREGO PESCADOR ARTESANAL'
      },
      {
        code: 1071,
        name: 'JOVEM ESTAGIÁRIO'
      },
      {
        code: 1072,
        name: 'PRIMEIRO PASSO - JOVEM APRENDIZ'
      },
      {
        code: 1073,
        name: 'JOVEM BOLSISTA'
      },
      {
        code: 1074,
        name: 'INTERMEDIAÇÃO DE PROFISSIONAIS AUTÔNOMOS PRESTADORES DE SERVIÇOS. ATENDIMENTO AOS CLIENTES QUE NECESSITAM DE PROFISSIONAIS AUTÔNOMOS PARA EXECUTAR ALGUNS SERVIÇOS RÁPIDOS.'
      },
      {
        code: 1076,
        name: 'CADASTRO DE TRABALHADORES QUE DEMANDAM EMPREGOS.'
      },
      {
        code: 1084,
        name: 'EMISSÃO DE RG ( 1ª E 2ª VIA)'
      },
      {
        code: 1086,
        name: 'CAPTAÇÃO DE VAGAS'
      },
      {
        code: 1088,
        name: 'COFINANCIAMENTO ESTADUAL DO SERVIÇO DE PROTEÇÃO E ATENDIMENTO INTEGRAL À FAMÍLIA - PAIF'
      },
      {
        code: 1089,
        name: 'RECEBIMENTO DE SOLICITAÇÃO DE CARTEIRA DE TRABALHO E PREVIDÊNCIA SOCIAL (CTPS)'
      },
      {
        code: 1090,
        name: 'RECEBIMENTO DE SOLICITAÇÃO DE CARTEIRA DE TRABALHO E PREVIDÊNCIA SOCIAL (CTPS)'
      },
      {
        code: 1091,
        name: 'EMISSÃO DE NOTA DE PAGAMENTO'
      },
      {
        code: 1093,
        name: 'MATRÍCULA CURRICULAR'
      },
      {
        code: 1094,
        name: 'PESQUISA BIBLIOGRÁFICA NA ÁREA DA SAÚDE PÚBLICA'
      },
      {
        code: 1095,
        name: 'MATRÍCULA CLASSIFICADO NO VESTIBULAR'
      },
      {
        code: 1097,
        name: 'MATRICULA CLASSIFICAVEIS NO VESTIBULAR'
      },
      {
        code: 1098,
        name: 'MATRÍCULA INSTITUCIONAL'
      },
      {
        code: 1099,
        name: 'ELABORAÇÃO DA PRESTAÇÃO DE CONTAS ANUAL AO TRIBUNAL DE CONTAS DO ESTADO'
      },
      {
        code: 1102,
        name: 'EMISSÃO DA NOTA DE LIQUIDAÇÃO'
      },
      {
        code: 1110,
        name: 'GRUPO DE ESTUDOS DE INFORMAÇÃO E CONSCIÊNCIA HUMANA, GRUPO DE ESTUDOS DOS FÓRUNS UNIVERSITÁRIOS, OFICINA DE FORMAÇÃO DE POETAS URBANOS, PROJETO CASAS DE LUZ'
      },
      {
        code: 1114,
        name: 'OFICINA APRENDENDO A VIVER COM ACESSIBILIDADE (AVA)'
      },
      {
        code: 1117,
        name: 'EMISSÃO DE DECLARAÇÕES E CERTIFICADOS.'
      },
      {
        code: 1118,
        name: 'ENCAMINHAMENTO PARA PESQUISAS, TRABALHOS E ATIVIDADES ACADÊMICAS'
      },
      {
        code: 1120,
        name: 'CAPACITAÇÃO DAS CONSELHEIRAS, GESTORAS E PARLAMENTARES SOBRE A VIOLÊNCIA DE GÊNERO.'
      },
      {
        code: 1121,
        name: 'REALIZAÇÃO DE CENSO PENITENCIÁRIO COM RECORTE DE GÊNERO.'
      },
      {
        code: 1122,
        name: 'SENSIBILIZAÇÃO, PARTICIPAÇÃO E REALIZAÇÃO DE CONFERÊNCIAS DE MULHERES.'
      },
      {
        code: 1123,
        name: 'APRIMORAMENTO E FORTALECIMENTO DO CONSELHO CEARENSE DOS DIREITOS DA MULHER (CCDM)'
      },
      {
        code: 1125,
        name: 'APRIMORAMENTO E MONITORAMENTO DAS ESTATÍSTICAS DE VIOLÊNCIA CONTRA A MULHER.'
      },
      {
        code: 1126,
        name: 'MULTIPLICAÇÃO DOS CONSELHOS MUNICIPAIS DE DEFESA DOS DIREITOS DA MULHER.'
      },
      {
        code: 1127,
        name: 'FORMAÇÃO DE REDE ESTADUAL DE ATENDIMENTO À MULHER EM SITUAÇÃO DE VIOLÊNCIA.'
      },
      {
        code: 1128,
        name: 'INGRESSO COMO ALUNO GRADUADO'
      },
      {
        code: 1129,
        name: 'INGRESSO POR TRANSFERÊNCIA FACULTATIVA'
      },
      {
        code: 1130,
        name: 'ADMISSÃO ALUNO NÃO-REGULAR'
      },
      {
        code: 1131,
        name: 'DOAÇÃO DE LIVROS PARA BIBLIOTECAS COMUNITÁRIAS'
      },
      {
        code: 1135,
        name: 'EMPRÉSTIMO DE MATERIAL BIBLIOGRÁFICO E MULTIMÍDIA NA ÁREA DA SAÚDE PÚBLICA'
      },
      {
        code: 1148,
        name: 'INTERNAÇÃO PEDIÁTRICA E AMBULATÓRIOS ESPECIALIZADOS.'
      },
      {
        code: 1150,
        name: 'ANIDRIDO SULFÚRICO'
      },
      {
        code: 1170,
        name: 'ANÁLISE DE PROTOCOLOS DE PESQUISA E EMISSÃO DE PARECER PELO COMITÊ DE ÉTICA EM PESQUISA (CEP) DA ESP/CE'
      },
      {
        code: 1171,
        name: 'PODER DE NEUTRALIZAÇÃO DO CALCÁRIO - PN'
      },
      {
        code: 1173,
        name: 'PREPARAÇÃO DA AMOSTRA (ATÉ 100G)'
      },
      {
        code: 1182,
        name: 'EMISSÃO DE IDENTIDADE ARTESANAL.'
      },
      {
        code: 1184,
        name: 'AÇÃO DE REVISÃO DE CONTRATO DE CARTÃO DE CRÉDITO COM PEDIDO LIMINAR DE CONSIGNAÇÃO EM PAGAMENTO.'
      },
      {
        code: 1185,
        name: 'EXECUÇÃO DE ALIMENTOS'
      },
      {
        code: 1186,
        name: 'SOROLOGIA PARA HIV (ENSAIO IMUNOLÓGICO QUIMIOLUMINESCENTE)'
      },
      {
        code: 1187,
        name: 'APOIO A COMERCIALIZAÇÃO DO ARTESANATO'
      },
      {
        code: 1192,
        name: 'CERTIFICAÇÃO DE PRODUTOS ARTESANAIS - CURADORIA'
      },
      {
        code: 1201,
        name: 'CONSUMO DE ENERGIA DO MÓDULO'
      },
      {
        code: 1202,
        name: 'INSCRIÇÃO NO PROCESSO SELETIVO DE INCUBAÇÃO'
      },
      {
        code: 1203,
        name: 'TAXA DE OCUPAÇÃO DO MÓDULO'
      },
      {
        code: 1204,
        name: 'MONITORAMENTO DE CÂMERAS'
      },
      {
        code: 1205,
        name: 'TAXA DE PARTICIPAÇÃO SOBRE O FATURAMENTO DA INCUBADA'
      },
      {
        code: 1208,
        name: 'SUPORTE À RESIDÊNCIA OFICIAL DO GOVERNADOR'
      },
      {
        code: 1209,
        name: 'SUPORTE À CASA MILITAR (ALTA ADMINISTRAÇÃO)'
      },
      {
        code: 1210,
        name: 'AÇÃO DE ADOÇÃO'
      },
      {
        code: 1213,
        name: 'SUPORTE AO SECRETÁRIO CHEFE DO GABINETE DO GOVERNADOR'
      },
      {
        code: 1215,
        name: 'SUPORTE AO SECRETÁRIO CHEFE DA CASA CIVIL'
      },
      {
        code: 1216,
        name: 'AÇÃO DE GUARDA'
      },
      {
        code: 1217,
        name: 'SUPORTE AO ESCRITÓRIO DO GOVERNO DE BRASÍLIA'
      },
      {
        code: 1219,
        name: 'SOROLOGIA PARA HEPATITE B -HBEAG'
      },
      {
        code: 1220,
        name: 'SOROLOGIA PARA HEPATITE B -HBSAG'
      },
      {
        code: 1223,
        name: 'AÇÃO DE SUPRIMENTO DE AUTORIZAÇÃO DE VIAGEM'
      },
      {
        code: 1225,
        name: 'MEDIDA PROTETIVA DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1227,
        name: 'MEDIDA PROTETIVA DE INTERNAÇÃO'
      },
      {
        code: 1232,
        name: 'FISCALIZAÇÃO ECONÔMICO FINANCEIRA'
      },
      {
        code: 1234,
        name: 'WESTERN BLOT - WB'
      },
      {
        code: 1240,
        name: 'AÇÃO DE INVESTIGAÇÃO DE PATERNIDADE'
      },
      {
        code: 1241,
        name: 'INVESTIGAÇÃO DE PATERNIDADE PÓS-MORTEM.'
      },
      {
        code: 1242,
        name: 'FISCALIZAR USO DOS RECURSOS HÍDRICOS DE DOMÍNIO OU ADMINISTRADOS PELO ESTADO.'
      },
      {
        code: 1249,
        name: 'OFERTA DE PENSÃO ALIMENTÍCIA.'
      },
      {
        code: 1250,
        name: 'SOROLOGIA PARA SÍFLIS- VDRL'
      },
      {
        code: 1273,
        name: 'SOROLOGIA PARA HEPATITE A ANTI HAV IGM'
      },
      {
        code: 1276,
        name: 'EMPRÉSTIMO DOMICILIAR DE LIVROS ACESSÍVEIS'
      },
      {
        code: 1277,
        name: 'IMPRESSÃO BRAILLE'
      },
      {
        code: 1278,
        name: 'TRANSCRIÇÃO PARA O BRAILLE'
      },
      {
        code: 1279,
        name: 'OFICINA DE BRAILLE'
      },
      {
        code: 1280,
        name: 'PALESTRA BRAILLE'
      },
      {
        code: 1281,
        name: 'RECONHECIMENTO ÓTICO DE CARACTERES'
      },
      {
        code: 1282,
        name: 'CADASTRO DE USUÁRIO'
      },
      {
        code: 1283,
        name: 'CONSULTA LOCAL'
      },
      {
        code: 1284,
        name: 'LEVANTAMENTO BIBLIOGRÁFICO'
      },
      {
        code: 1285,
        name: 'PESQUISA A FONTE BIBLIOGRÁFICA'
      },
      {
        code: 1286,
        name: 'REPRODUÇÃO DE DOCUMENTOS'
      },
      {
        code: 1287,
        name: 'RESERVA DE LIVRO'
      },
      {
        code: 1288,
        name: 'INVESTIGAÇÃO DE PATERNIDADE PÓS-MORTE'
      },
      {
        code: 1289,
        name: 'RECONHECIMENTO DE MATERNIDADE.'
      },
      {
        code: 1290,
        name: 'SUSPENÇÃO DO DIREITO DE VISITAS.'
      },
      {
        code: 1291,
        name: 'AÇÃO DE SEPARAÇÃO DE CORPOS/AFASTAMENTO DO LAR'
      },
      {
        code: 1292,
        name: 'SUPRIMENTO DE IDADE/CONSENTIMENTO PARA O CASAMENTO'
      },
      {
        code: 1293,
        name: 'RECONHECIMENTO E DISSOLUÇÃO DE UNIÃO ESTÁVEL HOMOAFETIVA.'
      },
      {
        code: 1294,
        name: 'DIGITALIZAÇÃO DE MICROFILME'
      },
      {
        code: 1295,
        name: 'DISPONIBILIZAÇÃO DE MICROFILMES PARA CONSULTA'
      },
      {
        code: 1296,
        name: 'CADASTRO DE USUÁRIO DO CENTRO DIGITAL DO CEARÁ'
      },
      {
        code: 1297,
        name: 'DISPONIBILIZAÇÃO DA SALA DE VÍDEOS'
      },
      {
        code: 1298,
        name: 'DISPONIBILIZAÇÃO DE MICROCOMPUTADORES E INTERNET À SOCIEDADE'
      },
      {
        code: 1299,
        name: 'DISPONIBILIZAÇÃO DE JORNAIS E REVISTAS AOS USUÁRIOS'
      },
      {
        code: 1300,
        name: 'BIBLIOTECA VOLANTE'
      },
      {
        code: 1301,
        name: 'EMPRÉSTIMO DOMICILIAR DE LIVRO'
      },
      {
        code: 1302,
        name: 'CADASTRO DE USUÁRIO DO SETOR DE OBRAS RARAS'
      },
      {
        code: 1303,
        name: 'DISPONIBILIZAÇÃO DE OBRAS RARAS PARA PESQUISA'
      },
      {
        code: 1304,
        name: 'PROGRAMAÇÃO CULTURAL'
      },
      {
        code: 1305,
        name: 'CONTAÇÃO DE HISTÓRIA'
      },
      {
        code: 1306,
        name: 'VISITA GUIADA'
      },
      {
        code: 1310,
        name: 'DIVÓRCIO CONSENSUAL'
      },
      {
        code: 1312,
        name: 'PARTILHA DE BENS.'
      },
      {
        code: 1313,
        name: 'SUBSTITUIÇÃO E REMOÇÃO DE CURADOR'
      },
      {
        code: 1314,
        name: 'EXONERAÇÃO DE PENSÃO ALIMENTÍCIA'
      },
      {
        code: 1315,
        name: 'RETIFICAÇÃO DE REGISTRO CIVIL DE NASCIMENTO, CASAMENTO OU ÓBITO'
      },
      {
        code: 1318,
        name: 'ABERTURA DE MICROEMPREENDEDOR INDIVIDUAL - MEI'
      },
      {
        code: 1319,
        name: 'ABERTURA DE MICROEMPRESA INDIVIDUAL'
      },
      {
        code: 1320,
        name: 'ADOÇÃO'
      },
      {
        code: 1321,
        name: 'ABERTURA DE MICROEMPRESA LTDA'
      },
      {
        code: 1322,
        name: 'AÇÃO DE GUARDA'
      },
      {
        code: 1323,
        name: 'INVESTIGAÇÃO DE PATERNIDADE'
      },
      {
        code: 1325,
        name: 'INVESTIGAÇÃO DE PATERNIDADE PÓS MORTE'
      },
      {
        code: 1326,
        name: 'TRANCAMENTO PARCIAL DE MATRÍCULA'
      },
      {
        code: 1327,
        name: 'NEGATÓRIA DE PATERNIDADE'
      },
      {
        code: 1328,
        name: 'SEPARAÇÃO DE CORPOS'
      },
      {
        code: 1329,
        name: 'INVESTIGAÇÃO DE MATERNIDADE'
      },
      {
        code: 1331,
        name: 'TRANCAMENTO TOTAL DE MATRÍCULA'
      },
      {
        code: 1332,
        name: 'PERÍCIA EM LOCAL DE ACIDENTE DE TRÂNSITO COM VITIMAS LESIONADAS E/OU FATAIS'
      },
      {
        code: 1333,
        name: 'FORNECIMENTO DE INFORMAÇÕES SOBRE O PROCESSO ADMINISTRATIVO TRIBUTÁRIO - PAT'
      },
      {
        code: 1344,
        name: 'ADOÇÃO DE MAIOR'
      },
      {
        code: 1345,
        name: 'AÇÃO DE TUTELA'
      },
      {
        code: 1346,
        name: 'ACOMPANHAMENTO E MONITORAMENTO DO CENSO ESCOLAR DA EDUCAÇÃO BÁSICA POR MEIO ELETRONICO VIA WEB - SISTEMA EDUCACENSO'
      },
      {
        code: 1347,
        name: 'LIBERDADE PROVISÓRIA'
      },
      {
        code: 1348,
        name: 'PEDIDO DE RELAXAMENTO DE PRISÃO'
      },
      {
        code: 1350,
        name: 'REMOÇÃO DE TUTOR'
      },
      {
        code: 1352,
        name: 'PESQUISAS HISTÓRICAS, ACESSO A ACERVOS DOCUMENTAIS PÚBLICOS DE 1700 A 2000.'
      },
      {
        code: 1355,
        name: 'EDUCAÇÃO BÁSICA PARA A POPULAÇÃO INDÍGENA'
      },
      {
        code: 1356,
        name: 'EDUCAÇÃO DE JOVENS E ADULTOS NAS UNIDADES PRISIONAIS DO CEARÁ.'
      },
      {
        code: 1357,
        name: 'DOAÇÃO E SISTEMATIZAÇÃO DE ACERVO'
      },
      {
        code: 1363,
        name: 'CONTRATAÇÃO DE PROFESSORES, COORDENADORES E ORIENTADORES DE ESTÁGIO DA ÁREA TÉCNICA PARA A EDUCAÇÃO PROFISSIONAL'
      },
      {
        code: 1364,
        name: 'DISTRIBUIÇÃO DO ACERVO PUBLICADO OU APOIADO PELA SECRETARIA DA CULTURA.'
      },
      {
        code: 1366,
        name: 'PEDIDO DE FÉRIAS DE DEFENSOR PÚBLICO'
      },
      {
        code: 1367,
        name: 'APROVEITAMENTO DE DISCIPLINAS CURSADA EM OUTRA INSTITUIÇÃO'
      },
      {
        code: 1368,
        name: 'ALVARÁ JUDICIAL'
      },
      {
        code: 1369,
        name: 'OBRIGAÇÃO DE FAZER PARA AQUISIÇÃO DE MEDICAMENTOS, OU REALIZAÇÃO DE EXAMES/CIRURGIAS/TRATAMENTOS DE SAÚDE'
      },
      {
        code: 1370,
        name: 'REINTEGRAÇÃO DE POSSE'
      },
      {
        code: 1372,
        name: 'RECONHECIMENTO DE PATERNIDADE'
      },
      {
        code: 1373,
        name: 'RECONHECIMENTO E DISSOLUÇÃO DE UNIÃO ESTÁVEL'
      },
      {
        code: 1374,
        name: 'AÇÃO REVISIONAL DE FINANCIAMENTO DE VEÍCULO.'
      },
      {
        code: 1375,
        name: 'RECONHECIMENTO E DISSOLUÇÃO DE UNIÃO HOMOAFETIVA.'
      },
      {
        code: 1376,
        name: 'REGULAMENTAÇÃO DE VISITA.'
      },
      {
        code: 1377,
        name: 'AÇÃO DE INDENIZAÇÃO POR DANOS MORAIS POR FATO OU VÍCIO DO PRODUTO OU SERVIÇO.'
      },
      {
        code: 1378,
        name: 'AÇÃO DE INDENIZAÇÃO POR DANOS MATERIAIS POR FATO OU VÍCIO DO PRODUTO OU SERVIÇO.'
      },
      {
        code: 1380,
        name: 'NECROPSIA PÓS-EXUMAÇÃO'
      },
      {
        code: 1387,
        name: 'DOCUMENTO DE IDENTIFICAÇÃO CIVIL - SEDE DA COORDENADORIA DE IDENTIFICAÇÃO HUMANA E PERÍCIAS BIOMÉTRICAS'
      },
      {
        code: 1389,
        name: 'PERÍCIA DE IDENTIFICAÇÃO VEICULAR'
      },
      {
        code: 1390,
        name: 'ELISA PARA CHAGAS'
      },
      {
        code: 1392,
        name: 'EXECUÇÃO DE ALIMENTOS'
      },
      {
        code: 1394,
        name: 'DOSAGEM DE FENILCETONÚRIA (ENSAIO ENZIMÁTICO COLORIMÉTRICO)'
      },
      {
        code: 1397,
        name: 'EXONERAÇÃO DE ALIMENTOS'
      },
      {
        code: 1398,
        name: 'SETOR DE IMAGEM (RADIOLOGIA)'
      },
      {
        code: 1399,
        name: 'MAJORAÇÃO DE ENCARGOS/ AUMENTO DA PENSÃO'
      },
      {
        code: 1401,
        name: 'VISITAS ÀS 24 UNIDADES DE ACOLHIMENTO DE FORTALEZA PARA ACOMPANHAMENTO DOS PROCEDIMENTOS ADMINISTRATIVOS REFERENTES ÀS CRIANÇAS E ADOLESCENTES ACOLHIDOS'
      },
      {
        code: 1402,
        name: 'REDUÇÃO DE PENSÃO/REVISIONAL DE ALIMENTOS'
      },
      {
        code: 1404,
        name: 'SUBSTITUIÇÃO/REMOÇÃO DE CURADOR'
      },
      {
        code: 1405,
        name: 'AÇÃO DECLARATÓRIA DE INEXISTÊNCIA OU NULIDADE DE CONTRATO C/C REPETIÇÃO DE INDÉBITO, DANOS MORAIS E PEDIDO DE TUTELA ANTECIPADA'
      },
      {
        code: 1406,
        name: 'CUMPRIMENTO DO CONTRATO DE RELAÇÃO DE CONSUMO C/C INDENIZAÇÃO E COM PEDIDO DE ANTECIPAÇÃO PARCIAL DE TUTELA'
      },
      {
        code: 1407,
        name: 'FORNECIMENTO DE CERTIDÕES DE INTEIRO TEOR, CERTIDÃO DE NASCIMENTO, CERTIDÃO DE CASAMENTO, CERTIDÃO DE ÓBITO, ESCRITURAS DE COMPRA E VENDA DE IMÓVEIS, INVENTÁRIOS, TESTAMENTOS, BUSCAS, TRANSCRIÇÕES E DESARQUIVAMENTOS DO SETOR DO NOTARIADO E DO JUDICIÁRIO DA CAPITAL - CARTÓRIOS DA CAPITAL'
      },
      {
        code: 1408,
        name: 'DEFENSORIA DA INFÂNCIA E JUVENTUDE'
      },
      {
        code: 1409,
        name: 'AÇÃO DE OBRIGAÇÃO DE FAZER C/C INDENIZAÇÃO E COM PEDIDO DE ANTECIPAÇÃO PARCIAL DE TUTELA EM DESFAVOR DE PLANO DE SAÚDE'
      },
      {
        code: 1410,
        name: 'DESGASTE POR ABRASÃO (AMSLER)'
      },
      {
        code: 1411,
        name: 'DESCRIÇÃO PETROGRÁFICA COM CONFECÇÃO DE LÂMINA'
      },
      {
        code: 1420,
        name: 'RESISTÊNCIA À COMPRESSÃO UNIAXIAL AO NATURAL'
      },
      {
        code: 1428,
        name: 'DETERMINAÇÃO DO COEFICIENTE DE DILATAÇÃO TÉRMICA LINEAR EM ROCHAS'
      },
      {
        code: 1429,
        name: 'FLEXÃO POR CARREGAMENTO EM QUATRO PONTOS EM ROCHA'
      },
      {
        code: 1432,
        name: 'AÇÃO DE OBRIGAÇÃO DE FAZER POR VÍCIO DO PRODUTO/SERVIÇO'
      },
      {
        code: 1434,
        name: 'MANUTENÇÃO DE POSSE'
      },
      {
        code: 1436,
        name: 'INCENTIVOS FISCAIS, FINANCEIROS E DE INFRAESTRUTURA ÁS ATIVIDADES COMERCIAIS VAREJISTAS DO ESTADO DO CEARÁ.'
      },
      {
        code: 1437,
        name: 'DETERMINAÇÃO DA COR DA ÁGUA'
      },
      {
        code: 1438,
        name: 'NOTIFICAÇÃO JUDICIAL PARA A DEVOLUÇÃO DE COISA EMPRESTADA'
      },
      {
        code: 1439,
        name: 'DETERMINAÇÃO DO TEOR DE FLÚOR EM ÁGUA'
      },
      {
        code: 1443,
        name: 'BUSCA E APREENSÃO DE MENOR'
      },
      {
        code: 1444,
        name: 'INVENTÁRIO'
      },
      {
        code: 1446,
        name: 'AÇÃO DE ALIMENTOS'
      },
      {
        code: 1449,
        name: 'OFERTA DE ALIMENTOS'
      },
      {
        code: 1451,
        name: 'USUCAPIÃO'
      },
      {
        code: 1452,
        name: 'CUMPRIMENTO DE TESTAMENTO'
      },
      {
        code: 1453,
        name: 'ANULAÇÃO DE CASAMENTO'
      },
      {
        code: 1454,
        name: 'ACORDO DE ALIMENTOS'
      },
      {
        code: 1455,
        name: 'HOMOLOGAÇÃO DE ACORDO'
      },
      {
        code: 1456,
        name: 'INTERDIÇÃO/CURATELA'
      },
      {
        code: 1457,
        name: 'TUTELA'
      },
      {
        code: 1458,
        name: 'PEDIDO DE ALVARÁ'
      },
      {
        code: 1459,
        name: 'MEDIDAS CAUTELARES/BUSCA E APREENSÃO DE MENOR'
      },
      {
        code: 1460,
        name: 'EXECUÇÃO DE SENTENÇA'
      },
      {
        code: 1461,
        name: 'INVENTÁRIO'
      },
      {
        code: 1462,
        name: 'ARROLAMENTO'
      },
      {
        code: 1463,
        name: 'CUMPRIMENTO DE TESTAMENTO'
      },
      {
        code: 1464,
        name: 'ALVARÁ EM INVENTÁRIO'
      },
      {
        code: 1465,
        name: 'SUBSTITUIÇÃO/REMOÇÃO DE INVENTARIANTE'
      },
      {
        code: 1466,
        name: 'SOBREPARTILHA DE BENS'
      },
      {
        code: 1468,
        name: 'PEDIDO DE REVOGAÇÃO DE PRISÃO PREVENTIVA'
      },
      {
        code: 1469,
        name: 'HABEAS CORPUS'
      },
      {
        code: 1470,
        name: 'AÇÃO DE ALIMENTOS'
      },
      {
        code: 1473,
        name: 'VISITAS DAS UNIDADES PRISIONAIS E DAS DELEGACIAS DE POLÍCIA DA COMARCA DE FORTALEZA (CE).'
      },
      {
        code: 1474,
        name: 'ENDODONTIA (TRATAMENTO DE CANAL)'
      },
      {
        code: 1479,
        name: 'PERÍCIA EM LOCAL DE INCÊNDIO.'
      },
      {
        code: 1480,
        name: 'PERÍCIA EM LOCAL DE FURTO DE ÁGUA'
      },
      {
        code: 1481,
        name: 'PERÍCIA EM LOCAL DE FURTO DE ENERGIA.'
      },
      {
        code: 1482,
        name: 'EXAME DE CONTRAFAÇÃO'
      },
      {
        code: 1483,
        name: 'PERÍCIA EM LOCAL DE ACIDENTE COM ENERGIA NUCLEAR'
      },
      {
        code: 1484,
        name: 'PERÍCIA EM LOCAL DE EXPLOSÃO'
      },
      {
        code: 1489,
        name: 'PIBIC - PROGRAMA INSTITUCIONAL DE BOLSAS DE INICIAÇÃO CIENTÍFICA / URCA - UNIVERSIDADE REGIONAL DO CARIRI'
      },
      {
        code: 1492,
        name: 'PROGRAMA INSTITUCIONAL DE BOLSAS DE INICIAÇÃO CIENTÍFICA - PIBIC/ FUNDAÇÃO CEARENSE DE APOIO AO DESENVOLVIMENTO CIENTÍFICO E TECNOLÓGICO - FUNCAP'
      },
      {
        code: 1493,
        name: 'ENSINO MÉDIO INTEGRADO À EDUCAÇÃO PROFISSIONAL'
      },
      {
        code: 1498,
        name: 'DOCUMENTO DE IDENTIDADE CIVIL - REGIÃO METROPOLITANA E INTERIOR - POSTOS ON-LINE'
      },
      {
        code: 1499,
        name: 'MESTRADO EM BIOPROSPECÇÃO MOLECULAR'
      },
      {
        code: 1500,
        name: 'PROGRAMA INSTITUCIONAL DE BOLSAS DE INICIAÇÃO CIENTÍFICA - PIBIC / CONSELHO NACIONAL DE DESENVOLVIMENTO CIENTÍFICO TECNOLÓGICO - CNPQ'
      },
      {
        code: 1501,
        name: 'ARTICULAÇÃO DA FORMAÇÃO EM NÍVEL MÉDIO COM O ENSINO PROFISSIONAL E O MUNDO DO TRABALHO ATRAVÉS DA CAPACITAÇÃO DE JOVENS EM TECNOLOGIA DA INFORMAÇÃO, COMUNICAÇÃO E EMPREENDEDORISMO'
      },
      {
        code: 1502,
        name: 'PROGRAMA INSTITUCIONAL DE BOLSAS DE INICIAÇÃO CIENTÍFICA - PIBIC / CONSELHO NACIONAL DE DESENVOLVIMENTO CIENTÍFICO TECNOLÓGICO - CNPQ - JÚNIOR - ENSINO MÉDIO'
      },
      {
        code: 1508,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS IGM'
      },
      {
        code: 1510,
        name: 'PERÍCIA EM LOCAL DE ACIDENTE DE TRABALHO'
      },
      {
        code: 1517,
        name: 'PERÍCIA EM LOCAL DE ACIDENTE DE TRÂNSITO COM VEÍCULO OFICIAL'
      },
      {
        code: 1525,
        name: 'EXAME DE COMPARAÇÃO BALÍSTICA DE PROJÉTEIS E ESTOJOS.'
      },
      {
        code: 1530,
        name: 'PERÍCIA EM ARMA DE FOGO E/OU MUNIÇÃO.'
      },
      {
        code: 1532,
        name: 'PERÍCIA GRAFOTÉCNICA PARA CONSTATAÇÃO DE AUTENTICIDADE DE ESCRITA'
      },
      {
        code: 1537,
        name: 'DOCUMENTO DE IDENTIDADE CIVIL - MUNICÍPIO DE FORTALEZA - POSTOS DE IDENTIFICAÇÕES'
      },
      {
        code: 1538,
        name: 'RADIOLOGIA INTERVENCIONISTA E NEURORADIOLOGIA DIAGNÓSTICA E TERAPEUTICA'
      },
      {
        code: 1542,
        name: 'ENDODONTIA'
      },
      {
        code: 1545,
        name: 'ATENDIMENTO ODONTOLÓGICO (RADIOGRAFIA)'
      },
      {
        code: 1546,
        name: 'RADIOLOGIA PERIAPICAL'
      },
      {
        code: 1547,
        name: 'PRÓTESE TOTAL (DENTADURA)'
      },
      {
        code: 1556,
        name: 'PRÓTESE PARCIAL REMOVÍVEL (BRIDGE)'
      },
      {
        code: 1560,
        name: 'COROA UNITÁRIA'
      },
      {
        code: 1562,
        name: 'NEFROLOGIA / TERAPIA RENAL SUBSTITUTIVA'
      },
      {
        code: 1565,
        name: 'PERIODONTIA (TRATAMENTO DA GENGIVA)'
      },
      {
        code: 1573,
        name: 'PERÍCIA EM LOCAL DE CRIME CONTRA A VIDA'
      },
      {
        code: 1576,
        name: 'PERÍCIA EM LOCAL DE CRIME CONTRA O PATRIMÔNIO.'
      },
      {
        code: 1579,
        name: 'UNIDADE DE AVC (ACIDENTE VASCULAR CEREBRAL)'
      },
      {
        code: 1584,
        name: 'INTERNAÇÃO PSIQUIÁTRICA'
      },
      {
        code: 1586,
        name: 'AMBULATÓRIO'
      },
      {
        code: 1595,
        name: 'ISOLAMENTO VIRAL'
      },
      {
        code: 1596,
        name: 'DINTER - PROGRAMA DE DOUTORADO DO CURSO DE PÓS-GRADUAÇÃO EM BIOQUÍMICA TOXICOLÓGICA DA UNIVERSIDADE FEDERAL DE SANTA MARIA EM CONVÊNIO COM A UNIVERSIDADE REGIONAL DO CARIRI - URCA'
      },
      {
        code: 1597,
        name: 'SOROLOGIA PARA FTA-ABS'
      },
      {
        code: 1598,
        name: 'SOROLOGIA PARATOXOPLASMOSE IGG'
      },
      {
        code: 1599,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IGM'
      },
      {
        code: 1600,
        name: 'HEMAGLUTINAÇÃO INDIRETA PARA CHAGAS'
      },
      {
        code: 1601,
        name: 'INCENTIVO ÁS CENTRAIS DE DISTRIBUIÇÃO DE MERCADORIAS NO ESTADO.'
      },
      {
        code: 1602,
        name: 'IMUNOFLUORESCÊNCIA INDIRETA PARA CHAGAS.'
      },
      {
        code: 1603,
        name: 'IMUNOFLUORESCÊNCIA PARA LEISHMANIOSE VISCERAL CANINA'
      },
      {
        code: 1604,
        name: 'PARASITOLÓGICO DIRETO PARA LEISHMANIOSE TEGUMENTAR AMERICANA'
      },
      {
        code: 1605,
        name: 'ATENDIMENTO ODONTOLÓGICO (ESTÉTICA)'
      },
      {
        code: 1606,
        name: 'REAÇÃO DE IMUNOFLUORESCÊNCA INDIRETA PARA LESHMANIOSE VISCERAL HUMANA'
      },
      {
        code: 1607,
        name: 'PESQUISA DO PARASITA DA MALÁRIA'
      },
      {
        code: 1608,
        name: 'VERIFICAÇÃO DE LOCUTOR'
      },
      {
        code: 1610,
        name: 'ELISA PARA DENGUE'
      },
      {
        code: 1611,
        name: 'DENGUE ANTÍGENO NS1'
      },
      {
        code: 1612,
        name: 'SOROLOGIA PARA RUBÉOLA IGG'
      },
      {
        code: 1613,
        name: 'SOROLOGIA PARA RUBÉOLA IGM'
      },
      {
        code: 1614,
        name: 'SOROLOGIA PARA SARAMPO IGG'
      },
      {
        code: 1615,
        name: 'SOROLOGIA PARA SARAMPO IGM'
      },
      {
        code: 1616,
        name: 'SOROLOGIA PARA HEPATITE A - ANTI HVA TOTAL'
      },
      {
        code: 1617,
        name: 'TOMBAR O BEM PATRIMONIAL E COLHER TERMO DE RESPONSABILIDADE'
      },
      {
        code: 1618,
        name: 'SOROLOGIA PARA HEPATITE B - ANTI-HBC IGM'
      },
      {
        code: 1619,
        name: 'SOROLOGIA PARA HEPATITE B - ANTI-HBC TOTAL'
      },
      {
        code: 1620,
        name: 'SOROLOGIA PARA HEPATITE B - ANTI-HBE'
      },
      {
        code: 1621,
        name: 'SOROLOGIA PARA HEPATITE C ANTI HCV'
      },
      {
        code: 1623,
        name: 'ATENDIMENTO ODONTOLÓGICO (EMERGÊNCIA)'
      },
      {
        code: 1624,
        name: 'HBV-DNA QUANTITATIVO POR PCR EM TEMPO REAL'
      },
      {
        code: 1625,
        name: 'GENOTIPAGEM DO VÍRUS DA HEPATITE C PELA TÉCNICA MOLECULAR DE HIBRIDIZAÇÃO REVERSA-LIPA'
      },
      {
        code: 1626,
        name: 'HCV-RNA QUALITATIVO POR PCR'
      },
      {
        code: 1627,
        name: 'HCV-RNA QUANTITATIVO POR PCR EM TEMPO REAL'
      },
      {
        code: 1628,
        name: 'CIRURGIA BUCO MAXILO-FACIAL'
      },
      {
        code: 1630,
        name: 'EXAMES PERÍCIAS NA ÁREA DE CRIMES CIBERNÉTICOS'
      },
      {
        code: 1631,
        name: 'ENSAIO DE IMUNOCROMATOGRAFIA (IMUNOBLOT RÁPIDO) HIV1/2'
      },
      {
        code: 1632,
        name: 'CONTAGEM DE LINFÓCITOS T CD4 CD8'
      },
      {
        code: 1633,
        name: 'TESTES PARA A QUANTIFICAÇÃO DA CARGA VIRAL DE HIV'
      },
      {
        code: 1634,
        name: 'GENOTIPAGEM HIV'
      },
      {
        code: 1635,
        name: 'PERIODONTIA.'
      },
      {
        code: 1636,
        name: 'EXAMES PERÍCIAS EM CELULARES E OUTROS TIPOS DE MEMÓRIAS'
      },
      {
        code: 1637,
        name: 'RT-PCR EM TEMPO REAL PARA H1N1'
      },
      {
        code: 1639,
        name: 'IFI PARA VÍRUS RESPIRATÓRIOS'
      },
      {
        code: 1640,
        name: 'ELISA PARA ROTAVÍRUS'
      },
      {
        code: 1641,
        name: 'TESTE DE INVESTIGAÇÃO DE PATERNIDADE POR ANÁLISE DE DNA'
      },
      {
        code: 1643,
        name: 'ODONTOPEDIATRIA'
      },
      {
        code: 1644,
        name: 'PESQUISA DE HEMOGLOBINOPATIAS'
      },
      {
        code: 1645,
        name: 'DOSAGEM DE HORMÔNIO TIREOESTIMULANTE -TSH'
      },
      {
        code: 1646,
        name: 'DETERMINAÇÃO DO PH DA ÁGUA'
      },
      {
        code: 1647,
        name: 'PRÓTESE DENTÁRIA.'
      },
      {
        code: 1648,
        name: 'DETERMINAÇÃO DA TURBIDEZ DA ÁGUA'
      },
      {
        code: 1649,
        name: 'DETERMINAÇÃO DE NITRATO E NITRITO EM ALIMENTOS'
      },
      {
        code: 1650,
        name: 'PESQUISA DE BACILLUS CEREUS, EM ALIMENTOS'
      },
      {
        code: 1651,
        name: 'DETECÇÃO DE BOLORES E LEVEDURAS EM ALIMENTOS'
      },
      {
        code: 1652,
        name: 'DETECÇÃO DE CLOSTRIDIUM SULFITO REDUTOR E CLOSTRIDIUM PERFRINGENS, EM ALIMENTOS.'
      },
      {
        code: 1653,
        name: 'DETECÇÃO DE COLIFORMES EM ALIMENTOS'
      },
      {
        code: 1654,
        name: 'DETECÇÃO DE LISTERIA MONOCYTOGENES EM ALIMENTOS'
      },
      {
        code: 1655,
        name: 'CADASTRO DE DOCENTES NO PORTAL GRASIELA'
      },
      {
        code: 1656,
        name: 'DETECÇÃO DE MICRORGANISMOS AERÓBIOS MESOFILOS, EM ALIMENTOS'
      },
      {
        code: 1657,
        name: 'DETECÇÃO DE SALMONELLA SP EM ALIMENTOS.'
      },
      {
        code: 1658,
        name: 'DETECÇÃO DE STAPHYLOCOCCUS COAGULASE POSITIVA, EM ALIMENTOS.'
      },
      {
        code: 1659,
        name: 'DETECÇÃO DE VIBRIO CHOLERAE, EM ALIMENTOS'
      },
      {
        code: 1660,
        name: 'DETECÇÃO DE VIBRIO PARAHAEMOLYTICUS, EM ALIMENTOS'
      },
      {
        code: 1661,
        name: 'DETECÇÃO DE BACTERIÓFAGOS FECAIS EM ÁGUA E SOLO.'
      },
      {
        code: 1662,
        name: 'DETECÇÃO DE BURKHOLDERIA PSEUDOMALLEI EM ÁGUA E SOLO.'
      },
      {
        code: 1663,
        name: 'DETECÇÃO DE CLOSTRIDIUM PERFRINGENS, EM ÁGUA MINERAL.'
      },
      {
        code: 1665,
        name: 'DETECÇÃO DE ENTEROCOCOS EM ÁGUA MINERAL'
      },
      {
        code: 1666,
        name: 'DETECÇÃO DE PSEUDOMONAS AERUGINOSA EM ÁGUA MINERAL'
      },
      {
        code: 1667,
        name: 'DETECÇÃO DE SALMONELLA TYPHI, EM ÁGUA'
      },
      {
        code: 1670,
        name: 'ANÁLISE CONJUNTURAL'
      },
      {
        code: 1674,
        name: 'ATENDIMENTO Á PARTE ASSISTIDA'
      },
      {
        code: 1675,
        name: 'AÇÃO RESCISÓRIA'
      },
      {
        code: 1676,
        name: 'AGRAVO DE INSTRUMENTO'
      },
      {
        code: 1677,
        name: 'APELAÇÃO CÍVEL'
      },
      {
        code: 1678,
        name: 'APELAÇÃO CRIMINAL'
      },
      {
        code: 1679,
        name: 'EMBARGOS DECLARATÓRIOS'
      },
      {
        code: 1680,
        name: 'MANDADO DE SEGURANÇA'
      },
      {
        code: 1681,
        name: 'PETIÇÃO EM GERAL'
      },
      {
        code: 1682,
        name: 'RECURSO ESPECIAL'
      },
      {
        code: 1684,
        name: 'RECURSO EM SENTIDO ESTRITO'
      },
      {
        code: 1685,
        name: 'SOROLOGIA PARA CITOMEGALOVIRUS IGG'
      },
      {
        code: 1686,
        name: 'RECURSO EXTRAORDINÁRIO (CÍVEL E CRIME)'
      },
      {
        code: 1688,
        name: 'SUSTENTAÇÃO ORAL'
      },
      {
        code: 1689,
        name: 'HABEAS CORPUS'
      },
      {
        code: 1690,
        name: 'CULTURA PARA MYCOBACTERIUM TUBERCULOSIS'
      },
      {
        code: 1691,
        name: 'REVISÃO CRIMINAL'
      },
      {
        code: 1692,
        name: 'TESTE DE SENSIBILIDADE PARA TUBERCULOSE'
      },
      {
        code: 1693,
        name: 'BACILOSCOPIA PARA TUBERCULOSE'
      },
      {
        code: 1694,
        name: 'REAÇÃO DE POLIMERASE EM CADEIA – PCR PARA MENINGITE BACTERIANA'
      },
      {
        code: 1695,
        name: 'DIAGNÓSTICO DA PESTE EM HUMANOS'
      },
      {
        code: 1696,
        name: 'DIAGNÓSTICO DA PESTE EM ANIMAIS SENTINELA E VETORES'
      },
      {
        code: 1700,
        name: 'CONFERIR BENS PATRIMONIAIS NO(S) SETOR(ES) NA(S) MUDANÇA(S) DE CHEFIA OU PARA FINS DE ATUALIZAÇÃO.'
      },
      {
        code: 1708,
        name: 'REALIZAR O LEVANTAMENTO FÍSICO DO PATRIMÔNIO ANUAL OU PERIODICAMENTE EM TODA INSTITUIÇÃO.'
      },
      {
        code: 1709,
        name: 'INFORMAÇÃO DO PROCESSO DE INSTALAÇÃO E OPERACIONALIZAÇÃO NA ZONA DE PROCESSAMENTO DE EXPORTAÇÃO DO CEARÁ.'
      },
      {
        code: 1710,
        name: 'PROGRAMA DE PÓS GRADUAÇÃO EM LINGUÍSTICA APLICADA'
      },
      {
        code: 1714,
        name: 'INVENTÁRIO FÍSICO CONTÁBIL'
      },
      {
        code: 1715,
        name: 'IDENTIFICAÇÃO CRIMINAL'
      },
      {
        code: 1716,
        name: 'ATESTADO DE ANTECEDENTES CRIMINAIS'
      },
      {
        code: 1718,
        name: 'EXAME DE COMPARAÇÃO DE IMPRESSÕES DIGITAIS PARA LAUDOS E EXPEDIÇÃO DE CARTEIRA DE IDENTIDADE.'
      },
      {
        code: 1719,
        name: 'ACESSO A DOCUMENTOS CARTORÁRIOS DOS MUNICÍPIOS CEARENSES'
      },
      {
        code: 1729,
        name: 'SETOR MEMÓRIAS REVELADAS: ACESSO ÀS INFORMAÇÕES RELATIVAS A PESSOAS QUE FORAM PERSEGUIDAS PELA DITADURA MILITAR NO CEARÁ, PERÍODO DE 1964 A 1985.'
      },
      {
        code: 1730,
        name: 'EMISSÃO DE CERTIDÕES'
      },
      {
        code: 1735,
        name: 'ACESSO AOS DOCUMENTOS VINCULADO AO ARQUIVO PÚBLICO DO ESTADO DO CEARÁ'
      },
      {
        code: 1742,
        name: 'CENTRO DE INFUSÃO DE ONCOLOGIA E HEMATOLOGIA'
      },
      {
        code: 1746,
        name: 'PERICIA CONTÁBIL'
      },
      {
        code: 1750,
        name: 'IDENTIFICAÇÃO DO AMIDO EM LEITE FLUIDO E LEITE EM PÓ'
      },
      {
        code: 1751,
        name: 'DETERMINAÇÃO DA ALCALINIDADE DAS CINZAS EM CARBONATO DE SÓDIO NO LEITE FLUIDO.'
      },
      {
        code: 1753,
        name: 'PROTEÇÃO SOCIAL ESPECIAL PARA PESSOAS IDOSAS VÍTIMAS DE VIOLÊNCIA'
      },
      {
        code: 1756,
        name: 'EXAME EM LOCAL DE CRIME CONTRA O PATRIMONIO'
      },
      {
        code: 1757,
        name: 'EXAME EM LOCAL DE CRIME CONTRA O PATRIMÔNIO'
      },
      {
        code: 1758,
        name: 'EXAME EM LOCAL DE CRIME CONTRA O PATRIMÔNIO'
      },
      {
        code: 1760,
        name: 'DETERMINAÇÃO DA PEROXIDASE NO LEITE PASTEURIZADO'
      },
      {
        code: 1761,
        name: 'PROGRAMA DE PÓS GRADUAÇÃO EM CUIDADOS CLÍNICOS EM ENFERMAGEM E SAÚDE'
      },
      {
        code: 1762,
        name: 'DETERMINAÇÃO QUALITATIVA DA ESTABILIDADE AO ETANOL A 68% NO LEITE'
      },
      {
        code: 1763,
        name: 'ANÁLISE DAS CARACTERÍSTICAS SENSORIAIS (ASPECTO, COR, SABOR E ODOR) NOS LEITE PASTEURIZADO, UHT E PÓ.'
      },
      {
        code: 1765,
        name: 'HABILITAÇÃO DE RESPONSÁVEL TÉCNICO – RT PARA EMISSÃO DE CERTIFICADO FITOSSANITÁRIO DE ORIGEM – CFO E CERTIFICADO FITOSSANITÁRIO DE ORIGEM CONSOLIDADO - CFOC.'
      },
      {
        code: 1767,
        name: 'PROCESSO DE INSCRIÇÃO PARA SELEÇÃO PÚBLICA NO DOUTORADO EM REDE NORDESTE DE BIOTECNOLOGIA - RENORBIO'
      },
      {
        code: 1772,
        name: 'SERVIÇO DE PROTEÇÃO A CRIANÇAS E ADOLESCENTES EM SITUAÇÃO DE MORADIA DE RUA'
      },
      {
        code: 1773,
        name: 'SERVIÇO DE PROTEÇÃO SOCIAL ESPECIAL – MÉDIA COMPLEXIDADE'
      },
      {
        code: 1775,
        name: 'SERVIÇO DE PROTEÇÃO SOCIAL ESPECIAL – MÉDIA COMPLEXIDADE'
      },
      {
        code: 1777,
        name: 'LABORATÓRIO DE CITOLOGIA'
      },
      {
        code: 1778,
        name: 'OFERTA DE ÁREAS PARA COMERCIALIZAÇÃO.'
      },
      {
        code: 1780,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1781,
        name: 'ORGANIZAR E CONTROLAR OS SERVIÇOS LIGADOS AO PATRIMÔNIO: PRÓPRIO E DE TERCEIROS.'
      },
      {
        code: 1782,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1783,
        name: 'SERVIÇO DE FISIOTERAPIA'
      },
      {
        code: 1785,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 2543,
        name: 'CINZAS INSOLÚVEIS EM HCL'
      },
      {
        code: 1786,
        name: 'INCENTIVOS FISCAIS A EMPREENDIMENTOS INDUSTRIAIS DE MÉDIO E GRANDE PORTE.'
      },
      {
        code: 1787,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1788,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1790,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1794,
        name: 'ELABORAÇÃO E ACOMPANHAMENTO DOS PLANOS DE CRÉDITO DE INSTALAÇÃO PARA CONSTRUÇÃO E REFORMA DE HABITAÇÃO RURAL EM 36 ASSENTAMENTOS ESTADUAIS.'
      },
      {
        code: 1798,
        name: 'COORDENAÇÃO DO DESEMPENHO DAS FUNÇÕES DOS DEFENSORES PÚBLICOS.'
      },
      {
        code: 1799,
        name: 'COMUNICAÇÃO DE RECUSA DE ATENDIMENTO POR PARTE DO DEFENSOR PÚBLICO À CORREGEDORIA GERAL'
      },
      {
        code: 1800,
        name: 'SUPERVISIONAMENTO DOS SETORES DE ATENDIMENTO E PETIÇÕES INICIAIS.'
      },
      {
        code: 1801,
        name: 'MANTER CONTATO COM OS DEFENSORES PÚBLICOS.'
      },
      {
        code: 1802,
        name: 'SOLICITAÇÃO DE MATERIAL'
      },
      {
        code: 1803,
        name: 'GERENCIAR AS FÉRIAS E LICENÇAS DOS DEFENSORES PÚBLICOS.'
      },
      {
        code: 1804,
        name: 'GERENCIAR A LOTAÇÃO E RESPONDÊNCIA DOS DEFENSORES PÚBLICOS.'
      },
      {
        code: 1806,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1811,
        name: 'PROGRAMA DE ATÍPICOS/MEDICAMENTOS DE ALTO CUSTO'
      },
      {
        code: 1812,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1813,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1814,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1816,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1817,
        name: 'SERVIÇO DE PRONTO ATENDIMENTO - SPA'
      },
      {
        code: 1821,
        name: 'INTERNAÇÃO HOSPITALAR ABERTA EM REGIME DE HOSPITAL-DIA: ELO DE VIDA'
      },
      {
        code: 1822,
        name: 'PROCESSO DE INSCRIÇÃO PARA SELEÇÃO PÚBLICA NO CURSO DE MESTRADO PROFISSIONAL EM SAUDE DA CRIANÇA E DO ADOLESCENTE'
      },
      {
        code: 1823,
        name: 'COMUNICAÇÃO DE IRREGULARIDADES FUNCIONAIS E ADMINISTRATIVAS'
      },
      {
        code: 1824,
        name: 'PROMOVER SESSÃO PÚBLICA DE DESIGNAÇÕES PARA ÓRGÃOS DE ATUAÇÃO.'
      },
      {
        code: 1828,
        name: 'DESIGNAÇÃO PROVISÓRIA DE DEFENSOR PÚBLICO'
      },
      {
        code: 1832,
        name: 'PROVA DE RECONSTITUIÇÃO DO LEITE EM PÓ'
      },
      {
        code: 1833,
        name: 'DETERMINAÇÃO DA ACIDEZ EM ÁCIDO LÁTICO NOS LEITES UHT, PASTEURIZADO E PÓ.'
      },
      {
        code: 1834,
        name: 'DETERMINAÇÃO DO ÍNDICE CRIOSCÓPICO NOS LEITES PASTEURIZADO E UHT'
      },
      {
        code: 1835,
        name: 'DETERMINAÇÃO DA UMIDADE DO LEITE EM PÓ'
      },
      {
        code: 1836,
        name: 'PREVISÃO DIÁRIA DO TEMPO'
      },
      {
        code: 1839,
        name: 'CANAL DE COMUNICAÇÃO PARA RECLAMAÇÕES, CRÍTICAS, ELOGIOS, DENÚNCIAS, OBTENÇÃO DE INFORMAÇÕES DE NATUREZA AMBIENTAL.'
      },
      {
        code: 1840,
        name: 'VARIÁVEIS METEOROLÓGICAS(PCDS)'
      },
      {
        code: 1841,
        name: 'VISITA DE DIVERSOS USUÁRIOS DA SOCIEDADE EM GERAL.'
      },
      {
        code: 1842,
        name: 'FISCALIZAÇÃO DO USO DE AGROTÓXICOS E AFINS.'
      },
      {
        code: 1844,
        name: 'APOIO A EVENTOS, ESTUDOS, PESQUISAS E PROJETOS - CONVÊNIOS'
      },
      {
        code: 1846,
        name: 'PROGRAMA DE IMPLANTE COCLEAR E PROTESES AUDITIVAS'
      },
      {
        code: 1847,
        name: 'EXTENSÃO DE HABILITAÇÃO DE RESPONSÁVEL TÉCNICO – RT PARA EMISSÃO DE CERTIFICADO FITOSSANITÁRIO DE ORIGEM – CFO E CERTIFICADO FITOSSANITÁRIO DE ORIGEM CONSOLIDADO - CFOC'
      },
      {
        code: 1848,
        name: 'INCLUSÃO DE NOVAS PRAGAS NA HABILITAÇÃO DO RESPONSÁVEL TÉCNICO – RT PARA EMISSÃO DE CERTIFICADO FITOSSANITÁRIO DE ORIGEM – CFO E CERTIFICADO FITOSSANITÁRIO DE ORIGEM CONSOLIDADO – CFOC.'
      },
      {
        code: 1849,
        name: 'RENOVAÇÃO DE HABILITAÇÃO DE RESPONSÁVEL TÉCNICO – RT PARA EMISSÃO DE CERTIFICADO FITOSSANITÁRIO DE ORIGEM – CFO E CERTIFICADO FITOSSANITÁRIO DE ORIGEM CONSOLIDADO - CFOC'
      },
      {
        code: 1850,
        name: 'INSCRIÇÃO DE UNIDADE DE PRODUÇÃO – UP'
      },
      {
        code: 1851,
        name: 'CADASTRO DE PROPRIEDADE RURAL PARA ADESÃO AO SISTEMA DE PRODUÇÃO EM ÁREA LIVRE DE MOSCA DAS CUCURBITÁCEAS (ANASTREPHA GRANDIS L.)'
      },
      {
        code: 1852,
        name: 'LIBERAÇÃO DE SEQUENCIAIS PARA EMISSÃO DE CERTIFICADO FITOSSANITÁRIO DE ORIGEM – CFO OU CERTIFICADO FITOSSANITÁRIO DE ORIGEM CONSOLIDADO - CFOC'
      },
      {
        code: 1853,
        name: 'INSCRIÇÃO DE UNIDADE DE CONSOLIDAÇÃO – UC'
      },
      {
        code: 1855,
        name: 'HABILITAÇÃO DE RESPONSÁVEL TÉCNICO – RT PARA EMISSÃO DE PERMISSÃO DE TRÂNSITO DE VEGETAIS - PTV'
      },
      {
        code: 1856,
        name: 'EMISSÃO DE PERMISSÃO DE TRÂNSITO DE VEGETAIS - PTV'
      },
      {
        code: 1857,
        name: 'MONITORAMENTO DE PRAGAS QUARENTENÁRIAS E DE IMPORTÂNCIA ECONÔMICA PARA O ESTADO DO CEARÁ.'
      },
      {
        code: 1858,
        name: 'AUTORIZAÇÃO DE REMOÇÃO DE ECF'
      },
      {
        code: 1859,
        name: 'LEVANTAMENTO DE DETECÇÃO DE PRAGAS QUARENTENÁRIAS E DE IMPORTÂNCIA ECONÔMICA PARA O ESTADO DO CEARÁ.'
      },
      {
        code: 1860,
        name: 'REALIZAÇÃO DE EVENTOS, FEIRAS, EXPOSIÇÕES E LEILÕES DE VEGETAIS, PARTES DE VEGETAIS, PRODUTOS DE ORIGEM VEGETAL E INSUMOS.'
      },
      {
        code: 1863,
        name: 'CAPACITAÇÃO E DESENVOLVIMENTO DE PESSOAS DO SISTEMA ESTADUAL DA AGRICULTURA - SEA.'
      },
      {
        code: 1864,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1865,
        name: 'CONCESSÃO DE PENSÃO CIVIL DE DEPENDENTES DE EX-SERVIDORES PÚBLICOS/SEGURADOS'
      },
      {
        code: 1866,
        name: 'APOSENTADORIA POR TEMPO DE CONTRIBUIÇÃO, POR INVALIDEZ, COMPULSÓRIA E POR IDADE.'
      },
      {
        code: 1867,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1868,
        name: 'SERVIÇO DE ACOLHIMENTO INSTITUCIONAL'
      },
      {
        code: 1870,
        name: 'FISCALIZAÇÃO DOS SERVIÇOS DE DISTRIBUIÇÃO DE ENERGIA ELÉTRICA'
      },
      {
        code: 1872,
        name: 'INTERNAÇÃO HOSPITALAR ABERTA EM REGIME DE HOSPITAL-DIA: LUGAR DE VIDA'
      },
      {
        code: 1873,
        name: 'FISCALIZAÇÃO DOS SERVIÇOS DE DISTRIBUIÇÃO DE GÁS CANALIZADO'
      },
      {
        code: 1874,
        name: 'FISCALIZAÇÃO DOS SERVIÇOS DO SISTEMA DE TRANSPORTE RODOVIÁRIO INTERMUNICIPAL DE PASSAGEIROS'
      },
      {
        code: 1876,
        name: 'SOLICITAÇÃO DE LIMITE FINANCEIRO AO COGERF.'
      },
      {
        code: 1877,
        name: 'SOLICITAÇÃO DE CRÉDITOS ADICIONAIS E MOVIMENTAÇÕES ORÇAMENTÁRIAS'
      },
      {
        code: 1878,
        name: 'DISTRIBUIÇÃO DE SEMENTES, MUDAS, RAQUETES E MANIVAS.'
      },
      {
        code: 1879,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL AO PROGRAMA DE AGRICULTURA IRRIGADA SUSTENTÁVEL-PAIS'
      },
      {
        code: 1880,
        name: 'ASSISTÊNCIA TÉCNICA AOS BENEFICIARIOS DO PROGRAMA DE AQUISIÇÃO DE ALIMENTOS- PAA'
      },
      {
        code: 1881,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL AOS AGRICULTORES FAMILIARES AO PROGRAMA NACIONAL DE ALIMENTAÇÃO ESCOLAR - PNAE'
      },
      {
        code: 1882,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL AOS AGRICULTORES E AGRICULTORES FAMILIARES NAS CADEIAS PRODUTIVAS DAS CULTURAS E CRIAÇÕES.'
      },
      {
        code: 1883,
        name: 'EDUCAÇÃO SANITÁRIA VEGETAL'
      },
      {
        code: 1884,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL NO PROCESSO DE TRANSIÇÃO AGROECOLÓGICA AOS AGRICULTORES FAMILIARES.'
      },
      {
        code: 1885,
        name: 'ELABORAÇÃO DE DECLARAÇÃO DE APTIDÃO AO PRONAF - DAP'
      },
      {
        code: 1886,
        name: 'ELABORAÇÃO DE PROJETOS DE CRÉDITO RURAL E PRESTAÇÃO DE ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL - ATER'
      },
      {
        code: 1888,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL EM AGROINDÚSTRIA DA AGRICULTURA FAMILIAR'
      },
      {
        code: 1889,
        name: 'LAUDOS PERICIAIS DE COMPROVAÇÃO DE PERDAS REFERENTE AO SEGURO DA AGRICULTURA FAMILIAR – SEAF( PROAGRO MAIS )'
      },
      {
        code: 2544,
        name: 'CLORETOS EM ALIMENTOS'
      },
      {
        code: 1890,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL PARA PRESERVAÇÃO DOS RECURSOS NATURAIS'
      },
      {
        code: 1891,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL EM PRODUTOS ORGÂNICOS'
      },
      {
        code: 1893,
        name: 'CAPACITAÇÃO INICIAL PARA OS BENEFICIÁRIOS DO PROGRAMA CRÉDITO FUNDIÁRIO'
      },
      {
        code: 1894,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL – ATER AOS BENEFICIÁRIOS DO PROGRAMA NACIONAL DE CREDITO FUNDIÁRIO.'
      },
      {
        code: 1896,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL AOS AGRICULTORES E AGRICULTORAS FAMILIARES BENEFICIÁRIOS DO PROGRAMA BIODIESEL'
      },
      {
        code: 1898,
        name: 'PROCESSO SELETIVO PARA INSCRIÇÕES NOS CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE HUMANIDADES - CH'
      },
      {
        code: 1899,
        name: 'SIRTRA - SISTEMA DE ROTAS E TRAFEGABILIDADE'
      },
      {
        code: 1903,
        name: 'ASSISTÊNCIA TÉCNICA E EXTENSÃO RURAL AOS AGRICULTORES FAMILIARES NA PRODUÇÃO DE PLANTAS MEDICINAIS, AROMÁTICAS, CONDIMENTARES E FITOTERÁPICOS'
      },
      {
        code: 1904,
        name: 'PROCESSO SELETIVO PARA INSCRIÇÕES NOS CURSOS DE ESPECIALIZAÇÃO NA ÁREA DA SAÚDE'
      },
      {
        code: 1906,
        name: 'NORMATIZAÇÃO'
      },
      {
        code: 1913,
        name: 'PROCESSO SELETIVO PARA INSCRIÇÕES NOS CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE EDUCAÇÃO- CED'
      },
      {
        code: 1914,
        name: 'RELATÓRIOS DA SITUAÇÃO DA SAFRA AGRÍCOLA DE SEQUEIRO E QUADRA CHUVOSA.'
      },
      {
        code: 1915,
        name: 'PROCESSO SELETIVO PARA INSCRIÇÕES NOS CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE ESTUDOS SOCIAIS APLICADOS - CESA'
      },
      {
        code: 1917,
        name: 'AQUISIÇÃO DE ALIMENTOS DA AGRICULTURA FAMILIAR ATRAVÉS DO PROGRAMA DE AQUISIÇÃO DE ALIMENTOS – MODALIDADE COMPRA DIRETA COM DOAÇÃO SIMULTÂNEA'
      },
      {
        code: 1918,
        name: 'DISPONIBILIZAÇÃO DO MAPA RODOVIÁRIO ESTADUAL E POLÍTICO'
      },
      {
        code: 1920,
        name: 'AUDIÊNCIA PÚBLICA E CONSULTA PÚBLICA'
      },
      {
        code: 1921,
        name: 'RELATÓRIO ANUAL'
      },
      {
        code: 1922,
        name: 'PUBLICAÇÃO DE ATOS OFICIAIS'
      },
      {
        code: 1923,
        name: 'TERMO DE COOPERAÇÃO TÉCNICA – PERFURAÇÃO DE POÇOS PROFUNDOS'
      },
      {
        code: 1924,
        name: 'TERMOS DE AJUSTES'
      },
      {
        code: 1925,
        name: 'CONSTRUÇÃO DE POÇO PROFUNDO (TUBULAR)'
      },
      {
        code: 1926,
        name: 'APOIO À IMPLANTAÇÃO DE POLÍTICAS PÚBLICAS'
      },
      {
        code: 1927,
        name: 'RECUPERAÇÃO DE POÇO TUBULAR PROFUNDO'
      },
      {
        code: 1928,
        name: 'PUBLICIDADE E MARKETING NO ÂMBITO DA ADMINISTRAÇÃO DIRETA E INDIRETA'
      },
      {
        code: 1929,
        name: 'CÁLCIO EM ÁGUA/EFLUENTE'
      },
      {
        code: 1930,
        name: 'CONDUTIVIDADE EM ÁGUA'
      },
      {
        code: 1931,
        name: 'CLORO RESIDUAL EM ÁGUA E EFLUENTE'
      },
      {
        code: 1932,
        name: 'CLORETOS EM ÁGUAS'
      },
      {
        code: 1933,
        name: 'COR EM ÁGUA E EFLUENTES'
      },
      {
        code: 1935,
        name: 'DEMANDA QUÍMICA DE OXIGÊNIO (DQO) EM ÁGUAS/EFLUENTES.'
      },
      {
        code: 1936,
        name: 'DUREZA TOTAL EM ÁGUA'
      },
      {
        code: 1937,
        name: 'FÓSFORO EM ÁGUA E EFLUENTES'
      },
      {
        code: 1940,
        name: 'MATÉRIA ORGÂNICA, EM ÁGUA'
      },
      {
        code: 1941,
        name: 'EDIÇÃO E DIFUSÃO DO LIVRO E DA LEITURA ( PESQUISA, EDIÇÃO, PUBLICAÇÃO)'
      },
      {
        code: 1942,
        name: 'MAGNÉSIO EM ÁGUA'
      },
      {
        code: 1943,
        name: 'MATERIAIS FLUTUANTES (ENSAIO VISUAL)'
      },
      {
        code: 1945,
        name: 'NITRATO EM ÁGUA'
      },
      {
        code: 1946,
        name: 'RECEBIMENTO DE DEFESA DE AUTO DE INFRAÇÃO'
      },
      {
        code: 1947,
        name: 'NITRITO EM ÁGUAS E EFLUENTES'
      },
      {
        code: 1948,
        name: 'CULTURA DE FUNGOS PARA DIVERSAS AMOSTRAS CLINICAS'
      },
      {
        code: 1949,
        name: 'REVITALIZAÇÃO DAS AGROVILAS'
      },
      {
        code: 1951,
        name: 'PESQUISA DIRETA PARA FUNGOS EM DIVERSAS AMOSTRAS CLINICAS'
      },
      {
        code: 1952,
        name: 'RECEBIMENTO DE RECURSO VOLUNTÁRIO'
      },
      {
        code: 1953,
        name: 'TESTE DE SENSIBILIDADE ANTIFÚNGICO NAS CULTURAS POSITIVAS.'
      },
      {
        code: 1954,
        name: 'RECEBIMENTO DE RECURSO ESPECIAL'
      },
      {
        code: 1955,
        name: 'PESQUISA DE BROMATO EM ALIMENTOS.'
      },
      {
        code: 1956,
        name: 'DETERMINAÇÃO QUANTITATIVA DE ESTANHO, ARSÊNIO, CÁDMIO, CHUMBO, MERCÚRIO E COBRE EM ALIMENTOS.'
      },
      {
        code: 1957,
        name: 'DETERMINAÇÃO DE SÓDIO E FERRO EM ALIMENTOS'
      },
      {
        code: 1958,
        name: 'CERTIFICAÇÃO DE DIPLOMAS E CERTIFICAÇÃO DE CURSOS TÉCNICOS.'
      },
      {
        code: 1965,
        name: 'ATENDIMENTO E PESQUISA'
      },
      {
        code: 1968,
        name: 'PRECIPITAÇÃO POR RADAR'
      },
      {
        code: 1969,
        name: 'CONSTRUÇÃO DE CISTERNAS DE PLACAS E CAPACITAÇÃO EM CONVIVÊNCIA SUSTENTÁVEL COM O SEMIÁRIDO'
      },
      {
        code: 1970,
        name: 'VISITAS MONITORADAS AOS MUSEUS.'
      },
      {
        code: 1971,
        name: 'VISITAÇÃO À EXPOSIÇÃO VAQUEIROS.'
      },
      {
        code: 1972,
        name: 'VISITAÇÃO À EXPOSIÇÃO “BRINQUEDO: A ARTE DO MOVIMENTO”.'
      },
      {
        code: 1973,
        name: 'VISITAÇÃO MONITORADA PARA DEFICIENTES VISUAIS/AUDITIVOS.'
      },
      {
        code: 1974,
        name: 'SERVIÇO DE INSPEÇÃO ESTADUAL DE PESCADO E SEUS DERIVADOS'
      },
      {
        code: 1976,
        name: 'APOIO À EVENTOS'
      },
      {
        code: 1977,
        name: 'ATENDIMENTO , PESQUISA E EVENTOS'
      },
      {
        code: 1979,
        name: 'EMISSÃO DE CERTIDÕES NO ÂMBITO DISCIPLINAR'
      },
      {
        code: 1981,
        name: 'REGISTRO DE MARCAS DE FERRAR GADO'
      },
      {
        code: 1982,
        name: 'INFORMAÇÕES SOBRE INSTITUIÇÕES ESTADUAIS DE ENSINO SUPERIOR E ENSINO À DISTÂNCIA.'
      },
      {
        code: 1984,
        name: 'ANÁLISES FISICO-QUÍMICAS E MICROBIOLÓGICAS DE MEDICAMENTOS'
      },
      {
        code: 1985,
        name: 'AVALIAÇÃO DE CARACTERÍSTICAS MACROSCÓPICAS E MICROSCÓPICAS EM ALIMENTOS'
      },
      {
        code: 2113,
        name: 'SERVIÇO DE ELABORAÇÃO DE PARECER DE CONSULTA'
      },
      {
        code: 1986,
        name: 'VERIFICAÇÃO DA ROTULAGEM EM ALIMENTOS, SANEANTES, COSMÉTICOS E MEDICAMENTOS'
      },
      {
        code: 1987,
        name: 'PROSPECÇÃO E DIFUSÃO DE OPORTUNIDADES PARA FOMENTO EM CIÊNCIA, TECNOLOGIA E INOVAÇÃO'
      },
      {
        code: 1989,
        name: 'DETERMINAÇÃO DA CONCENTRAÇÃO DE CORANTES EM ALIMENTOS'
      },
      {
        code: 1992,
        name: 'PERMISSÃO DE USO DE TANQUES DE RESFRIAMENTO DE LEITE BOVINO E CAPRINO.'
      },
      {
        code: 1993,
        name: 'BIBLIOTECA VIRTUAL'
      },
      {
        code: 1994,
        name: 'PUBLICAÇÃO DE ARTIGOS ORIGINAIS E INÉDITOS DE NATUREZA CIENTÍFICA NO PERIÓDICO CADERNOS ESP'
      },
      {
        code: 2002,
        name: 'COORDENAR E SUPERVISIONAR AS AÇÕES DE INFRAESTRUTURA HÍDRICA'
      },
      {
        code: 2003,
        name: 'OUVIDORIA'
      },
      {
        code: 2008,
        name: 'POPULARIZAÇÃO DA CIÊNCIA JUNTO À COMUNIDADE CEARENSE'
      },
      {
        code: 2010,
        name: 'ELABORAÇÃO DE DOSSIÊ DE LICITAÇÃO PARA CONTRATAÇÃO DE PROJETOS E OBRAS, ANÁLISE E ACOMPANHAMENTO DE PROJETOS ( BÁSICO E EXECUTIVO).'
      },
      {
        code: 2011,
        name: 'CONCESSÃO DE PERMISSÃO DE USO ESPECIAL, PARA UTILIZAÇÃO DAS FAIXAS DE DOMÍNIO DA RODOVIA SOB JURISDIÇÃO DO DER-CE.'
      },
      {
        code: 2012,
        name: 'CONCESSÃO DE AUTORIZAÇÃO, PARA CONSTRUÇÃO DE ACESSO A PROPRIEDADES MARGINAIS AS RODOVIAS SOB JURISDIÇÃO DO DER-CE'
      },
      {
        code: 2014,
        name: 'BOLETIM DE OCORRÊNCIA NO INTERIOR DO ESTADO'
      },
      {
        code: 2016,
        name: 'RECEBIMENTO DE RECURSO EXTRAORDINÁRIO'
      },
      {
        code: 2017,
        name: 'RECEBIMENTO DE DOCUMENTOS FISCAIS E CONTÁBEIS PARA REALIZAÇÃO DE PERÍCIA'
      },
      {
        code: 2018,
        name: 'RECEBIMENTO DE MANIFESTAÇÃO SOBRE LAUDO PERICIAL'
      },
      {
        code: 2019,
        name: 'PEDIDO DE DILATAÇÃO DE PRAZO DE AUTO DE INFRAÇÃO'
      },
      {
        code: 2020,
        name: 'CAPACITAÇÃO DOS MOBILIZADORES SOCIAIS'
      },
      {
        code: 2021,
        name: 'REALIZAÇÃO DE ENCONTROS REGIONAIS'
      },
      {
        code: 2022,
        name: 'REALIZAÇÃO DE SEMINÁRIOS COM O TERCEIRO SETOR'
      },
      {
        code: 2023,
        name: 'ATENDIMENTO DE URGÊNCIA E EMERGÊNCIA EM PEDIATRIA'
      },
      {
        code: 2024,
        name: 'INTERNAÇÃO DE PACIENTES REFERENCIADOS DE OUTRAS INSTITUIÇÕES HOSPITALARES'
      },
      {
        code: 2026,
        name: 'INSTALAÇÃO DE SISTEMAS DE ABASTECIMENTO DÁGUA COM DESSALINIZADOR E CHAFARIZ ELETRÔNICO'
      },
      {
        code: 2027,
        name: 'INSTALAÇÃO DE SISTEMAS SIMPLIFICADO DE ABASTECIMENTO DÁGUA'
      },
      {
        code: 2028,
        name: 'INSTALAÇÃO DE SISTEMAS SIMPLIFICADO DE ABASTECIMENTO D’ÁGUA COM CATAVENTO'
      },
      {
        code: 2029,
        name: 'REGISTRO DE BOLETIM DE OCORRÊNCIA NA CAPITAL E REGIÃO METROPOLITANA'
      },
      {
        code: 2030,
        name: 'RECUPERAÇÃO DE SISTEMAS DE ABASTECIMENTO DÁGUA COM DESSALINIZADOR.'
      },
      {
        code: 2031,
        name: 'CAPTURA DE FORAGIDOS DA JUSTIÇA E CUMPRIMENTO DE MANDADO DE PRISÃO'
      },
      {
        code: 2032,
        name: 'REVITALIZAÇÃO DE SISTEMAS DE ABASTECIMENTO D’ÁGUA COM DESSALINIZADOR.'
      },
      {
        code: 2035,
        name: 'BOLETIM DE OCORRÊNCIA DE CRIMES CONTRA A EXPLORAÇÃO DE CRIANÇAS E ADOLESCENTES'
      },
      {
        code: 2037,
        name: 'REGISTRO DE BOLETIM DE OCORRÊNCIAS PRATICADAS POR CRIANÇAS E ADOLESCENTES'
      },
      {
        code: 2043,
        name: 'REGISTRO DE OCORRÊNCIA CONTRA A ORDEM TRIBUTÁRIA'
      },
      {
        code: 2044,
        name: 'LOCAÇÃO DE ESPAÇO PARA EVENTOS'
      },
      {
        code: 2047,
        name: 'BOLETIM DO OCORRÊNCIA DE FURTO/ROUBO DE VEÍCULOS E CARGAS'
      },
      {
        code: 2048,
        name: 'EDITAL PARA APRESENTAÇÕES ARTÍSTICAS.'
      },
      {
        code: 2049,
        name: 'BOLETIM DE OCORRÊNCIA ENVOLVENDO TURISTA'
      },
      {
        code: 2050,
        name: 'PROJETO A ESCOLA CRIATIVA NO DRAGÃO DO MAR.'
      },
      {
        code: 2052,
        name: 'PROJETO BRINCANDO E PINTANDO NO DRAGÃO DO MAR.'
      },
      {
        code: 2055,
        name: 'AGENDAMENTO NO PLANETÁRIO RUBENS DE AZEVEDO PARA ESCOLAS PÚBLICAS'
      },
      {
        code: 2059,
        name: 'SERVIÇO JURÍDICO'
      },
      {
        code: 2060,
        name: 'AGENDAMENTO NO PLANETÁRIO RUBENS DE AZEVEDO, PARA ESCOLAS E GRUPOS PARTICULARES.'
      },
      {
        code: 2062,
        name: 'REGISTRO DE BOLETINS DE OCORRÊNCIA DE CRIMES CONTRA A MULHER'
      },
      {
        code: 2065,
        name: 'BOLETIM DE OCORRÊNCIAS ELETRÔNICO'
      },
      {
        code: 2067,
        name: 'REGISTRO DE OCORRÊNCIA DE ESTELIONATO E OUTRAS FRAUDES'
      },
      {
        code: 2069,
        name: 'REGISTRO DE OCORRÊNCIA DE USO/TRÁFICO DE DROGAS.'
      },
      {
        code: 2071,
        name: 'CAPACITAÇÃO DE MULTIPLICADORES'
      },
      {
        code: 2072,
        name: 'REGISTRO DE OCORRÊNCIAS DE FRAUDES E DESVIO DO DINHEIRO PÚBLICO'
      },
      {
        code: 2077,
        name: 'DISTRIBUIÇÃO DE “VALE IDOSO”'
      },
      {
        code: 2078,
        name: 'DISTRIBUIÇÃO DE “VALE ESPECIAL” PARA PORTADOR DE NECESSIDADE ESPECIAL.'
      },
      {
        code: 2080,
        name: 'VENDA DE “VALE TRANSPORTE ESTUDANTIL”.'
      },
      {
        code: 2081,
        name: 'VENDA DE “VALE TRANSPORTE”.'
      },
      {
        code: 2082,
        name: 'CONCESSÃO DE PERMISSÃO DE USO ESPECIAL OU TERMO DE COMPROMISSO PARA UTILIZAÇÃO DAS FAIXAS DE DOMÍNIO DAS RODOVIAS SOB JURISDIÇÃO DO DER-CE'
      },
      {
        code: 2083,
        name: 'COMUNICAÇÃO DE EXTRAVIO DE ECF'
      },
      {
        code: 2085,
        name: 'ISENÇÃO DO ICMS PARA VEÍCULO DE PROPRIEDADE DE PORTADOR DE DEFICIENCIA FÍSICA.'
      },
      {
        code: 2086,
        name: 'AUTORIZAÇÃO DE URBANIZAÇÃO DAS FAIXAS DE DOMÍNIO DAS RODOVIAS SOB JURISDIÇÃO DO DER-CE, PELAS PREFEITURAS MUNICIPAIS.'
      },
      {
        code: 2087,
        name: 'LIBERAÇÃO DE MERCADORIAS RETIDAS MEDIANTE TERMO DE FIANÇA.'
      },
      {
        code: 2088,
        name: 'REATIVAÇÃO NO CADASTRO GERAL DA FAZENDA – CGF.'
      },
      {
        code: 2090,
        name: 'RESTITUIÇÃO DE ICMS'
      },
      {
        code: 2091,
        name: 'OUTORGA DE EXECUÇÃO DE OBRA E/OU SERVIÇO DE INTERFERÊNCIA HÍDRICA'
      },
      {
        code: 2092,
        name: 'OUTORGA DE DIREITO DE USO DOS RECURSOS HÍDRICOS'
      },
      {
        code: 2093,
        name: 'UMIDADE DO SOLO E NÚMERO DE DIAS PARA O DÉFICIT HÍDRICO'
      },
      {
        code: 2094,
        name: 'PROBABILIDADE DE LUCROS EM PLANTIOS'
      },
      {
        code: 2095,
        name: 'CÁLCULO OTIMIZADO DAS NECESSIDADES DE IRRIGAÇÃO.'
      },
      {
        code: 2096,
        name: 'CREDENCIAMENTO SEFAZNET'
      },
      {
        code: 2097,
        name: 'PREVISÃO DE AFLUÊNCIAS'
      },
      {
        code: 2098,
        name: 'PRECIPITAÇÃO MÉDIA'
      },
      {
        code: 2099,
        name: 'CURSOS DE FORMAÇÃO EM ARTE E CULTURA – PROJETO JARDIM DE GENTE'
      },
      {
        code: 2100,
        name: 'PREVISÃO NUMÉRICA DO CLIMA'
      },
      {
        code: 2101,
        name: 'APRESENTAÇÕES CULTURAIS GRATUITAS NO CENTRO CULTURAL BOM JARDIM.'
      },
      {
        code: 2102,
        name: 'ATENDIMENTO ÀS DEMANDAS SOCIAIS DOS USUÁRIOS DO HSJ'
      },
      {
        code: 2104,
        name: 'MONITORAMENTO GLOBAL SEMANAL'
      },
      {
        code: 2105,
        name: 'SELEÇÃO PARA APRESENTAÇÕES ARTÍSTICAS NO CENTRO CULTURAL BOM JARDIM.'
      },
      {
        code: 2106,
        name: 'ACESSO AO ESTÚDIO DE MÚSICA DO CENTRO CULTURAL BOM JARDIM.'
      },
      {
        code: 2107,
        name: 'RECEBIMENTO DE DENÚNCIAS, RECLAMAÇÕES, SUGESTÕES E ELOGIOS.'
      },
      {
        code: 2108,
        name: 'ASSISTÊNCIA MÉDICA E PSICOSSOCIAL AO SERVIDOR E SEUS FAMILIARES'
      },
      {
        code: 2109,
        name: 'REGISTRO DE OCORRÊNCIA DE CRIMES CONTRA O CONSUMIDOR'
      },
      {
        code: 2110,
        name: 'REPRESSÃO AO SEQUESTRO DE PESSOAS'
      },
      {
        code: 2111,
        name: 'ACESSO A BIBLIOTECA DO CENTRO CULTURAL BOM JARDIM.'
      },
      {
        code: 2112,
        name: 'SERVIÇO DE ELABORAÇÃO DE PARECER DE ABONO'
      },
      {
        code: 2114,
        name: 'SERVIÇO DE ELABORAÇÃO DE PARECER DE LEGALIDADE DE APOSENTADORIA'
      },
      {
        code: 2115,
        name: 'SERVIÇO DE ELABORAÇÃO DE PARECER DE PENSÃO'
      },
      {
        code: 2117,
        name: 'SERVIÇO DE ELABORAÇÃO DE PARECER DE RESERVA E REFORMA'
      },
      {
        code: 2120,
        name: 'EXAME EM LOCAL DE ACIDENTE DE TRANSITO COM VÍTIMA LESIONADA E/OU MORTA'
      },
      {
        code: 2121,
        name: 'EXAME EM LOCAL DE ACIDENTE DE TRÂNSITO COM VEÍCULO OFICIAL.'
      },
      {
        code: 2122,
        name: 'EXAME EM LOCAL DE MORTE VIOLENTA'
      },
      {
        code: 2124,
        name: 'EMISSÃO DE LAUDO TÉCNICO'
      },
      {
        code: 2125,
        name: 'PRESTAR INFORMAÇÕES INSTITUCIONAIS À IMPRENSA.'
      },
      {
        code: 2126,
        name: 'PREVISÃO NUMÉRICA DO TEMPO'
      },
      {
        code: 2127,
        name: 'CONSTRUÇÃO DE ADUTORAS'
      },
      {
        code: 2128,
        name: 'CONSTRUÇÃO DE BARRAGENS'
      },
      {
        code: 2129,
        name: 'CONSTRUÇÃO DE CANAIS'
      },
      {
        code: 2131,
        name: 'SELEÇÃO DE ARTISTAS PLÁSTICOS PARA EXPOR NO CENTRO CULTURAL BOM JARDIM.'
      },
      {
        code: 2132,
        name: 'EXAME DE EFICIÊNCIA EM ARMA DE FOGO E MUNIÇÃO'
      },
      {
        code: 2133,
        name: 'VISITAÇÃO ÀS EXPOSIÇÕES DO CENTRO CULTURAL BOM JARDIM.'
      },
      {
        code: 2134,
        name: 'EXAME PERICIAL EM DOCUMENTO'
      },
      {
        code: 2135,
        name: 'ACESSO À BIBLIOTECA DA ESCOLA DE ARTES E OFÍCIOS THOMAZ POMPEU SOBRINHO.'
      },
      {
        code: 2136,
        name: 'ACESSO À ILHA DIGITAL DA ESCOLA DE ARTES E OFÍCIOS THOMAZ POMPEU SOBRINHO.'
      },
      {
        code: 2137,
        name: 'CHUVAS DIÁRIAS'
      },
      {
        code: 2138,
        name: 'CALENDÁRIO DAS CHUVAS'
      },
      {
        code: 2139,
        name: 'GRÁFICO DE CHUVAS DOS POSTOS PLUVIOMÉTRICOS'
      },
      {
        code: 2140,
        name: 'MONITORAMENTO AMBIENTAL - ANÁLISES DE LABORATÓRIO.'
      },
      {
        code: 2141,
        name: 'MONITORAMENTO AMBIENTAL - MONITORAMENTO DAS ÁGUAS SUPERFICIAS DOS PRINCIPAIS RIOS DO ESTADO DO CEARÁ E SEUS AFLUENTES.'
      },
      {
        code: 2142,
        name: 'PERMISSÃO DE USO DE BOTIJÃO CRIOGÊNICO(INSEMINAÇÃO ARTIFICIAL)PARA CONSERVAÇÃO DE SÊMEN BOVINO.'
      },
      {
        code: 2144,
        name: 'PROGRAMA DE ASSISTÊNCIA DOMICILIAR - PAD'
      },
      {
        code: 2147,
        name: 'SERVIÇO DE CRIAÇÃO DE GEM'
      },
      {
        code: 2148,
        name: 'SERVIÇO DE CRIAÇÃO DE INTERFACE'
      },
      {
        code: 2149,
        name: 'SERVIÇO DE CRIAÇÃO DE INTRANET'
      },
      {
        code: 2150,
        name: 'SERVIÇO DE CRIAÇÃO DE MAPA INTERATIVO'
      },
      {
        code: 2151,
        name: 'SERVIÇO DE CRIAÇÃO DE MIDIA IMPRESSA E DIGITAL'
      },
      {
        code: 2152,
        name: 'SERVIÇO DE CRIAÇÃO DE SAF'
      },
      {
        code: 2154,
        name: 'SERVIÇO DE CRIAÇÃO DE SITE'
      },
      {
        code: 2155,
        name: 'EXAME DE EFICIÊNCIA DE ARMA DE FOGO'
      },
      {
        code: 2156,
        name: 'SERVIÇO DE ELABORAÇÃO DE RELATÓRIOS'
      },
      {
        code: 2157,
        name: 'SERVIÇO DE MANUTENÇÃO DE GEM'
      },
      {
        code: 2158,
        name: 'SERVIÇO DE MANUTENÇÃO DE INTERFACE'
      },
      {
        code: 2159,
        name: 'SERVIÇO DE MANUTENÇÃO DE INTRANET'
      },
      {
        code: 2160,
        name: 'SERVIÇO DE MANUTENÇÃO DE MAPA INTERATIVO'
      },
      {
        code: 2161,
        name: 'SERVIÇO DE MANUTENÇÃO DE SAF'
      },
      {
        code: 2162,
        name: 'SERVIÇO DE MANUTENÇÃO DE SITE'
      },
      {
        code: 2163,
        name: 'SERVIÇO DE MANUTENÇÃO DO EPGE'
      },
      {
        code: 2164,
        name: 'SERVIÇO DE CADASTRO DE AUDIÊNCIA'
      },
      {
        code: 2165,
        name: 'EXAME EM LOCAL DE ACIDENTE DE TRANSITO COM VEÍCULO OFICIAL'
      },
      {
        code: 2166,
        name: 'SERVIÇO DE EMISSÃO DE OFÍCIOS'
      },
      {
        code: 2167,
        name: 'SERVIÇO DE EMISSÃO DE REQUISIÇÕES'
      },
      {
        code: 2168,
        name: 'SERVIÇO DE INFORMAÇÕES AO PÚBLICO'
      },
      {
        code: 2169,
        name: 'CURSOS DE FORMAÇÃO EM ARTES E OFÍCIOS.'
      },
      {
        code: 2170,
        name: 'EXAME EM LOCAL DE ACIDENTE DE TRANSITO COM VEÍCULO OFICIAL'
      },
      {
        code: 2171,
        name: 'SERVIÇO DE ASSESSORIA JURÍDICA'
      },
      {
        code: 2172,
        name: 'SERVIÇO DE ASSISTÊNCIA TÉCNICA PARA ACOMPANHAMENTO DE PERÍCIA'
      },
      {
        code: 2173,
        name: 'SERVIÇO DE AVALIAÇÃO DE IMÓVEIS'
      },
      {
        code: 2174,
        name: 'SERVIÇO DE COLETA E PROCESSAMENTO DE DADOS'
      },
      {
        code: 2175,
        name: 'CONFERÊNCIA SOBRE TRANSPARÊNCIA E CONTROLE SOCIAL - CONSOCIAL'
      },
      {
        code: 2176,
        name: 'SERVIÇO DE LEVANTAMENTO TOPOGRÁFICO GEOREFERENCIADO'
      },
      {
        code: 2177,
        name: 'EXAME EM LOCAL DE ACIDENTE DE TRANSITO COM VÍTIMA LESIONADA E/OU MORTA'
      },
      {
        code: 2178,
        name: 'SERVIÇO DE MANIFESTAÇÃO DOS HONORÁRIOS PERICIAIS'
      },
      {
        code: 2179,
        name: 'SERVIÇO DE REGULARIZAÇÃO IMOBILIÁRIA'
      },
      {
        code: 2180,
        name: 'SERVIÇO DE USUCAPIÃO'
      },
      {
        code: 2181,
        name: 'EXAME EM LOCAL DE ACIDENTE DE TRANSITO COM VÍTIMA LESIONADA E/OU MORTA'
      },
      {
        code: 2182,
        name: 'SERVIÇO FINANCEIRO JURÍDICO E ADMINISTRATIVO'
      },
      {
        code: 2183,
        name: 'INTERNAÇÃO PARA CUIDADOS INTENSIVOS EM PACIENTES COM DOENÇAS INFECTO-CONTAGIOSAS'
      },
      {
        code: 2184,
        name: 'ATENDIMENTO PSICOPEDAGÓGICO (BRINQUEDOTECA)'
      },
      {
        code: 2187,
        name: 'ATENDIMENTO DA FISIOTERAPIA AOS PACIENTES INTERNADOS NO HSJ'
      },
      {
        code: 2188,
        name: 'ATENDIMENTO DA NUTRIÇÃO AOS PACIENTES EXTERNOS'
      },
      {
        code: 2189,
        name: 'ATENDIMENTO ÀS MANIFESTAÇÕES DOS USUÁRIOS DO HSJ, EXPRESSAS ATRAVÉS DE SOLICITAÇÕES, PEDIDOS DE INFORMAÇÕES, RECLAMAÇÕES, SUGESTÕES, DENÚNCIA'
      },
      {
        code: 2190,
        name: 'DISPENSAÇÃO (ENTREGA) DE MEDICAMENTOS PARA PACIENTES ATENDIDOS NO AMBULATÓRIO E EMERGÊNCIA DO HSJ'
      },
      {
        code: 2191,
        name: 'ASSISTÊNCIA DOMICILIAR AOS PACIENTES INTERNADOS NO HSJ'
      },
      {
        code: 2192,
        name: 'PRONTO-ATENDIMENTO E EMERGÊNCIA DO HSJ'
      },
      {
        code: 2193,
        name: 'MONITORAMENTO AMBIENTAL - AUTOMONITORAMENTO'
      },
      {
        code: 2194,
        name: 'MONITORAMENTO AMBIENTAL - PROGRAMA DE COMBATE À FUMAÇA NEGRA'
      },
      {
        code: 2195,
        name: 'MONITORAMENTO AMBIENTAL - MONITORAMENTO DA BALNEABILIDADE DAS PRAIAS.'
      },
      {
        code: 2196,
        name: 'APURAÇÃO DE HOMICÍDIO'
      },
      {
        code: 2197,
        name: 'REGISTRO DE OCORRÊNCIAS DE ROUBOS OU FURTOS CONTRA O PATRIMÔNIO'
      },
      {
        code: 2198,
        name: 'MAPEAMENTO DOS ESPELHOS DÁGUA'
      },
      {
        code: 2199,
        name: 'REGIONALIZAÇÃO'
      },
      {
        code: 2200,
        name: 'NÍVEL DIÁRIO DOS RESERVATÓRIOS'
      },
      {
        code: 2201,
        name: 'CALENDÁRIO DAS CHUVAS'
      },
      {
        code: 2202,
        name: 'POTENCIAL DIÁRIO DE ENERGIA SOLAR'
      },
      {
        code: 2203,
        name: 'COMITÊ DE ÉTICA EM PESQUISA (CEP)'
      },
      {
        code: 2204,
        name: 'PROJETO VIVA MAIS'
      },
      {
        code: 2205,
        name: 'POTENCIAL DIÁRIO DE ENERGIA EÓLICA'
      },
      {
        code: 2206,
        name: 'Dispensação de medicamentos e Insumos'
      },
      {
        code: 2207,
        name: 'ATENDIMENTO MULTIPROFISSIONAL DE CRIANÇAS PORTADORAS DE FISSURAS LÁBIO PALATAIS (LÁBIO LEPORINO OU FENDA PALATINA).'
      },
      {
        code: 2208,
        name: 'INTERNAÇÃO DOMICILIAR EM PEDIATRIA A DEPENDENTES DE VENTILAÇÃO MECÂNICA INVASIVA OU NÃO-INVASIVA.'
      },
      {
        code: 2209,
        name: 'PREVINA - PROGRAMA ESTADUAL DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 2210,
        name: 'PROJETO MÃO AMIGA'
      },
      {
        code: 4812,
        name: 'FOLHA DE PAGAMENTO'
      },
      {
        code: 2211,
        name: 'ZCIT - ZONA DE CONVERGÊNCIA INTERTROPICAL'
      },
      {
        code: 2212,
        name: 'PROJETO ESPORTE NA ESCOLA'
      },
      {
        code: 2213,
        name: 'QUANTIS'
      },
      {
        code: 2215,
        name: 'PROCESSAMENTO DE LICITAÇÕES'
      },
      {
        code: 2216,
        name: 'SERVIÇO DE ELABORAÇÃO DE CURSOS, PALESTRAS E SEMINÁRIOS JURÍDICOS'
      },
      {
        code: 2217,
        name: 'SELEÇÃO DE ESTAGIÁRIOS PARA ATUAR NA PGE - PROCURADORIA GERAL DO ESTADO DO CEARÁ'
      },
      {
        code: 2218,
        name: 'TRANSPLANTE RENAL E PANCREÁTICO'
      },
      {
        code: 2220,
        name: 'ASSESSORIA DE IMPRENSA'
      },
      {
        code: 2221,
        name: 'ANÁLISES LABORATORIAIS PARA FINS AGRÍCOLAS'
      },
      {
        code: 2222,
        name: 'TRANSPLANTE HEPÁTICO'
      },
      {
        code: 2223,
        name: 'PROGRAMA NACIONAL DE FORTALECIMENTO DA AGRICULTURA FAMILIAR - PRONAF-A E A/C'
      },
      {
        code: 2224,
        name: 'EMISSÃO DE DECLARAÇÃO DE APTIDÃO AO PROGRAMA NACIONAL DE FORTALECIMENTO DA AGRICULTURA FAMILIAR – DAP GRUPO A'
      },
      {
        code: 2225,
        name: 'INSCRIÇÃO PARA CURSOS DE LÍNGUAS ESTRANGEIRAS DO PROJETO DE LÍNGUAS - PROLIN'
      },
      {
        code: 2226,
        name: 'REGISTRO E ARQUIVAMENTO DE ATOS MERCANTIS E ATIVIDADE AFINS.'
      },
      {
        code: 2227,
        name: 'AQUISIÇÃO DE IMÓVEIS RURAIS ATRAVÉS DE FINANCIAMENTO NO ÂMBITO DO PROGRAMA NACIONAL DE CRÉDITO FUNDIÁRIO - PNCF'
      },
      {
        code: 2229,
        name: 'SUBPROJETOS DE INVESTIMENTOS COMUNITÁRIOS NÃO REEMBOLSÁVEIS - SICS E PRESTAÇÕES DE CONTAS'
      },
      {
        code: 2230,
        name: 'REGULARIZAÇÃO DO QUADRO SOCIAL DAS ASSOCIAÇÕES BENEFICIADAS COM FINANCIAMENTO DA TERRA, ATRAVÉS DO PROGRAMA NACIONAL DO CRÉDITO FUNDIÁRIO'
      },
      {
        code: 2231,
        name: 'EMISSÃO DE DECLARAÇÃO PARA FINS DE BENEFÍCIOS (APOSENTADORIA, AUXÍLIO-DOENÇA,AUXÍLIO-MATERNIDADE E OUTRAS)'
      },
      {
        code: 2234,
        name: 'SUPORTE GRÁFICO PARA CLASSIFICAÇÃO DAS ÁGUAS'
      },
      {
        code: 2235,
        name: 'AUTENTICAÇÃO DE LIVROS MERCANTIS'
      },
      {
        code: 2236,
        name: 'CONTRATAÇÃO DE FORNECEDORES DE SEMENTES PARA O PROJETO "HORA DE PLANTAR"'
      },
      {
        code: 2238,
        name: 'PROJETO BIODIESEL DO CEARÁ'
      },
      {
        code: 2240,
        name: 'CLASSIFICAÇÃO DE PRODUTOS DE ORIGEM VEGETAL (NACIONAL)'
      },
      {
        code: 2241,
        name: 'ASSESSORIA TÉCNICA AOS MUSEUS DO ESTADO'
      },
      {
        code: 2242,
        name: 'EVENTOS DE FORMAÇÃO'
      },
      {
        code: 2244,
        name: 'ANÁLISE DE SEMENTES DE PRODUÇÃO'
      },
      {
        code: 2247,
        name: 'EXAME FÍSICO DESCRITIVO EM CORDAS E SIMILARES'
      },
      {
        code: 2248,
        name: 'VESTIBULAR'
      },
      {
        code: 2249,
        name: 'SOLICITAÇÃO DE TRANSFERÊNCIA'
      },
      {
        code: 2250,
        name: 'INSCRIÇÃO PARA INGRESSO COMO GRADUADO'
      },
      {
        code: 2253,
        name: 'SERVIÇO DE ELABORAÇÃO DE ADITIVO DE CONTRATO.'
      },
      {
        code: 2254,
        name: 'SERVIÇO DE ELABORAÇÃO DE CI'
      },
      {
        code: 2255,
        name: 'MATRÍCULA DE ALUNOS NOVATOS E VETERANOS'
      },
      {
        code: 2256,
        name: 'APROVEITAMENTO DE ESTUDOS'
      },
      {
        code: 2257,
        name: 'READMISSÃO APÓS ABANDONO'
      },
      {
        code: 2258,
        name: 'ATENDIMENTO AMBULATORIAL DE PACIENTES COM TESTE DO PEZINHO ALTERADO'
      },
      {
        code: 2259,
        name: 'SERVIÇO DE ELABORAÇÃO DE CONTRATOS'
      },
      {
        code: 2260,
        name: 'SOLICITAÇÃO DE MUDANÇA DE CURSO'
      },
      {
        code: 2261,
        name: 'ATENDIMENTO A PACIENTES PORTADORES DE HIPOTIREOIDISMO CONGÊNITO, FENILCETONÚRIA, ANEMIA FALCIFORME PROCEDENTES DE OUTROS ESTADOS'
      },
      {
        code: 2262,
        name: 'SOLICITAÇÃO DE TRANSFERÊNCIA FACULTATIVA INTERNA'
      },
      {
        code: 2263,
        name: 'SERVIÇO DE ELABORAÇÃO DE DESPACHO.'
      },
      {
        code: 2264,
        name: 'SERVIÇO DE ELABORAÇÃO DE TERMO DE REFERÊNCIA'
      },
      {
        code: 2266,
        name: 'SERVIÇO DE SOLICITAÇÃO DE PROPOSTAS COMERCIAIS.'
      },
      {
        code: 2267,
        name: 'ANÁLISE DE VIABILIDADE DA INVENÇÃO'
      },
      {
        code: 2268,
        name: 'EXPEDIÇÃO DE DIPLOMA'
      },
      {
        code: 2270,
        name: 'EXPEDIÇÃO DE DOCUMENTOS ACADÊMICOS DIVERSOS'
      },
      {
        code: 2271,
        name: 'SOLICITAÇÃO DE TRANCAMENTO DE MATRÍCULA (PARCIAL OU TOTAL)'
      },
      {
        code: 2272,
        name: 'CADASTRO DOS PRESTADORES DE SERVIÇOS TURÍSTICOS - CADASTUR'
      },
      {
        code: 2273,
        name: 'PRÁTICAS AGRÍCOLAS DE CONVIVÊNCIA COM O SEMIÁRIDO CEARENSE.'
      },
      {
        code: 2275,
        name: 'PESQUISA NO ACERVO.'
      },
      {
        code: 2276,
        name: 'EXPANSÃO E RECUPERAÇÃO DA CAJUCULTURA.'
      },
      {
        code: 2277,
        name: 'PUBLICAÇÃO DE LIVROS – COLEÇÃO OUTRAS HISTÓRIAS, CADERNOS PAULO FREIRE E OUTRAS LINHAS EDITORIAIS.'
      },
      {
        code: 2278,
        name: 'MODERNIZAÇÃO DA MANDIOCULTURA.'
      },
      {
        code: 2279,
        name: 'ACESSO À BIBLIOTECA DE ARTES VISUAIS LEONILSON'
      },
      {
        code: 2280,
        name: 'PESQUISA NO NÚCLEO DE DOCUMENTAÇÃO'
      },
      {
        code: 2281,
        name: 'MAPEAMENTOS TEMÁTICOS COM APLICAÇÃO DE TÉCNICAS DE SENSORIAMENTO REMOTO E GEOPROCESSAMENTO.'
      },
      {
        code: 2282,
        name: 'MAPEAMENTOS E ESTUDOS DE SOLOS DO CEARÁ.'
      },
      {
        code: 2283,
        name: 'BASE CARTOGRÁFICA COM APLICAÇÃO DE TÉCNICAS DE SENSORIAMENTO REMOTO E GEOPROCESSAMENTO.'
      },
      {
        code: 2284,
        name: 'DIAGNÓSTICOS AMBIENTAIS'
      },
      {
        code: 2285,
        name: 'INDICAÇÃO DE REGIÕES SEMIÁRIDAS'
      },
      {
        code: 2286,
        name: 'ESTUDOS DE DEGRADAÇÃO AMBIENTAL'
      },
      {
        code: 2287,
        name: 'ZONEAMENTOS AMBIENTAIS'
      },
      {
        code: 2289,
        name: 'MANDALLA CEARÁ'
      },
      {
        code: 2297,
        name: 'INSCRIÇÃO NO PROGRAMA DE EDUCAÇÃO TUTORIAL - PET'
      },
      {
        code: 2300,
        name: 'SERVIÇO DE ELABORAÇÃO DE MAPA COMPARATIVO DE PREÇOS'
      },
      {
        code: 2301,
        name: 'SERVIÇO DE ELABORAÇÃO DE OFÍCIO.'
      },
      {
        code: 2317,
        name: 'CIRURGIAS ELETIVAS'
      },
      {
        code: 2318,
        name: 'CIRURGIAS DE URGÊNCIA E EMERGÊNCIA'
      },
      {
        code: 2319,
        name: 'ESCOLARIZAÇÃO PARA FUNCIONÁRIOS'
      },
      {
        code: 2325,
        name: 'ATENDIMENTO ODONTOLÓGICO PARA PACIENTES DO HSJ'
      },
      {
        code: 2326,
        name: 'ATENDIMENTO PSICOLÓGICO PARA OS PACIENTES DO HSJ'
      },
      {
        code: 2330,
        name: 'ATENDIMENTO DE DERMATOLOGIA GERAL PARA PACIENTES HIV DO HSJ.'
      },
      {
        code: 2332,
        name: 'ESTÁGIO CURRICULAR NÃO OBRIGATÓRIO.'
      },
      {
        code: 2333,
        name: 'INSCRIÇÕES PARA OS CURSOS DE EXTENSÃO EM INFORMÁTICA:'
      },
      {
        code: 2335,
        name: 'ATENDIMENTO DE URGÊNCIA E EMERGÊNCIA EM CARDIOLOGIA E PNEUMOLOGIA.'
      },
      {
        code: 2336,
        name: 'CURSO PRÉ - UNIVERSITÁRIO UECEVEST'
      },
      {
        code: 2337,
        name: 'CAPACITAÇÃO E INCENTIVO AO DESPORTO - FUNDEJ'
      },
      {
        code: 2339,
        name: 'TRANSMISSÃO DO SINAL DE TELEVISAO COM PROGRAMAÇÃO DIÁRIA EM CANAL ABERTO, CANAL FECHADO E INTERNET'
      },
      {
        code: 2340,
        name: 'PROJETO VILAS OLIMPICAS'
      },
      {
        code: 2342,
        name: 'PROCESSO SELETIVO DE ESTUDANTES DE CURSO DE GRADUAÇÃO DA UECE PARA O PROGRAMA DE BOLSAS DE ESTUDOS E PERMANÊNCIA UNIVERSITÁRIA - PBEPU'
      },
      {
        code: 2343,
        name: 'PEDIDO DE PROTEÇÃO DE NOME EMPRESARIAL'
      },
      {
        code: 2346,
        name: 'MATRÍCULA DE LEILOEIRA'
      },
      {
        code: 2347,
        name: 'SERVIÇO DE INFORMAÇÕES A TERCEIROS'
      },
      {
        code: 2348,
        name: 'ATENDIMENTO TÉCNICO AOS CLIENTES'
      },
      {
        code: 2349,
        name: 'ATENDIMENTO À MÃE PUERPERA (MULHER QUE FOI MÃE A MENOS DE 30 DIAS)'
      },
      {
        code: 2350,
        name: 'VISITAS DOMICILIARES À MÃE PUÉRPERA (MULHER QUE FOI MÃE HÁ MENOS DE 30  DIAS)'
      },
      {
        code: 2351,
        name: 'COLETA DE LEITE HUMANO ORDENHADO EM DOMICÍLIO'
      },
      {
        code: 2352,
        name: 'SERVIÇO DE IMAGEM - EXAME DE RAIO X CONVENCIONAL'
      },
      {
        code: 2353,
        name: 'EXAME DE TOMOGRAFIA COMPUTADORIZADA'
      },
      {
        code: 2354,
        name: 'EXAME DE ULTRASSOM ABDOMINAL, TÓRAX, APARELHO, URINÁRIO, PÉLVICO, TRANSFONTANELAR.'
      },
      {
        code: 2355,
        name: 'EXAME DE ECOCARDIOGRAMA'
      },
      {
        code: 2356,
        name: 'EXAMES CONTRASTADOS (ENEMA OPACO, TRÂNSITO INTESTINAL, SERIOGRAFIA, URETROCISTOGRAFIA, UROGRAFIA EXCRETORA, PIELOGRAFIA)'
      },
      {
        code: 2363,
        name: 'VACINAS DE ROTINA'
      },
      {
        code: 2364,
        name: 'VACINA CONTRA PÓLIO INATIVADA'
      },
      {
        code: 2365,
        name: 'VACINA CONTRA VARICELA'
      },
      {
        code: 2366,
        name: 'FORMAÇÃO CONTINUADA'
      },
      {
        code: 2367,
        name: 'VACINA PNEUMOCÓCCICA 23 VALENTE'
      },
      {
        code: 2368,
        name: 'VACINA MENINGOCOCCICA C'
      },
      {
        code: 2369,
        name: 'FORMAÇÃO PROFISSIONAL – POLÍCIA CIVIL, POLÍCIA MILITAR, CORPO DE BOMBEIROS MILITAR, PEFOCE, BEM COMO INSTITUIÇÕES VINCULADAS OU CONVENIADAS.'
      },
      {
        code: 2370,
        name: 'VACINA TRÍPLICE BACTERIANA ACELULAR'
      },
      {
        code: 2372,
        name: 'VACINA CONTRA HEPATITE A'
      },
      {
        code: 2373,
        name: 'FORMAÇÃO NA MODALIDADE EAD'
      },
      {
        code: 2374,
        name: 'VACINA CONTRA HEPATITE B'
      },
      {
        code: 2375,
        name: 'VACINA CONTRA INFLUENZA'
      },
      {
        code: 2376,
        name: 'ESTUDOS NOS TELECENTROS – LABORATÓRIOS DE INFORMÁTICA'
      },
      {
        code: 2377,
        name: 'VACINA CONTRA HAEMOPHILUS INFLUENZAE B'
      },
      {
        code: 2380,
        name: 'IMUNOGLOBULINA ANTI-TETÂNICA'
      },
      {
        code: 2381,
        name: 'IMUNOGLOBULINA ANTI-VARICELA'
      },
      {
        code: 2382,
        name: 'IMUNOGLOBULINA ANTI-RÁBICA'
      },
      {
        code: 2384,
        name: 'CONFERÊNCIA ESTADUAL SOBRE TRANSPARÊNCIA E CONTROLE SOCIAL - CONSOCIAL'
      },
      {
        code: 2385,
        name: 'IMUNOGLOBULINA ANTI-HEPATITE B'
      },
      {
        code: 2387,
        name: 'RESIDÊNCIA MÉDICA EM PEDIATRIA DO HIAS'
      },
      {
        code: 2388,
        name: 'ESTÁGIO PARA MÉDICOS RESIDENTES MATRICULADOS EM OUTRAS INSTITUIÇÕES'
      },
      {
        code: 2389,
        name: 'SERVIÇO DE ALOCAÇÃO DE AGENTE PÚBLICO NO PORTAL DIGITAL'
      },
      {
        code: 2390,
        name: 'SERVIÇO DE ALTERAÇÃO DE CADASTRO NO EPGE'
      },
      {
        code: 2391,
        name: 'INSCRIÇÃO NO CADASTRO GERAL DA FAZENDA (CGF)'
      },
      {
        code: 2394,
        name: 'BAIXA DA INSCRIÇÃO NO CADASTRO GERAL DA FAZENDA (CGF).'
      },
      {
        code: 2395,
        name: 'SERVIÇO DE CRIAÇÃO DE CADASTRO DE CRÉDITO NO VOIP'
      },
      {
        code: 2396,
        name: 'RESIDÊNCIA MÉDICA EM CIRURGIA PEDIÁTRICA DO HIAS'
      },
      {
        code: 2397,
        name: 'RESIDÊNCIA MÉDICA EM CANCEROLOGIA PEDIÁTRICA DO HIAS'
      },
      {
        code: 2398,
        name: 'RESIDÊNCIA MÉDICA EM ORTOPEDIA E TRAUMATOLOGIA DO HIAS'
      },
      {
        code: 2545,
        name: 'GÁS SULFÍDRICO'
      },
      {
        code: 2399,
        name: 'RESIDÊNCIA MÉDICA EM ÁREAS DE ATUAÇÃO PEDIÁTRICA DO HIAS (PEDIATRIA, CARDIOLOGIA, GASTROENTEROLOGIA, PNEUMOLOGIA, HEMATOLOGIA E HEMOTERAPIA)'
      },
      {
        code: 2400,
        name: 'INTERNAÇÃO PARA PACIENTES COM PATOLOGIAS CLÍNICAS'
      },
      {
        code: 2402,
        name: 'RADIOGRAFIA DO TÓRAX'
      },
      {
        code: 2404,
        name: 'TESTE ERGOMÉTRICO EM 12 DERIVAÇÕES'
      },
      {
        code: 2405,
        name: 'VERIFICAÇÃO DE DADOS CADASTRAIS'
      },
      {
        code: 2407,
        name: 'CATETERISMO CARDÍACO'
      },
      {
        code: 2412,
        name: 'VERIFICAÇÃO DE VALORES LANÇADOS NA FATURA DE ÁGUA'
      },
      {
        code: 2413,
        name: 'IMPLANTAÇÃO DE PROJETOS DE INCLUSÃO ECONÔMICA: UNIDADE DE GERENCIAMENTO DO PROJETO DE DESENVOLVIMENTO RURAL SUSTENTÁVEL - UGP'
      },
      {
        code: 2414,
        name: 'PROJETOS SISTEMAS DE ABASTECIMENTO DE ÁGUA E ESGOTAMENTO SANITÁRIO SIMPLIFICADO: UNIDADE DE GERENCIAMENTO DO PROJETO DE DESENVOLVIMENTO RURAL'
      },
      {
        code: 2415,
        name: 'PROJETO QUINTAIS PRODUTIVOS MANTIDOS POR CISTERNA DE ENXURRADA.'
      },
      {
        code: 2416,
        name: 'ASSESSORIA DE IMPRENSA'
      },
      {
        code: 2418,
        name: 'ATENDIMENTO ONCOLÓGICO EM REGIME DE HOSPITAL- DIA'
      },
      {
        code: 2419,
        name: 'ATENDIMENTO ONCOLÓGICO EM REGIME DE HOSPITAL DIA-NOITE (QUIMIOTERAPIA SEQUENCIAL)'
      },
      {
        code: 2421,
        name: 'SERVIÇO DE REALIZAÇÃO DE BLOQUEIO DE SENHA NO SISTEMA EPGE'
      },
      {
        code: 2422,
        name: 'ATUALIZAÇÃO DOS NÍVEIS DOS AÇUDES MONITORADOS NO BANCO DE DADOS CORPORATIVO'
      },
      {
        code: 2423,
        name: 'MONITORAMENTO DA QUALIDADE DA ÁGUA DOS CORPOS HÍDRICOS'
      },
      {
        code: 2424,
        name: 'DIAGNÓSTICO AMBIENTAL DOS RESERVATÓRIOS'
      },
      {
        code: 2425,
        name: 'LEVANTAMENTOS BATIMÉTRICOS E TOPOGRÁFICOS'
      },
      {
        code: 2426,
        name: 'DIAGNÓSTICO DE MORTANDADE DE PEIXES'
      },
      {
        code: 2428,
        name: 'PROGRAMA SEGUNDO TEMPO'
      },
      {
        code: 2429,
        name: 'APROVEITAMENTO HIDROAGRÍCOLA DO COMPLEXO CASTANHÃO - PERÍMETROS IRRIGADOS DO ALAGAMAR, CURUPATI E MANDACARU.'
      },
      {
        code: 2430,
        name: 'ALTERAÇÃO DE TITULARIDADE'
      },
      {
        code: 2432,
        name: 'SOROLOGIA PARA RUBÉOLA IgM'
      },
      {
        code: 2433,
        name: 'SERVIÇO DE REALIZAÇÃO DE CADASTRO DE AGENTE PÚBLICO NO EPGE'
      },
      {
        code: 2434,
        name: 'SOROLOGIA PARA RUBÉOLA IgG'
      },
      {
        code: 2435,
        name: 'SERVIÇO DE CRIAÇÃO DE AGENTE PÚBLICO NO VOIP'
      },
      {
        code: 2436,
        name: 'FINANCIAR O DESENVOLVIMENTO INSTITUCIONAL (SOCIAL) DOS ÓRGÃOS: PMCE, PC, CBECE, SEJUS, COL. PM E COL. BOM.'
      },
      {
        code: 2437,
        name: 'SERVIÇO DE REALIZAÇÃO DE DESBLOQUEIO DE SENHA NO SISTEMA EPGE'
      },
      {
        code: 2438,
        name: 'SERVIÇO DE ELABORAÇÃO DE RELATÓRIO DAS CHAMADAS REALIZADAS POR AGENTES DO VOIP'
      },
      {
        code: 2439,
        name: 'SERVIÇO DE INDEXAÇÃO DE FICHAS DE REGISTRO DE ACOMPANHAMENTO DE PROCESSOS DA PROPAD NO PORTAL DIGITAL.'
      },
      {
        code: 2440,
        name: 'SERVIÇO DE INDEXAÇÃO DE PARECER DA CONSULTORIA GERAL NO PORTAL DIGITAL.'
      },
      {
        code: 2441,
        name: 'ELISA PARA DENGUE'
      },
      {
        code: 2444,
        name: 'SERVIÇO DE ORIENTAÇÕES DE DÚVIDAS DO VOIP'
      },
      {
        code: 2445,
        name: 'SERVIÇO DE REALIZAÇÃO DE ESCLARECIMENTOS DE DÚVIDAS NO PORTAL DIGITAL'
      },
      {
        code: 2446,
        name: 'ATENDIMENTO DE EMERGÊNCIA'
      },
      {
        code: 2447,
        name: 'SERVIÇO DE ORIENTAÇÃO DE DÚVIDAS NO SISTEMA EPGE.'
      },
      {
        code: 2448,
        name: 'SERVIÇO DE REALIZAÇÃO DE ESCLARECIMENTO DE DÚVIDAS NO SISTEMA VIPROC'
      },
      {
        code: 2449,
        name: 'TELEDENÚNCIA'
      },
      {
        code: 2450,
        name: 'SERVIÇOS DE CORRESPONDÊNCIAS DA CTI'
      },
      {
        code: 2451,
        name: 'DESENVOLVIMENTO DA CADEIA PRODUTIVA APÍCOLA.'
      },
      {
        code: 2452,
        name: 'DESENVOLVIMENTO SUSTENTÁVEL DE TERRITÓRIOS RURAIS – INVESTIMENTO EM PROJETOS DE ENGENHARIA CIVIL - CONTRATO DE REPASSE UNIÃO\ESTADO'
      },
      {
        code: 2454,
        name: 'DESENVOLVIMENTO SUSTENTÁVEL DE TERRITÓRIOS RURAIS – INVESTIMENTO EM MÁQUINAS E EQUIPAMENTOS - CONTRATOS DE REPASSE UNIÃO\ESTADO'
      },
      {
        code: 2455,
        name: 'CESSÃO DE USO DE MÁQUINAS, EQUIPAMENTOS E EDIFICAÇÕES.'
      },
      {
        code: 2456,
        name: 'FEIRAS DE SOCIOECONOMIA SOLIDÁRIA.'
      },
      {
        code: 2457,
        name: 'DESENVOLVIMENTO RURAL SUSTENTÁVEL – INVESTIMENTO EM PROJETOS DE ENGENHARIA CIVIL - RECURSO DO ESTADO'
      },
      {
        code: 2458,
        name: 'DESENVOLVIMENTO RURAL SUSTENTÁVEL – INVESTIMENTO EM MÁQUINAS E/OU EQUIPAMENTOS - RECURSO DO ESTADO'
      },
      {
        code: 2459,
        name: 'DESENVOLVIMENTO RURAL SUSTENTÁVEL - CONVÊNIOS - RECURSOS DO ESTADO'
      },
      {
        code: 2460,
        name: 'DIAGNÓSTICO LABORATORIAL DE RAIVA EM HUMANOS'
      },
      {
        code: 2461,
        name: 'DIAGNÓSTICO LABORATORIAL DE RAIVA ANIMAL'
      },
      {
        code: 2462,
        name: 'SOROLOGIA PARA HEPATITE B – Anti - HBc IgM'
      },
      {
        code: 2463,
        name: 'CERTIFICADO DE REGULARIDADE FISCAL.'
      },
      {
        code: 2464,
        name: 'SOROLOGIA PARA HEPATITE B - HBc Total'
      },
      {
        code: 2465,
        name: 'SOROLOGIA PARA HEPATITE B - HBsAg'
      },
      {
        code: 2466,
        name: 'SOROLOGIA PARA HEPATITE C – ANTI - HCV'
      },
      {
        code: 2467,
        name: 'SOROLOGIA PARA HIV (ENSAIO IMUNOLÓGICO QUIMIOLUMINESCENTE)'
      },
      {
        code: 2468,
        name: 'SOROLOGIA PARA SÍFILIS- VDRL'
      },
      {
        code: 2469,
        name: 'AVALIAÇÃO DA ATIVIDADE ANTIMICROBIANA DE ANTI-SÉPTICO'
      },
      {
        code: 2470,
        name: 'ANÁLISE BACTERIOLÓGICA EM ÁGUA: CONTAGEM DE BACTÉRIAS HETEROTRÓFICAS, COLIFORMES TOTAIS E TERMOTOLERANTES)'
      },
      {
        code: 2472,
        name: 'ANALISE MICROBIOLÓGICA DE ALIMENTOS: CONTAGEM DE MOFOS E LEVEDURAS'
      },
      {
        code: 2473,
        name: 'ANALISE MICROBIOLÓGICA DE ALIMENTOS: SALMONELLA'
      },
      {
        code: 2474,
        name: 'ANALISE MICROBIOLÓGICA EM ALIMENTOS: BACILLUS CEREUS'
      },
      {
        code: 2476,
        name: 'ANÁLISE MICROBIOLÓGICA: CONTAGEM DE CLOSTRÍDIOS SULFITO REDUTORES'
      },
      {
        code: 2481,
        name: 'COLIFORMES TERMOTOLERANTES (NMP/100ML)'
      },
      {
        code: 2484,
        name: 'PROTEÍNAS'
      },
      {
        code: 2485,
        name: 'LIPÍDIOS, EXTRATO ETÉREO, GORDURA EM ALIMENTOS'
      },
      {
        code: 2488,
        name: 'INDICE DE PEROXIDO EM ALIMENTO'
      },
      {
        code: 2489,
        name: 'DETERMINAÇÃO DE PH'
      },
      {
        code: 2490,
        name: 'DETERMINAÇÃO DE SÓLIDOS SOLÚVEIS (GRAUS BRIX)'
      },
      {
        code: 2496,
        name: 'INTERNAÇÃO DE PACIENTES PORTADORES DE CÂNCER'
      },
      {
        code: 2499,
        name: 'DEFESA OU RECURSO DE AUTO DE INFRAÇÃO.'
      },
      {
        code: 2500,
        name: 'DILATAÇÃO DE PRAZO PARA DEFESA OU PAGAMENTO DE AUTO DE INFRAÇÃO.'
      },
      {
        code: 2501,
        name: 'COMUNICAÇÃO DE EXTRAVIO DE DOCUMENTOS FISCAIS.'
      },
      {
        code: 2502,
        name: 'DEVOLUÇÃO DE DOCUMENTOS FISCAIS NÃO UTILIZADOS.'
      },
      {
        code: 2503,
        name: 'CONVALIDAÇÃO DE DOCUMENTOS FISCAIS.'
      },
      {
        code: 2507,
        name: 'BRONCOSCOPIA'
      },
      {
        code: 2508,
        name: 'LARINGOSCOPIA'
      },
      {
        code: 2509,
        name: 'OPERAÇÕES E CAMPANHAS DE FISCALIZAÇÃO PROGRAMADAS'
      },
      {
        code: 2510,
        name: 'AÇÃO DE FISCALIZAÇÃO AMBIENTAL'
      },
      {
        code: 2511,
        name: 'EXPEDIÇÃO DE DOCUMENTO DE ORIGEM FLORESTAL - DOF'
      },
      {
        code: 2512,
        name: 'SERVIÇOS DE CRIAÇÃO DE AGENTE PÚBLICO NO VIPROC'
      },
      {
        code: 2519,
        name: 'PROVA DE LUND'
      },
      {
        code: 2525,
        name: 'AUTORIZAÇÃO AMBIENTAL PARA EVENTOS EM UNIDADE DE CONSERVAÇÃO'
      },
      {
        code: 2529,
        name: 'SÓLIDOS INSOLÚVEIS'
      },
      {
        code: 2530,
        name: 'TEOR DE ÁLCOOL'
      },
      {
        code: 2535,
        name: 'LÍTIO'
      },
      {
        code: 2539,
        name: 'ACIDEZ EM ALIMENTOS'
      },
      {
        code: 2541,
        name: 'CAPA DE GORDURA (CARNE DE CHARQUE)'
      },
      {
        code: 2547,
        name: 'CONCESSÃO DE AUTORIZAÇÃO PARA EXPLORAÇÃO FLORESTAL COM VISTAS A APROVAÇÃO DE PLANOS DE MANEJOS FLORESTAIS EM SUAS DIFERENTES MODALIDADES (FLORESTAL, AGROFLORESTAL, SILVIPASTORIL E AGROSILVIPASTORIL).'
      },
      {
        code: 2548,
        name: 'REGISTRO DE EMPRESAS QUE COMERCIALIZAM AGROTÓXICOS E CADASTRO DE AGROTÓXICOS COMERCIALIZADOS NO CEARÁ'
      },
      {
        code: 2549,
        name: 'INTERCEPTAÇÃO TELEFÔNICA'
      },
      {
        code: 2550,
        name: 'CONCESSÃO DE AUTORIZAÇÃO AMBIENTAL COM VISTAS A APROVAÇÃO DA RETIRADA DE ÁRVORE(S), NATIVA(S) OU PLANTADA(S), EM RUAS (OU AVENIDAS), PRAÇAS, JARDINS PÚBLICOS OU EM PROPRIEDADE PARTICULAR.'
      },
      {
        code: 2552,
        name: 'CONCESSÃO DE AUTORIZAÇÃO PARA DESMATAMENTO E “QUEIMA CONTROLADA” COM VISTAS A APROVAÇÃO DA RETIRADA DA VEGETAÇÃO NATIVA, PARA REALIZAR AGRICULTURA FAMILIAR.'
      },
      {
        code: 2553,
        name: 'CONCESSÃO DE AUTORIZAÇÃO PARA DESMATAMENTO COM VISTAS A APROVAÇÃO DA RETIRADA DA VEGETAÇÃO NATIVA, PARA REALIZAR A IMPLANTAÇÃO DE EMPREENDIMENTOS E ATIVIDADES AGRÍCOLAS, INDUSTRIAIS E DE COMÉRCIO E SERVIÇOS E OBRAS DE ENGENHARIA (CONSTRUÇÃO DE AÇUDES E/OU BARRAGENS'
      },
      {
        code: 2555,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IgM'
      },
      {
        code: 2556,
        name: 'CONCESSÃO DE TERMO PARA AVERBAÇÃO DA ÁREA DE RESERVA LEGAL COM VISTAS A APROVAÇÃO DESTE TIPO DE ÁREA, COMO EXIGÊNCIA LEGAL EXCLUSIVAMENTE PARA AS PROPRIEDADES E IMÓVEIS RURAIS.'
      },
      {
        code: 2557,
        name: 'CONCESSÃO DE CERTIFICADO DE CONSUMIDOR DE MATÉRIA-PRIMA DE ORIGEM FLORESTAL, COM VISTAS A APROVAÇÃO DE ATIVIDADES QUE IMPLIQUEM NA EXPLORAÇÃO, BENEFICIAMENTO, TRANSFORMAÇÃO, TRANSPORTE, INDUSTRIALIZAÇÃO, UTILIZAÇÃO, CONSUMO, COMERCIALIZAÇÃO, OU ARMAZENAMENTO, SOB QUALQUER FORMA, DE PRODUTOS (LENHA, ESTACA, MOURÃO, VARA, ETC.), SUBPRODUTOS (CARVÃO VEGETAL, RIPA, CAIBROS, VIGAS E MADEIRA SERRADA EM GERAL) OU MATÉRIA-PRIMA ORIGINÁRIA DE QUALQUER FORMAÇÃO FLORESTAL'
      },
      {
        code: 2558,
        name: 'CONCESSÃO DE AUTORIZAÇÃO PARA EXPLORAÇÃO FLORESTAL COM VISTAS A APROVAÇÃO DE EXPLORAÇÃO DO TALHÃO EM PLANOS DE MANEJOS FLORESTAIS EM SUAS DIFERENTES MODALIDADES (FLORESTAL, AGROFLORESTAL, SILVIPASTORIL E AGROSILVIPASTORIL).'
      },
      {
        code: 2559,
        name: 'ESTRUTURAÇÃO DOS CONSELHOS COMUNITÁRIOS DE DEFESA SOCIAL'
      },
      {
        code: 2560,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IgG'
      },
      {
        code: 2561,
        name: 'DETERMINAÇÃO DO TEOR DE FLÚOR EM ÁGUA.'
      },
      {
        code: 2562,
        name: 'DISSEMINAÇÃO DE INFORMAÇÃO AMBIENTAL'
      },
      {
        code: 2563,
        name: 'DETERMINAÇÃO DA TURBIDEZ DA ÁGUA'
      },
      {
        code: 2564,
        name: 'ELISA PARA LEISHMANIOSE VISCERAL CANINA'
      },
      {
        code: 2568,
        name: 'PESQUISA DO PARASITA DA MALÁRIA'
      },
      {
        code: 2569,
        name: 'BACILOSCOPIA PARA TUBERCULOSE'
      },
      {
        code: 2573,
        name: 'EXAME NECROPAPILOSCÓPICO.'
      },
      {
        code: 2574,
        name: 'CULTURA PARA MYCOBACTERIUM TUBERCULOSIS'
      },
      {
        code: 2577,
        name: 'Atendimento socioeducativo e cultural ao aposentado e pensionista do Serviço Público Estadual.'
      },
      {
        code: 2578,
        name: 'Atendimento ao servidor público estadual em fase de aposentadoria.'
      },
      {
        code: 2580,
        name: 'PARECER TÉCNICO PARA CRIAÇÃO DE UNIDADES DE CONSERVAÇÃO'
      },
      {
        code: 2583,
        name: 'AUTORIZAÇÃO AMBIENTAL PARA VISITA GUIADA EM UNIDADES DE CONSERVARÇÃO'
      },
      {
        code: 2586,
        name: 'CAPACITAÇÃO EM PRÁTICAS SUSTENTÁVEIS NA CAATINGA E MANEJO AGROFLORESTAL'
      },
      {
        code: 2589,
        name: 'PROGRAMA DE CONTROLE DO TABAGISMO'
      },
      {
        code: 2590,
        name: 'SERVIÇOS DE CRIAÇÃO DE FUNÇÃO UNIDADE DE EXERCÍCIO NO PORTAL DIGITAL'
      },
      {
        code: 2591,
        name: 'SERVIÇO DE CRIAÇÃO DE INSTITUIÇÃO NO PORTAL DIGITAL'
      },
      {
        code: 2592,
        name: 'SERVIÇO DE CRIAÇÃO DE UNIDADE DE EXERCÍCIO NO PORTAL DIGITAL'
      },
      {
        code: 2593,
        name: 'SERVIÇO DE INCLUSÃO DE AGENTE PÚBLICO NO PORTAL DIGITAL'
      },
      {
        code: 2594,
        name: 'SERVIÇO DE MONITORAÇÃO E ACOMPANHAMENTO DOS CHAMADOS REGISTRADOS NO OCOMON.'
      },
      {
        code: 2595,
        name: 'SERVIÇO DE REALIZAÇÃO DE PÓS-ATENDIMENTO NO OCOMON.'
      },
      {
        code: 2596,
        name: 'SERVIÇO DE REALIZAÇÃO DE REGISTROS DE CHAMADOS NO OCOMON'
      },
      {
        code: 2597,
        name: 'SERVIÇO DE REALIZAÇÃO DE TREINAMENTO NO VOIP'
      },
      {
        code: 2598,
        name: 'FORMAÇÃO CONTINUADA DE EDUCADORES DA EDUCAÇÃO BÁSICA COM FOCO NA EDUCAÇÃO DE JOVENS E ADULTOS E NA IMPLEMENTAÇÃO DE POLÍTICAS PÚBLICAS, EM PA'
      },
      {
        code: 2599,
        name: 'ASSENTAMENTO DE FAMÍLIAS DE TRABALHADORES RURAIS SEM TERRA OU COM POUCA TERRA, ATRAVÉS DE FINANCIAMENTO DE IMÓVEIS RURAIS, CONFORME LEI COMPLEMENTAR'
      },
      {
        code: 2602,
        name: 'REASSENTAMENTO DE FAMÍLIAS ATINGIDAS PELAS OBRAS DE IMPLANTAÇÃO DE GRANDES EMPREENDIMENTOS NO ESTADO'
      },
      {
        code: 2607,
        name: 'APOIO AOS BENEFICIÁRIOS DOS ASSENTAMENTOS ESTADUAIS ( POR DESAPROPRIAÇÃO OU POR FINANCIAMENTO )'
      },
      {
        code: 2608,
        name: 'EMISSÃO DE TÍTULOS DE PROPRIEDADE DE TERRA.'
      },
      {
        code: 2609,
        name: 'COORDENAÇÃO DE TRANSPLANTES'
      },
      {
        code: 2610,
        name: 'REGULAÇÃO DO ACESSO-ASSISTÊNCIA AMBULATORIAL E HOSPITALAR'
      },
      {
        code: 2611,
        name: 'REORDENAMENTO FUNDIÁRIO DE FAMÍLIAS MINIFUNDISTAS'
      },
      {
        code: 2612,
        name: 'REGULAÇÃO DO ACESSO - TRATAMENTO FORA DE DOMICÍLIO -TFD'
      },
      {
        code: 2613,
        name: 'ORIENTAÇÃO TÉCNICA'
      },
      {
        code: 2614,
        name: 'ATIVIDADE DE AUDITORIA DE TOMADA DE CONTAS ESPECIAL'
      },
      {
        code: 2615,
        name: 'PORTAL DA TRANSPARÊNCIA'
      },
      {
        code: 2616,
        name: 'RELATÓRIO DO CONTROLE INTERNO SOBRE AS CONTAS ANUAIS DE GOVERNO'
      },
      {
        code: 2617,
        name: 'ATENDIMENTO AMBULATORIAL DE ENFERMAGEM – PROCEDIMENTOS'
      },
      {
        code: 2618,
        name: 'ATENDIMENTO AMBULATORIAL DE ENFERMAGEM – AGENDAMENTO CIRÚRGICO'
      },
      {
        code: 2619,
        name: 'ATENDIMENTO AMBULATORIAL DE NUTRIÇÃO'
      },
      {
        code: 2620,
        name: 'ATENDIMENTO AMBULATORIAL NAS ESPECIALIDADES MÉDICAS'
      },
      {
        code: 2625,
        name: 'DETECÇÃO DE COLIFORMES TOTAIS E FECAIS EM ÁGUA'
      },
      {
        code: 2626,
        name: 'PROCESSAMENTO DE DAE'
      },
      {
        code: 2628,
        name: 'CADASTRO DE LOCADORA DE VEÍCULOS'
      },
      {
        code: 2629,
        name: 'CERTIDÃO DE QUITAÇÃO DO IPVA.'
      },
      {
        code: 2631,
        name: 'ECO BI-DIMENSIONAL COM DOPPLER.'
      },
      {
        code: 2632,
        name: 'MONITORIZAÇÃO AMBULATORIAL DA PRESSÃO ARTERIAL (MAPA)'
      },
      {
        code: 2633,
        name: 'HOLTER'
      },
      {
        code: 2634,
        name: 'ULTRASSOM DOPPLER CAROTÍDEO E VERTEBRAL'
      },
      {
        code: 2635,
        name: 'ECO DOPPLER TISSULAR.'
      },
      {
        code: 2636,
        name: 'BACILOSCOPIA PARA TUBERCULOSE'
      },
      {
        code: 2637,
        name: 'CULTURA PARA MYCOBACTERIUM TUBERCULOSIS'
      },
      {
        code: 2638,
        name: 'SOROLOGIA PARA HEPATITE B –Anti - HBc IgM'
      },
      {
        code: 2639,
        name: 'SOROLOGIA PARA HEPATITE B - Anti HBc Total'
      },
      {
        code: 2640,
        name: 'SOROLOGIA PARA HEPATITE B - HBsAg'
      },
      {
        code: 2641,
        name: 'SOROLOGIA PARA DENGUE'
      },
      {
        code: 2642,
        name: 'SOROLOGIA PARA RUBÉOLA IgM'
      },
      {
        code: 2643,
        name: 'SOROLOGIA PARA RUBÉOLA IgG'
      },
      {
        code: 2644,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IGG'
      },
      {
        code: 2645,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IgM'
      },
      {
        code: 2646,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS IgG'
      },
      {
        code: 2647,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS - CMV IgM'
      },
      {
        code: 2648,
        name: 'SOROLOGIA PARA SÍFILIS- VDRL'
      },
      {
        code: 2649,
        name: 'SOROLOGIA PARA HIV (ENSAIO IMUNOLÓGICO QUIMIOLUMINESCENTE)'
      },
      {
        code: 2650,
        name: 'DETERMINAÇÃO DO TEOR DE FLÚOR EM ÁGUA'
      },
      {
        code: 2651,
        name: 'DETERMINAÇÃO DA TURBIDEZ DA ÁGUA'
      },
      {
        code: 2652,
        name: 'DETECÇÃO DE COLIFORMES TOTAIS E FECAIS'
      },
      {
        code: 2654,
        name: 'PARASITOLÓGICO DIRETO PARA LEISHMANIOSE TEGUMENTAR AMERICANA'
      },
      {
        code: 2655,
        name: 'PESQUISA DO PARASITA DA MALÁRIA'
      },
      {
        code: 2656,
        name: 'SOROLOGIA PARA HEPATITE C – ANTI - HCV'
      },
      {
        code: 2657,
        name: 'SOROLOGIA PARA DENGUE'
      },
      {
        code: 2658,
        name: 'SOROLOGIA PARA RUBÉOLA IGG'
      },
      {
        code: 2661,
        name: 'SOROLOGIA PARA RUBÉOLAI IgM'
      },
      {
        code: 2662,
        name: 'SOROLOGIA PARA HIV (ENSAIO IMUNOLÓGICO QUIMIOLUMINESCENTE)'
      },
      {
        code: 2663,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IgM'
      },
      {
        code: 2664,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IGG'
      },
      {
        code: 2665,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS IGG'
      },
      {
        code: 2666,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS - CMV IGM'
      },
      {
        code: 2667,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS IGG'
      },
      {
        code: 2668,
        name: 'SOROLOGIA PARA SÍFILIS- VDRL'
      },
      {
        code: 2669,
        name: 'PARASITOLÓGICO DIRETO PARA LEISHMANIOSE TEGUMENTAR AMERICANA'
      },
      {
        code: 2670,
        name: 'PESQUISA DO PARASITA DA MALÁRIA'
      },
      {
        code: 2671,
        name: 'DETERMINAÇÃO DO TEOR DE FLÚOR EM ÁGUA'
      },
      {
        code: 2672,
        name: 'DETERMINAÇÃO DA TURBIDEZ DA ÁGUA'
      },
      {
        code: 2673,
        name: 'DETECÇÃO DE COLIFORMES TOTAIS E FECAIS EM ÁGUA PARA CONSUMO HUMANO.'
      },
      {
        code: 2674,
        name: 'BACILOSCOPIA PARA TUBERCULOSE'
      },
      {
        code: 2675,
        name: 'CULTURA PARA MYCOBACTERIUM TUBERCULOSIS'
      },
      {
        code: 2676,
        name: 'DETECÇÃO DE COLIFORMES TOTAIS E FECAIS'
      },
      {
        code: 2677,
        name: 'DETERMINAÇÃO DO TEOR DE FLÚOR EM ÁGUA'
      },
      {
        code: 2678,
        name: 'DETERMINAÇÃO DA TURBIDEZ DA ÁGUA'
      },
      {
        code: 2681,
        name: 'BACILOSCOPIA PARA TUBERCULOSE'
      },
      {
        code: 2684,
        name: 'ELABORAÇÃO E CONSOLIDAÇÃO DO RELATÓRIO SEMESTRAL DE ACOMPANHAMENTO DA EXECUÇÃO FÍSICO-FINANCEIRA DOS CONTRATOS DE GESTÃO'
      },
      {
        code: 2688,
        name: 'ESPIROMETRIA'
      },
      {
        code: 2689,
        name: 'EXAME DE DLCO'
      },
      {
        code: 2690,
        name: 'OXIMETRIA DE PULSO'
      },
      {
        code: 2691,
        name: 'ELISA PARA DENGUE'
      },
      {
        code: 2695,
        name: 'SOROLOGIA PARA HEPATITE C - ANTI-HCV'
      },
      {
        code: 2697,
        name: 'SOROLOGIA PARA CMV IgG'
      },
      {
        code: 2698,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS -CMV IgM'
      },
      {
        code: 2699,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IgG'
      },
      {
        code: 2700,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IgM'
      },
      {
        code: 2701,
        name: 'SOROLOGIA PARA SÍFILIS- VDRL'
      },
      {
        code: 2702,
        name: 'REAÇÃO DE POLIMERASE EM CADEIA – PCR PARA ENTEROBACTÉRIAS PRODUTORAS DE CARBAPENEMASES ( KPC).'
      },
      {
        code: 2703,
        name: 'DOSAGEM DE ACIDO ÚRICO.'
      },
      {
        code: 2704,
        name: 'LIGAÇÃO DE ESGOTO'
      },
      {
        code: 2706,
        name: 'ISENÇÃO DO IPVA PARA PORTADOR DE DEFICIENCIA FÍSICA'
      },
      {
        code: 2707,
        name: 'FORTALECIMENTO INSTITUCIONAL E APOIO A GESTÃO: UNIDADE DE GERENCIAMENTO DO PROJETO DE DESENVOLVIMENTO RURAL SUSTENTÁVEL - UGP'
      },
      {
        code: 2708,
        name: 'PROGRAMA DE EDUCAÇÃO PERMANENTE'
      },
      {
        code: 2709,
        name: 'AMBULATÓRIO DE CONSULTAS ESPECIALIZADAS'
      },
      {
        code: 2710,
        name: 'SERVIÇOS DE COMUNICAÇÃO INTERNA E EXTERNA E ASSESSORIA DE IMPRENSA'
      },
      {
        code: 2712,
        name: 'EXAME DE BIOPSY MAMA'
      },
      {
        code: 2713,
        name: 'EXAME DE BIOBSY PROSTÁTICA'
      },
      {
        code: 2716,
        name: 'TRATAMENTO CIRÚRGICO DE DENTE INCLUSO EM PACIENTE COM ANOMALIA CRÂNIO- BUCOMAXILO FACIAL.'
      },
      {
        code: 2717,
        name: 'COLOCAÇÃO DE PLACA DE MORDIDA.'
      },
      {
        code: 2718,
        name: 'INSTALAÇÃO DE PRÓTESE EM PACIENTES COM ANOMALIA CRÂNIO E BUCOMAXILOFACIAL'
      },
      {
        code: 2719,
        name: 'PLANO INCLINADO'
      },
      {
        code: 2721,
        name: 'BIÓPSIA DOS OSSOS DO CRÂNIO E DA FACE'
      },
      {
        code: 2722,
        name: 'BIÓPSIA DO TECIDOS MOLES DA BOCA.'
      },
      {
        code: 2723,
        name: 'TELERADIOGRAFIA'
      },
      {
        code: 2724,
        name: 'RADIOGRAFIA PERIAPICAL-INTERPROXIMAL .'
      },
      {
        code: 2725,
        name: 'RADIOGRAFIA PANORÂMICA'
      },
      {
        code: 2726,
        name: 'RADIOGRAFIA OCLUSAL'
      },
      {
        code: 2727,
        name: 'RADIOGRAFIA DO CRÂNIO (PÓSTERO -ANTERIOR, LATERAL)'
      },
      {
        code: 2728,
        name: 'OBTURAÇÃO DE DENTE PERMANENTE UNIRRADICULAR'
      },
      {
        code: 2729,
        name: 'OBTURAÇÃO DE DENTE PERMANENTE BIRRADICULAR.'
      },
      {
        code: 2730,
        name: 'OBTURAÇÃO DE DENTE PERMANENTE TRIRRADICULAR'
      },
      {
        code: 2731,
        name: 'RETRATAMENTO ENDODÔNTICO DE DENTE PERMANENTE UNIRRADICULAR'
      },
      {
        code: 2732,
        name: 'RETRATAMENTO ENDODÔNTICO DE DENTE PERMANENTE BIRRADICULAR'
      },
      {
        code: 2733,
        name: 'RETRATAMENTO ENDODÔNTICO DE DENTE PERMANENTE TRIRRADICULAR'
      },
      {
        code: 2734,
        name: 'OBTURAÇÃO DE DENTE DECÍDUO.'
      },
      {
        code: 2735,
        name: 'GENGIVECTOMIA'
      },
      {
        code: 2736,
        name: 'GENGIVOPLASTIA'
      },
      {
        code: 2737,
        name: 'TRATAMENTO CIRÚRGICO PERIODONTAL'
      },
      {
        code: 2738,
        name: 'RASPAGEM CORONO-RADICULAR'
      },
      {
        code: 2740,
        name: 'CORREÇÃO DA FÍSTULA ORO-NASAL / ORO SINUSAL'
      },
      {
        code: 2741,
        name: 'ESCISÃO DE CÁLCULO DE GLÂNDULA SALIVAR.'
      },
      {
        code: 2742,
        name: 'EXERESE DO CISTO ODONTOGÊNICO E NÃO-ODONTOGÊNICO'
      },
      {
        code: 2743,
        name: 'TRATAMENTO CIRÚRGICO DE FÍSTULA INTRA/EXTRA ORAL.'
      },
      {
        code: 2748,
        name: 'TRATAMENTO CIRÚRGICO PARA TRACIONAMENTO DENTAL'
      },
      {
        code: 2749,
        name: 'REMOÇÃO DE TORUS E EXOSTOSE'
      },
      {
        code: 2750,
        name: 'REMOÇÃO DE DENTE INCLUSO (RETIDO).'
      },
      {
        code: 2751,
        name: 'MARSUPIALIZAÇÃO DE CISTOS E PSEUDOCISTOS.'
      },
      {
        code: 2752,
        name: 'EXODONTIA MÚLTIPLA COM ALVEOLOPLASTIA.'
      },
      {
        code: 2753,
        name: 'EXODONTIA DE DENTE PERMANENTE'
      },
      {
        code: 2755,
        name: 'EXCISÃO EM CUNHA DO LÁBIO'
      },
      {
        code: 2756,
        name: 'EXCISÃO E SUTURA DA LESÃO DA BOCA'
      },
      {
        code: 2757,
        name: 'EXCISÃO DE RÂNULA'
      },
      {
        code: 2758,
        name: 'CURETAGEM PERIAPICAL'
      },
      {
        code: 2759,
        name: 'CORREÇÃO DE TUBEROSIDADE DO MAXILAR.'
      },
      {
        code: 2760,
        name: 'CORREÇÃO DE IRREGULARIDADES DO REBORDO ALVEOLAR'
      },
      {
        code: 2761,
        name: 'CORREÇÃO DE BRIDAS MUSCULARES'
      },
      {
        code: 2762,
        name: 'APROFUNDAMENTO DO VESTÍBULO ORAL'
      },
      {
        code: 2763,
        name: 'APICETOMIA COM OU SEM OBTURAÇÃO RETRÓGRADA.'
      },
      {
        code: 2764,
        name: 'SINUSOSTOMIA TRANSMAXILAR'
      },
      {
        code: 2765,
        name: 'RETIRADA DO CORPO ESTRANHO DOS OSSOS DA FACE'
      },
      {
        code: 2766,
        name: 'RECONSTRUÇÃO PARCIAL DO LÁBIO TRAUMATIZADO'
      },
      {
        code: 2767,
        name: 'RETIRADA DE MATERIAL DE SÍNTESE ÓSSEA/DENTÁRIA'
      },
      {
        code: 2768,
        name: 'OSTEOTOMIA DA FRATURAS ALVÉOLOS-DENTÁRIAS'
      },
      {
        code: 2770,
        name: 'COROA DE AÇO E POLICARBOXILATO'
      },
      {
        code: 2771,
        name: 'MANTENEDOR DE ESPAÇO.'
      },
      {
        code: 2772,
        name: 'PRÓTESE CORONÁRIA/INTRA-RADICULARE FIXA'
      },
      {
        code: 2773,
        name: 'PRÓTESE PARCIAL REMOVÍVEL MAXILAR'
      },
      {
        code: 2774,
        name: 'PRÓTESE PARCIAL REMOVÍVEL MANDIBULAR'
      },
      {
        code: 2775,
        name: 'PRÓTESE TOTAL MANDIBULAR (DENTADURA INFERIOR)'
      },
      {
        code: 2776,
        name: 'PRÓTESE TOTAL MAXILAR (DENTADURA SUPERIOR).'
      },
      {
        code: 2777,
        name: 'PLACA OCLUSAL'
      },
      {
        code: 2778,
        name: 'RESTAURAÇÃO DE DENTE DECÍDUO'
      },
      {
        code: 2779,
        name: 'RESTAURAÇÃO DE DENTE PERMANENTE ANTERIOR'
      },
      {
        code: 2780,
        name: 'RESTAURAÇÃO DE DENTE PERMANENTE POSTERIOR'
      },
      {
        code: 2781,
        name: 'CONSULTA DE PROFISSIONAIS DE NÍVEL SUPERIOR NA ATENÇÃO ESPECIALIZADA (EXCETO MÉDICO).'
      },
      {
        code: 2782,
        name: 'TRATAMENTO ODONTOLÓGICO GLOBAL PARA DEFICIÊNCIAS SOB ANESTESIA GERAL.'
      },
      {
        code: 2784,
        name: 'SERVIÇO DE ATENDIMENTO MÉDICO ESTATÍSTICO- (SAME/INTERNAÇÃO)'
      },
      {
        code: 2785,
        name: 'AUTORIZAÇÃO PARA IMPRESSÃO DE DOCUMENTOS FISCAIS - AIDF'
      },
      {
        code: 2788,
        name: 'AMBULATÓRIO DE MUCOPOLISSACARIDOSE'
      },
      {
        code: 2789,
        name: 'AMBULATÓRIO DE OSTEOGÊNESE IMPERFEITA'
      },
      {
        code: 2790,
        name: 'EXCLUSÃO DE RESTRIÇÃO DO IPVA'
      },
      {
        code: 2791,
        name: 'INSTALAÇÃO DE APARELHO ORTODÔNTICO/ORTOPÉDICO FIXO.'
      },
      {
        code: 2792,
        name: 'APARELHO ORTOPÉDICO E ORTODÔNTICO REMOVÍVEL'
      },
      {
        code: 2797,
        name: 'EXAME DE COLANGIOPANCREATOGRAFIA RETRÓGRADA ENDOSCÓPICA (CPRE OU CPER)'
      },
      {
        code: 2798,
        name: 'EXAME DE COLONOSCOPIA'
      },
      {
        code: 2799,
        name: 'CONSULTORIA EM PROPRIEDADE INDUSTRIAL - NÍVEL 1'
      },
      {
        code: 2800,
        name: 'CONSULTORIA EM PROPRIEDADE INDUSTRIAL - NÍVEL 2'
      },
      {
        code: 2801,
        name: 'CONSULTORIA EM PROPRIEDADE INDUSTRIAL - NÍVEL 3'
      },
      {
        code: 2802,
        name: 'EXAME DE ENDOSCOPIA DIGESTIVA'
      },
      {
        code: 2803,
        name: 'CONSULTORIA EM PROPRIEDADE INDUSTRIAL NÍVEL 4'
      },
      {
        code: 2804,
        name: 'ALEITAMENTO MATERNO'
      },
      {
        code: 2805,
        name: 'ATENDIMENTO MÉDICO PARA PORTADORES DE DOENÇAS SEXUALMENTE TRANSMISSÍVEIS (DST) DO HSJ'
      },
      {
        code: 2806,
        name: 'ATENDIMENTO MÉDICO AOS PORTADORES DE HEPATITES VIRAIS DO HSJ'
      },
      {
        code: 2807,
        name: 'ATENDIMENTO MÉDICO PARA EGRESSOS DE INTERNAÇÕES NO HSJ'
      },
      {
        code: 2808,
        name: 'ATENDIMENTO MÉDICO A PORTADORES DE LEISHMANIOSE CUTÂNEA E LEISHMANIOSE VISCERAL (CALAZAR) DO HSJ'
      },
      {
        code: 2809,
        name: 'ANÁLISES HIDROLÓGICAS E AMBIENTAIS DE AÇUDES VISANDO O ABASTECIMENTO DE ÁGUA BRUTA A SEDES MUNICIPAIS'
      },
      {
        code: 2814,
        name: 'DOSAGEM DE BILIRRUBINAS TOTAIS E FRAÇÕES'
      },
      {
        code: 2815,
        name: 'DOSAGEM DE COLESTEROL HDL (MÉTODO ENZIMÁTICO)'
      },
      {
        code: 2816,
        name: 'DOSAGEM DE COLESTEROL LDL.'
      },
      {
        code: 2817,
        name: 'DOSAGEM DE COLESTEROL TOTAL'
      },
      {
        code: 2818,
        name: 'DOSAGEM DE CREATININA.'
      },
      {
        code: 2819,
        name: 'DOSAGEM DE FERRO SÉRICO.'
      },
      {
        code: 2820,
        name: 'DOSAGEM DE FOSFATASE ALCALINA.'
      },
      {
        code: 2821,
        name: 'DOSAGEM DE GAMA-GT.'
      },
      {
        code: 2822,
        name: 'DOSAGEM DE GLICOSE.'
      },
      {
        code: 2823,
        name: 'DOSAGEM DE GLICOSE PÓS PRANDIAL.'
      },
      {
        code: 2824,
        name: 'DOSAGEM DE PROTEÍNAS TOTAIS E FRAÇÕES.'
      },
      {
        code: 2825,
        name: 'DOSAGEM DE TGO - TRANSAMINASE GLUTAMICO-OXALACETICA.'
      },
      {
        code: 2826,
        name: 'DOSAGEM DE TGP - ALANINA AMINOTRANSFERASE.'
      },
      {
        code: 2827,
        name: 'DOSAGEM DE TRIGLICERÍDEOS.'
      },
      {
        code: 2828,
        name: 'DOSAGEM DE UREIA'
      },
      {
        code: 2829,
        name: 'HEMOGRAMA COMPLETO'
      },
      {
        code: 2830,
        name: 'CONTAGEM PLAQUETAS'
      },
      {
        code: 2831,
        name: 'DETERMINAÇÃO DE FATOR REUMATOIDE - LATEX'
      },
      {
        code: 2832,
        name: 'DOSAGEM DE PCR - PROTEÍNA C REATIVA'
      },
      {
        code: 2833,
        name: 'ASO - PESQUISA DE ANTICORPOS ANTIESTREPTOLISINA O (ASLO)'
      },
      {
        code: 2834,
        name: 'PESQUISA DE ANTICORPOS DE HIV (VITROS ECI)'
      },
      {
        code: 2835,
        name: 'HEPATIBE B HBSAG'
      },
      {
        code: 2836,
        name: 'HEPATITE B - HBC TOTAL'
      },
      {
        code: 2837,
        name: 'HEPATITE B - HBc IgM'
      },
      {
        code: 2838,
        name: 'ATENDIMENTO DE URGÊNCIA/EMERGÊNCIA 24 HORAS'
      },
      {
        code: 2839,
        name: 'SERVIÇO DE VERIFICAÇÃO DE ÓBITOS'
      },
      {
        code: 2840,
        name: 'SUPORTE DE INFORMÁTICA E MANUTENÇÃO DA INFRAESTRUTURA DA TECNOLOGIA DA INFORMAÇÃO E COMUNICAÇÃO'
      },
      {
        code: 2841,
        name: 'AQUISIÇÃO DE BENS/SERVIÇOS PARA SEGURANÇA PÚBLICA'
      },
      {
        code: 2842,
        name: 'DESENVOLVIMENTO E MANUTENÇÃO DE SISTEMAS DE TECNOLOGIA DA INFORMAÇÃO'
      },
      {
        code: 2843,
        name: 'PROGRAMA TESOUROS VIVOS PARA DIPLOMAÇÃO DE SESSENTA MESTRES DACULTURA POPULAR TRADICIONAL DO CEARÁ.'
      },
      {
        code: 2844,
        name: 'AQUISIÇÃO, CONTROLE E DISPENSAÇÃO DE MEDICAMENTOS E MANIPULAÇÃO DE NUTRIÇÃO PARENTERAL.'
      },
      {
        code: 2845,
        name: 'OUVIDORIA'
      },
      {
        code: 2846,
        name: 'LABORATÓRIO DE EXAMES DE PATOLOGIA CLINICA'
      },
      {
        code: 2847,
        name: 'EXAME DE ENEMA OPACO'
      },
      {
        code: 2848,
        name: 'EXAME DE ESOFOGOGRAMA'
      },
      {
        code: 2849,
        name: 'EXAME DE ESPIROMETRIA'
      },
      {
        code: 2850,
        name: 'EXAME DE HOLTER 24 HORAS'
      },
      {
        code: 2851,
        name: 'EXAME DE MAPA 24 HORAS (MONITORIZAÇÃO AMBULATORIAL DA PRESSÃO ARTERIAL POR 24 HORAS)'
      },
      {
        code: 2852,
        name: 'EXAME DE RADIOLOGIA'
      },
      {
        code: 2853,
        name: 'EXAME DE TOMOGRAFIA COM CONTRASTE'
      },
      {
        code: 2854,
        name: 'EXAME DE TOMOGRAFIA SEM CONTRASTE'
      },
      {
        code: 2855,
        name: 'EXAME DE TRANSITO INTESTINAL'
      },
      {
        code: 2856,
        name: 'ULTRASSONOGRAFIA (ABDOMEM SUPERIOR E INFERIOR, CERVICAL, RENAL, PRÓSTATA, TRANSVAGINAL, OBSTÉTRICO E MAMA).'
      },
      {
        code: 2857,
        name: 'EXAME DE URODINÂMICA'
      },
      {
        code: 2858,
        name: 'EXAME DE UROGRAFIA ESCRETORA'
      },
      {
        code: 2859,
        name: 'SOLICITAÇÃO DE TOMBAMENTO DE EDIFICAÇÕES HISTÓRICAS.'
      },
      {
        code: 2860,
        name: 'PESQUISA SOBRE BENS CULTURAIS ENVOLVENDO O PATRIMÔNIO MATERIAL E IMATERIAL.'
      },
      {
        code: 2861,
        name: 'ASSESSORIA TÉCNICA NA ÁREA DO PATRIMÔNIO HISTÓRICO E CULTURAL.'
      },
      {
        code: 2862,
        name: 'REALIZAÇÃO DE BIÓPSIA DE GÂNGLIO LINFÁTICO PARA PACIENTES ATENDIDOS NA EMERGÊNCIA, NO AMBULATÓRIO OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2863,
        name: 'REALIZAÇÃO DE BIÓPSIA DE PELE PARA PACIENTES ATENDIDOS NA EMERGÊNCIA, NO AMBULATÓRIO OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2864,
        name: 'REALIZAÇÃO DE DIÁLISE PARA PACIENTES INTERNADOS NO HSJ.'
      },
      {
        code: 2866,
        name: 'REALIZAÇÃO DE LIMPEZA CIRÚRGICA DE PELE OU MUCOSAS EM PACIENTES ATENDIDOS NA EMERGÊNCIA OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2867,
        name: 'REALIZAÇÃO DE MIELOGRAMA PARA PACIENTES ATENDIDOS NA EMERGÊNCIA, NO AMBULATÓRIO OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2868,
        name: 'REALIZAÇÃO DE PARACENTESE PARA PACIENTES ATENDIDOS NA EMERGÊNCIA, NO AMBULATÓRIO OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2869,
        name: 'REALIZAÇÃO DE PUNÇÃO ARTICULAR PARA PACIENTES ATENDIDOS NA EMERGÊNCIA, NO AMBULATÓRIO OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2870,
        name: 'REALIZAÇÃO DE PUNÇÃO DE VEIA SUBCLÁVIA OU JUGULAR PARA PACIENTES ATENDIDOS NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2871,
        name: 'REALIZAÇÃO DE PUNÇÃO LOMBAR PARA PACIENTES ATENDIDOS NA EMERGÊNCIA, NO AMBULATÓRIO OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2872,
        name: 'REALIZAÇÃO DE PUNÇÃO PLEURAL PARA PACIENTES ATENDIDOS NA EMERGÊNCIA, NO AMBULATÓRIO OU NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2873,
        name: 'REALIZAÇÃO DE TRAQUEOSTOMIA EM PACIENTES ATENDIDOS NAS UNIDADES DE INTERNAÇÃO DO HSJ.'
      },
      {
        code: 2874,
        name: 'EXAMES DE LABORATÓRIO'
      },
      {
        code: 2875,
        name: 'NOTA FISCAL AVULSA'
      },
      {
        code: 2876,
        name: 'EXAME DE CORPO DE DELITO INDIRETO'
      },
      {
        code: 2877,
        name: 'EXAME PARA CONSTATAÇÃO DE CRIME SEXUAL'
      },
      {
        code: 2881,
        name: 'EXAME PARA ESTIMATIVA DE IDADE'
      },
      {
        code: 2885,
        name: 'ATENDIMENTO DE URGÊNCIA E EMERGÊNCIA EM GINECOLOGIA E OBSTETRICIA'
      },
      {
        code: 2886,
        name: 'IMPLANTAÇÃO, ORIENTAÇÃO E ASSESSORIA PARA ATENDIMENTO PEDAGÓGICO ESPECIALIZADO.'
      },
      {
        code: 2887,
        name: 'SECRETARIA EXECUTIVA DO CONSELHO ESTADUAL DE PATRIMÔNIO HISTÓRICO CULTURAL - COEPA'
      },
      {
        code: 2888,
        name: 'DETECÇÃO DE COLIFORMES TOTAIS E FECAIS.'
      },
      {
        code: 2889,
        name: 'DETERMINAÇÃO DO TEOR DE FLÚOR EM ÁGUA'
      },
      {
        code: 2890,
        name: 'DETERMINAÇÃO DA TURBIDEZ DA ÁGUA'
      },
      {
        code: 2891,
        name: 'CERTIDÃO POSITIVA DE DÉBITOS.'
      },
      {
        code: 2892,
        name: 'CERTIDÃO NEGATIVA DE DÉBITO.'
      },
      {
        code: 2893,
        name: 'CULTURA PARA MYCOBACTERIUM TUBERCULOSIS'
      },
      {
        code: 2894,
        name: 'SOROLOGIA PARA DENGUE'
      },
      {
        code: 2895,
        name: 'SOROLOGIA PARA RUBÉOLA IgM'
      },
      {
        code: 2896,
        name: 'SOROLOGIA PARA RUBÉOLA IgG'
      },
      {
        code: 2897,
        name: 'SOROLOGIA PARA HIV (ENSAIO IMUNOLÓGICO QUIMIOLUMINESCENTE)'
      },
      {
        code: 2898,
        name: 'SOROLOGIA PARA HEPATITE B – ANTI - HBC IGM'
      },
      {
        code: 2899,
        name: 'SOROLOGIA PARA HEPATITE B -HBsAg'
      },
      {
        code: 2900,
        name: 'SOROLOGIA PARA HEPATITE B - ANTI-HBC TOTAL'
      },
      {
        code: 2901,
        name: 'SOROLOGIA PARA HEPATITE C - ANTI-HCV'
      },
      {
        code: 2902,
        name: 'SOROLOGIA PARA SÍFILIS- VDRL'
      },
      {
        code: 2903,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS - CMV IGM'
      },
      {
        code: 2904,
        name: 'SOROLOGIA PARA CITOMEGALOVÍRUS IgG.'
      },
      {
        code: 2905,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IgM'
      },
      {
        code: 2906,
        name: 'SOROLOGIA PARA TOXOPLASMOSE IGG'
      },
      {
        code: 2907,
        name: 'SOLICITAÇÃO DE LIMITE FINANCEIRO AO COGERF'
      },
      {
        code: 2908,
        name: 'SOLICITAÇÃO DE CRÉDITOS ADICIONAIS E MOVIMENTAÇÕES ORÇAMENTÁRIAS'
      },
      {
        code: 2909,
        name: 'PREENCHIMENTO FACIAL COM METACRILATO PARA PACIENTES PORTADORES DE HIV/AIDS'
      },
      {
        code: 2910,
        name: 'ATENDIMENTO DO NUTRICIONISTA AOS PACIENTES DO AMBULATÓRIO DO HSJ'
      },
      {
        code: 2911,
        name: 'ATENDIMENTO DE SERVIÇO SOCIAL AOS PACIENTES DO AMBULATÓRIO DO HSJ'
      },
      {
        code: 2912,
        name: 'ATENDIMENTO DE ENFERMAGEM AOS PACIENTES DO AMBULATÓRIO DO HSJ'
      },
      {
        code: 2914,
        name: 'EMISSÃO DE 2ª VIA DE FATURA'
      },
      {
        code: 2915,
        name: 'CADASTRAMENTO DE USUÁRIO SUS PARA RECEBIMENTO DE MEDICAMENTOS ANTIRRETROVIRAIS NO HSJ'
      },
      {
        code: 2916,
        name: 'PARCELAMENTO DO DÉBITO NA DÍVIDA ATIVA'
      },
      {
        code: 2958,
        name: 'RELIGAÇÃO DE ÁGUA'
      },
      {
        code: 2959,
        name: 'LIGAÇÃO DE ÁGUA COM INSTALAÇÃO DE HIDRÔMETRO PARA LIGAÇÃO SUPRIMIDA'
      },
      {
        code: 2960,
        name: 'LIGAÇÃO DE ÁGUA COM INSTALAÇÃO DE HIDRÔMETRO'
      },
      {
        code: 2961,
        name: 'RELIGAÇÃO URGENTE'
      },
      {
        code: 2962,
        name: 'VERIFICAÇÃO DE FALTA DE ÁGUA'
      },
      {
        code: 2965,
        name: 'PROJETOS CULTURAIS ATRAVÉS DA DEMANDA ESPONTÂNEA DO FUNDO ESTADUAL DA CULTURA – FEC.'
      },
      {
        code: 2966,
        name: 'ATENDIMENTO EM REGIME DE HOSPITAL DIA PARA PACIENTES ACOMPANHADOS NO HSJ'
      },
      {
        code: 2967,
        name: 'EXAMES DE RAIOS-X E ULTRASONOGRAFIA'
      },
      {
        code: 2968,
        name: 'SUBSTITUIÇÃO DE REGISTRO GERAL'
      },
      {
        code: 2969,
        name: 'CERTIDÃO NEGATIVA'
      },
      {
        code: 2972,
        name: 'DESLOCAMENTO DE HIDRÔMETRO / KIT CAVALETE'
      },
      {
        code: 2973,
        name: 'CONSERTO DE VAZAMENTO NA LIGAÇÃO PREDIAL'
      },
      {
        code: 2974,
        name: 'CONSERTO DE VAZAMENTO NA REDE'
      },
      {
        code: 2975,
        name: 'DESOBSTRUÇÃO DE REDE DE ESGOTO'
      },
      {
        code: 2976,
        name: 'CONSERTO DE VAZAMENTO NO KIT CAVALETE'
      },
      {
        code: 2978,
        name: 'RECUPERAÇÃO DE PAVIMENTO'
      },
      {
        code: 2980,
        name: 'RECUPERAÇÃO DE PASSEIO'
      },
      {
        code: 2981,
        name: 'COLETA E ANÁLISE DE ÁGUA'
      },
      {
        code: 2982,
        name: 'COLETA E ANÁLISE DE ESGOTO'
      },
      {
        code: 2983,
        name: 'EXPEDIÇÃO DE DECLARAÇÃO DE ÓBITO'
      },
      {
        code: 2984,
        name: 'RESPONSÁVEL PELO POLICIAMENTO MILITAR AMBIENTAL EM TODO O ESTADO DO CEARÁ.'
      },
      {
        code: 2985,
        name: 'ORDEM DE POLICIAMENTO OSTENSIVO'
      },
      {
        code: 2987,
        name: 'PLANEJAMENTO ADMINISTRATIVO E OPERACIONAL DO POLICIAMENTO OSTENSIVO GERAL'
      },
      {
        code: 2988,
        name: 'CAPACITAÇÃO POLICIAL PARA AGENTES APLICADORES DA LEI'
      },
      {
        code: 2989,
        name: 'POLICIAMENTO VOLTADO PARA O TURISMO'
      },
      {
        code: 2992,
        name: 'DOAÇÃO DE SANGUE'
      },
      {
        code: 2993,
        name: 'VERIFICAÇÃO DE CONSUMO MEDIDO.'
      },
      {
        code: 2994,
        name: 'CADASTRAMENTO DE IMÓVEL'
      },
      {
        code: 2995,
        name: 'PEDIDO DE CÁLCULO DO ITCD.'
      },
      {
        code: 2996,
        name: 'EXCLUSÃO DE SÓCIO INSCRITO NO CADINE.'
      },
      {
        code: 2997,
        name: 'EXCLUSÃO DE INSCRIÇÃO NA DÍVIDA ATIVA ESTADUAL.'
      },
      {
        code: 2998,
        name: 'VISITAS ORIENTADAS ÀS EXPOSIÇÕES'
      },
      {
        code: 2999,
        name: 'VERIFICAÇÃO DE HIDRÔMETRO'
      },
      {
        code: 3000,
        name: 'DESOBSTRUÇÃO DA LIGAÇÃO DE ESGOTO'
      },
      {
        code: 3001,
        name: 'VERIFICAÇÃO DE BAIXA PRESSÃO'
      },
      {
        code: 3002,
        name: 'RECOLOCAÇÃO DA TAMPA DA CAIXA DE LIGAÇÃO DE ESGOTO.'
      },
      {
        code: 3004,
        name: 'RECOLOCAÇÃO DO TAMPÃO DO POÇO DE VISITA'
      },
      {
        code: 3005,
        name: 'SUBSTITUIÇÃO DE LIGAÇÃO DE ÁGUA E DE HIDRÔMETRO COM ALTERAÇÃO DE DIÂMETRO'
      },
      {
        code: 3014,
        name: 'EMISSÃO DE CERTIDÕES DE ACIDENTES DE TRÂNSITO.'
      },
      {
        code: 3019,
        name: 'RECUPERAÇÃO DA CAIXA DE INSPEÇÃO DANIFICADA'
      },
      {
        code: 3023,
        name: 'SERVIÇO DE INSTALAÇÃO DE PROCESSO'
      },
      {
        code: 3026,
        name: 'SERVIÇO DE INSTRUÇÃO DE PROCESSO ADMINISTRATIVO DISCIPLINAR'
      },
      {
        code: 3027,
        name: 'SERVIÇO DE ACOMPANHAMENTO DE PARECERES EM PROCESSOS ADMINISTRATIVOS.'
      },
      {
        code: 3029,
        name: 'SERVIÇO DE ACOMPANHAMENTO DE AÇÕES DA CAPITAL E INTERIOR: ALVARÁS, ARROLAMENTOS, INVENTÁRIOS E TESTAMENTOS.'
      },
      {
        code: 3030,
        name: 'SERVIÇO DE AFERIÇÃO DO CONTROLE DE LEGALIDADE DOS PROCESSOS ADMINISTRATIVOS REFERENTES A DÉBITOS,TRIBUTÁRIOS E NÃO TRIBUTÁRIOS.'
      },
      {
        code: 3031,
        name: 'SERVIÇO DE AJUIZAMENTO DE EXECUÇÃO JUDICIAL DE DÉBITOS DE ORIGEM,TRIBUTÁRIA E NÃO TRIBUTÁRIA.'
      },
      {
        code: 3032,
        name: 'SERVIÇO DE AJUIZAMENTO DE PROCESSO DE EXECUÇÃO FISCAL RELATIVO A DÉBITOS DE ORIGEM TRIBUTÁRIA E. NÃO TRIBUTÁRIA'
      },
      {
        code: 3033,
        name: 'SERVIÇO DE ATUAÇÃO EM PROCESSOS JUDICIAIS QUE TENHAM POR OBJETO O QUESTIONAMENTO DE INSCRIÇÃO NOS CADASTROS DOS SERVIÇOS DE PROTEÇÃO AO CRÉDI'
      },
      {
        code: 3034,
        name: 'SERVIÇO DE COBRANÇA EXTRAJUDICIAL DA DÍVIDA ATIVA DO ESTADO DO CEARÁ.'
      },
      {
        code: 3035,
        name: 'SERVIÇO DE EMISSÃO DE PARECERES.'
      },
      {
        code: 3036,
        name: 'SERVIÇO DE INSCRIÇÃO DE DEVEDORES EM CADASTROS DE RESTRIÇÃO AO CRÉDITO.'
      },
      {
        code: 3037,
        name: 'ECO TRANSESOFÁGICO'
      },
      {
        code: 3038,
        name: 'ECO STRESS'
      },
      {
        code: 3039,
        name: 'ELETROCARDIOGRAMA (ECG)'
      },
      {
        code: 3040,
        name: 'CERTIFICADO DE RASTREAMENTO PARA TRANSPORTE INTERMUNICIPAL - CRTI'
      },
      {
        code: 3045,
        name: 'SUPRESSÃO DE RAMAL PREDIAL'
      },
      {
        code: 3046,
        name: 'CORTE SOLICITADO'
      },
      {
        code: 3047,
        name: 'SUSPENSÃO DE FATURAMENTO DE ESGOTO.'
      },
      {
        code: 3048,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS'
      },
      {
        code: 3049,
        name: 'REATIVAÇÃO DO FATURAMENTO DE ESGOTO'
      },
      {
        code: 3050,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA COMUM - CODECE'
      },
      {
        code: 3051,
        name: 'TRANSFERÊNCIA DE LIGAÇÃO DE ÁGUA'
      },
      {
        code: 3052,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA TRABALHISTA - CODECE'
      },
      {
        code: 3053,
        name: 'SERVIÇO DE ATUALIZAÇÃO DE VANTAGEM PESSOAL'
      },
      {
        code: 3054,
        name: 'SERVIÇO DE CÁLCULO DE ABONO COMPENSATÓRIO'
      },
      {
        code: 3055,
        name: 'SERVIÇO DE CÁLCULO DA VANTAGEM PESSOAL NOMINALMENTE IDENTIFICADA - VPNI'
      },
      {
        code: 3056,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA COMUM - DER'
      },
      {
        code: 3057,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA TRABALHISTA - DER'
      },
      {
        code: 3058,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA COMUM - FUNTELC.'
      },
      {
        code: 3060,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA TRABALHISTA - FUNTELC'
      },
      {
        code: 3061,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA COMUM - PROCADIN'
      },
      {
        code: 3062,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA FISCAL'
      },
      {
        code: 3063,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA COMUM'
      },
      {
        code: 3064,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA TRABALHISTA'
      },
      {
        code: 3065,
        name: 'SERVIÇO DE ANÁLISE E EXECUÇÃO DE CÁLCULOS JUDICIAIS PROCURADORIA JUDICIAL JUSTIÇA COMUM - PROPAMA'
      },
      {
        code: 3066,
        name: 'SERVIÇO DE AVALIAÇÃO DE DESEMPENHO.'
      },
      {
        code: 3067,
        name: 'SERVIÇO DE ACOMPANHAMENTO DO EXERCÍCIO DO PROCURADOR DO ESTADO DURANTE O ESTÁGIO PROBATÓRIO.'
      },
      {
        code: 3068,
        name: 'SERVIÇO DE CORREIÇÕES'
      },
      {
        code: 3069,
        name: 'SERVIÇO DE PROPOSIÇÃO DE SINDICÂNCIAS E PROCESSOS ADMINISTRATIVOS DISCIPLINARES.'
      },
      {
        code: 3070,
        name: 'SERVIÇO DE PROPOSIÇÃO DE MEDIDAS DE APRIMORAMENTO DOS SERVIÇOS DA PGE.'
      },
      {
        code: 3071,
        name: 'MONITORAMENTO DO RISCO SANITÁRIO'
      },
      {
        code: 3079,
        name: 'SOLICITAÇÃO DE MEDICAMENTO VIA JUDICIAL OU VIA PROCESSO ADMINISTRATIVO'
      },
      {
        code: 3080,
        name: 'PAEFI - PROTEÇÃO E ATENDIMENTO ESPECIALIZADO A FAMÍLIAS E INDIVÍDUOS'
      },
      {
        code: 3087,
        name: 'AÇÃO DE ALIMENTOS GRAVÍDICOS'
      },
      {
        code: 3088,
        name: 'AÇÃO DE REGULAMENTAÇÃO DE GUARDA E VISITAS'
      },
      {
        code: 3089,
        name: 'AÇÃO DE INDENIZAÇÃO POR DANO MATERIAL OU MORAL'
      },
      {
        code: 3090,
        name: 'AÇÃO DE INTERDIÇÃO'
      },
      {
        code: 3091,
        name: 'AÇÃO DE INVESTIGAÇÃO DE PATERNIDADE'
      },
      {
        code: 3092,
        name: 'AÇÃO DE MODIFICAÇÃO DE GUARDA'
      },
      {
        code: 3093,
        name: 'DECLARATÓRIA DE RECONHECIMENTO E DISSOLUÇÃO DE UNIÃO ESTÁVEL'
      },
      {
        code: 3094,
        name: 'REVISIONAL DE ALIMENTOS'
      },
      {
        code: 3096,
        name: 'ULTRA-SONOGRAFIA ABDOMINAL'
      },
      {
        code: 3098,
        name: 'EMISSÃO DE PARECER TÉCNICO DE PROJETOS DE TILAPICULTURA EM TANQUES-REDE.'
      },
      {
        code: 3099,
        name: 'ULTRA-SONOGRAFIA DE TÓRAX'
      },
      {
        code: 3100,
        name: 'SERVIÇO DE SOLICITAÇÃO DE DIÁRIAS'
      },
      {
        code: 3101,
        name: 'ULTRA-SONOGRAFIA DE TIREÓIDE.'
      },
      {
        code: 3102,
        name: 'TOMOGRAFIA DE CRÂNIO COMPUTADORIZADA'
      },
      {
        code: 3103,
        name: 'SERVIÇO DE FORNECIMENTO DE DECLARAÇÃO'
      },
      {
        code: 3104,
        name: 'SERVIÇOS DE FORNECIMENTO DE CERTIDÕES'
      },
      {
        code: 3105,
        name: 'SERVIÇO DE EXPEDIÇÃO DE OFÍCIO'
      },
      {
        code: 3106,
        name: 'SERVIÇO DE ELABORAÇÃO DE FOLHA DE PAGAMENTO/PLANILHA ELETRÔNICA.'
      },
      {
        code: 3107,
        name: 'SERVIÇO DE ELABORAÇÃO DE FOLHA DE PAGAMENTO/DIÁRIO OFICIAL'
      },
      {
        code: 3108,
        name: 'SERVIÇO DE ELABORÇÃO DE FOLHA DE PAGAMENTO/SISTEMA DE FOLHA DE PAGAMENTO.'
      },
      {
        code: 3109,
        name: 'SERVIÇO DE ATUALIZAÇÃO DE FICHA FUNCIONAL'
      },
      {
        code: 3110,
        name: 'SERVIÇO DE RECOLHIMENTO REGULAR DO FGTS E INFORMAÇÕES À PREVIDÊNCIA SOCIAL.'
      },
      {
        code: 3111,
        name: 'ULTRA-SONOGRAFIA PÉLVICA'
      },
      {
        code: 3112,
        name: 'TOMOGRAFIA COMPUTADORIZADA DE TÓRAX'
      },
      {
        code: 3113,
        name: 'FARMÁCIA AMBULATORIAL'
      },
      {
        code: 3114,
        name: 'SERVIÇO DE CONTROLE DE FREQUÊNCIAS'
      },
      {
        code: 3115,
        name: 'SERVIÇO DE ESCALAÇÃO DE FÉRIAS'
      },
      {
        code: 3116,
        name: 'SERVIÇO DE CONCESSÃO DE AUXÍLIO ALIMENTAÇÃO - SERVIDORES'
      },
      {
        code: 3117,
        name: 'SERVIÇO DE CONCESSÃO DE VALE TRANSPORTE'
      },
      {
        code: 3118,
        name: 'SERVIÇO DE INSTRUÇÃO DO PROCESSO DE ABONO DE PERMANÊNCIA'
      },
      {
        code: 3119,
        name: 'SERVIÇO DE INSTRUÇÃO DO PROCESSO DE APOSENTADORIA'
      },
      {
        code: 3120,
        name: 'SERVIÇO DE NOMEAÇÃO, EXONERAÇÃO, DESIGNAÇÃO DE CARGOS EM COMISSÃO'
      },
      {
        code: 3121,
        name: 'SERVIÇO DE EMISSÃO DE CERTIDÃO DE TEMPO DE CONTRIBUIÇÃO'
      },
      {
        code: 3122,
        name: 'SERVIÇO DE AVERBAÇÃO DE CERTIDÃO DE TEMPO DE CONTRIBUIÇÃO'
      },
      {
        code: 3123,
        name: 'SELEÇÃO DE ESTAGIÁRIOS PARA ATUAR NA PGE'
      },
      {
        code: 3125,
        name: 'SERVIÇO DE REGISTRO DE ATENDIMENTO AOS CIDADÃOS QUE PROCURAM A OUVIDORIA'
      },
      {
        code: 3126,
        name: 'SERVIÇO DE INSTALAÇÃO DE PROCESSO'
      },
      {
        code: 3127,
        name: 'RESOLUÇÃO DE CONFLITOS ENTRE A ADMINISTRAÇÃO DIRETA E INDIRETA.'
      },
      {
        code: 3128,
        name: 'OUVIDORIA'
      },
      {
        code: 3129,
        name: 'PAD- PROGRAMA DE ATENDIMENTO DOMICILIAR'
      },
      {
        code: 3130,
        name: 'EXAMES PARASITOLÓGICOS:'
      },
      {
        code: 3131,
        name: 'EXAMES HEMATOLÓGICOS: TEMPO E ATIVIDADE PROTROMBINICA,CONTAGEM LEUCÓCITOS,'
      },
      {
        code: 3132,
        name: 'CIRURGIAS CARDÍACAS'
      },
      {
        code: 3134,
        name: 'CIRURGIA VASCULAR'
      },
      {
        code: 3136,
        name: 'EXAMES BIOQUÍMICOS: ACIDO FÓLICO ACIDO LÁTICO (LACTATO) ACIDO URICO SÉRICO ACIDO URICO URINÁRIO ALANINA AMINOTRANSFERASE (ALT,TGP) AMILASE SÉRICA AMILASE URINÁRIA BILIRRUBINAS CK - MB CÁLCIO IONIZADO CÁLCIO SÉRICO CÁLCIO URINÁRIO CAPACIDADE LATENTE FIXAÇÃO FERRO CLEARANCE DE CREATININA CLORO CK - MB COLESTEROL HDL, LDL, TOTAL, VLDL CREATININA SÉRICA CREATINA KINASE (CPK-NAC) CREATININA URINÁRIA CURVA GLICÊMICA FERRITINA FERRO FOSFATASE ALCALINA SÉRICA FÓSFORO SÉRICO FÓSFORO URINÁRIO GAMA GT - GAMA GLUTAMILTRANSFERASE GLICEMIA GLICEMIA PÓS-PRANDIAL GLICOSE PÓS-DEXTROSE GLICOSURIA HEMOGLOBINA GLICOSILADA LDH-DESIDROGENASE LÁTICA LÍPASE LIPÍDEOS TOTAIS LIPIDOGRAMA MAGNÉSIO SÉRICO MAGNESIO URINÁRIO MICROALBUMINÚRIA POTÁSSIO SÉRICO POTÁSSIO URINÁRIO PROTEÍNAS TOTAIS E FRAÇÕES SÓDIO SÉRICO SÓDIO URINÁRIO TRANSFERRINA TRIGLICERÍDEOS URÉIA SÉRICA URÉIA URINÁRIA VITAMINA B12.'
      },
      {
        code: 3145,
        name: 'REALIZAÇÃO DE ENDOSCOPIA DIGESTIVA ALTA E BAIXA PARA PACIENTES ACOMPANHADOS NO HSJ OU REFERIDOS POR MÉDICOS DO HSJ'
      },
      {
        code: 3146,
        name: 'ATENDIMENTO DA TERAPIA OCUPACIONAL AOS PACIENTES INTERNADOS NO HSJ'
      },
      {
        code: 3161,
        name: 'ENSAIO DE ÍNDICES FÍSICOS'
      },
      {
        code: 3162,
        name: 'RESISTÊNCIA AO IMPACTO DE CORPO DURO'
      },
      {
        code: 3165,
        name: 'RUPTURA DE PRISMA OCO'
      },
      {
        code: 3171,
        name: 'ALTERABILIDADE EM ROCHAS'
      },
      {
        code: 3175,
        name: 'UMIDADE EM ALIMENTOS'
      },
      {
        code: 3177,
        name: 'TESTE DE COCÇÃO'
      },
      {
        code: 3179,
        name: 'GLICÍDIOS (AÇÚCARES TOTAIS)E/OU LACTOSE (EM LEITE E PRODUTOS LÁCTEOS)'
      },
      {
        code: 3182,
        name: 'ÍNDICE ACIDEZ/ ÍNDICE NEUTRALIZAÇÃO EM ALIMENTOS'
      },
      {
        code: 3183,
        name: 'SULFATO EM SAL'
      },
      {
        code: 3184,
        name: 'VALOR CALÓRICO ( CARBOIDRATOS / PROTEÍNAS / LIPÍDIOS )'
      },
      {
        code: 3187,
        name: 'ANÁLISE ÁGUA MINERAL NATURAL E ÁGUA NATURAL (C. TOTAIS E FECAIS, E. COLI, ENTEROCOCOS, PSEUDOMONAS E CLOSTRÍDIOS SULFITOS REDUTORES)'
      },
      {
        code: 3188,
        name: 'ANÁLISE MICROBIOLÓGICA: CONTAGEM DE BACTÉRIAS HALOFÍLICAS'
      },
      {
        code: 3190,
        name: 'ANÁLISE MICROBIOLÓGICA: CONTAGEM DE BACTÉRIAS PROD. DE ÁCIDOS'
      },
      {
        code: 3192,
        name: 'ANÁLISE MICROBIOLÓGICA: CONTAGEM DE BACTÉRIAS PSICRÓFILAS'
      },
      {
        code: 3195,
        name: 'ANÁLISE MICROBIOLÓGICA: CONTAGEM DE BACTÉRIAS HETEROTRÓFICAS'
      },
      {
        code: 3199,
        name: 'ÁNALISE MICROBIOLÓGICA ALIMENTOS: ENTEROBACTERIACEAE'
      },
      {
        code: 3200,
        name: 'TESTE DE ESTERELIDADE COMERCIAL'
      },
      {
        code: 3201,
        name: 'ANÁLISE MICROBIOLÓGICA EFLUENTE: COLIFORMES TERMOTOLERANTES'
      },
      {
        code: 3219,
        name: 'SUBSTÂNCIAS SOLÚVEIS EM HEXANO (ÓLEOS E GRAXAS)'
      },
      {
        code: 3224,
        name: 'HORA TÉCNICA - AUXILIAR TÉCNICO'
      },
      {
        code: 3225,
        name: 'HORA TÉCNICA - ENGENHEIRO'
      },
      {
        code: 3226,
        name: 'HORA TÉCNICA - TÉCNICO'
      },
      {
        code: 3227,
        name: 'LAUDO TÉCNICO'
      },
      {
        code: 3232,
        name: 'VISITA TÉCNICA (NÃO INCLUI LAUDO)'
      },
      {
        code: 3234,
        name: 'RELATÓRIO TÉCNICO DE PATOLOGIAS DE CORROSÃO EM ESTRUTURAS DE CONCRETO'
      },
      {
        code: 3235,
        name: 'RELATÓRIO TÉCNICO DE PATOLOGIAS EM REVESTIMENTOS ARGAMASSADOS E CERÂMICOS EM FACHADAS DE EDIFÍCIO'
      },
      {
        code: 3236,
        name: 'RELATÓRIO TÉCNICO DE AVALIAÇÃO ESTRUTURAL EM ALVENARIAS E ESTRUTURAS DE CONCRETO'
      },
      {
        code: 3237,
        name: 'RELATÓRIO TÉCNICO DE PATOLOGIAS EM REVESTIMENTOS DE PISO'
      },
      {
        code: 3238,
        name: 'LAUDO TÉCNICO EM AVALIAÇÃO DE DESEMPENHO EM COMPONENTES DE EDIFICAÇÃO'
      },
      {
        code: 3239,
        name: 'LAUDO TÉCNICO DE PATOLOGIAS DE CORROSÃO ESTRUTURAL'
      },
      {
        code: 3240,
        name: 'LAUDO TÉCNICO DE PATOLOGIAS EM REVESTIMENTOS ARGAMASSADOS E CERÂMICOS'
      },
      {
        code: 3241,
        name: 'LAUDO TÉCNICO DE PATOLOGIAS EM REVESTIMENTO DE PISO'
      },
      {
        code: 3263,
        name: 'DETERMINAÇÃO DE ESTABILIDADE OXIDATIVA'
      },
      {
        code: 3282,
        name: 'LAUDO TÉCNICO'
      },
      {
        code: 3304,
        name: 'RETIFICAÇÃO DE LAUDO / RELATÓRIO (10% DO VALOR DO SERVIÇO)'
      },
      {
        code: 3305,
        name: '2ª VIA DO RELATÓRIO DE PESQUISA (20% DO VALOR DO SERVIÇO)'
      },
      {
        code: 3314,
        name: 'SERVIÇO DE CADASTRO DE AÇÃO CAUTELAR'
      },
      {
        code: 3315,
        name: 'SERVIÇO DE ENVIO DE AÇÃO CAUTELAR PARA O PROCURADOR'
      },
      {
        code: 3316,
        name: 'SERVIÇO DE ELABORAÇÃO DE PEÇA PROCESSUAL DE AÇÃO CAUTELAR'
      },
      {
        code: 3317,
        name: 'SERVIÇO DE ENVIO DE PEÇA PROCESSUAL DE AÇÃO CAUTELAR À JUSTIÇA'
      },
      {
        code: 3318,
        name: 'SERVIÇO DE ACOMPANHAMENTO DE AÇÕES: MANDADO DE SEGURANÇA, ORDINÁRIA, REQUISIÇÃO DE PEQUENO VALOR, CAUTELAR, EXECUÇÃO FISCAL.'
      },
      {
        code: 3321,
        name: 'SERVIÇO DE RECOLHIMENTO DE ASSINATURAS DE MANDADO DE SEGURANÇA'
      },
      {
        code: 3322,
        name: 'SERVIÇO DE CADASTRO DE MANDADOS DE SEGURANÇA'
      },
      {
        code: 3323,
        name: 'SERVIÇO DE ENVIO DE MANDADO DE SEGURANÇA PARA O PROCURADOR'
      },
      {
        code: 3324,
        name: 'SERVIÇO DE ELABORAÇÃO DE PEÇA PROCESSUAL DE MANDADO DE SEGURANÇA'
      },
      {
        code: 3325,
        name: 'SERVIÇO DE RECOLHIMENTO DE ASSINATURAS DE MANDADO DE SEGURANÇA'
      },
      {
        code: 3326,
        name: 'SERVIÇO DE CADASTRO DE AÇÃO ORDINÁRIA'
      },
      {
        code: 3327,
        name: 'SERVIÇO DE ENVIO DE AÇÃO ORDINÁRIA PARA O PROCURADOR'
      },
      {
        code: 3328,
        name: 'SERVIÇO DE ELABORAÇÃO DE PEÇA PROCESSUAL DE AÇÃO ORDINÁRIA'
      },
      {
        code: 3329,
        name: 'SERVIÇO DE ENVIO DE PEÇA PROCESSUAL DE AÇÃO ORDINÁRIA A JUSTIÇA'
      },
      {
        code: 3333,
        name: 'SERVIÇO DE CADASTRAMENTO DE APOSENTADORIA'
      },
      {
        code: 3334,
        name: 'SERVIÇO DE MELHORIA DO SISTEMA LICITAR'
      },
      {
        code: 3335,
        name: 'SERVIÇO DE MELHORIA DO SISTEMA LICITAR'
      },
      {
        code: 3336,
        name: 'DERMATOLOGIA GERAL'
      },
      {
        code: 3338,
        name: 'RECEBIMENTO DE DENÚNCIA'
      },
      {
        code: 3350,
        name: 'ACADEMIA DE GINASTICA DE SOBRAL - AGIS'
      },
      {
        code: 3351,
        name: 'NÚCLEO DE LÍNGUAS ESTRANGEIRAS (NUCLE)'
      },
      {
        code: 3352,
        name: 'PREVEST'
      },
      {
        code: 3354,
        name: 'DENÚNCIA DE RETENÇÃO DE DOCUMENTOS PELA INSTITUIÇÃO DE ENSINO'
      },
      {
        code: 3356,
        name: 'SOLICITAÇÃO DE EXERCÍCIO DE DIREÇÃO'
      },
      {
        code: 3357,
        name: 'COMUNICAÇÃO DE MUDANÇA DE SEDE DE INSTITUIÇÃO DE ENSINO'
      },
      {
        code: 3359,
        name: 'RECONHECIMENTO DE CURSO DA EDUCAÇÃO BÁSICA'
      },
      {
        code: 3361,
        name: 'COMUNICAÇÃO DE MUDANÇA DE ENDEREÇO DE INSTITUIÇÃO PÚBLICA'
      },
      {
        code: 3364,
        name: 'INFORMAÇÕES SOBRE INADIMPLÊNCIA'
      },
      {
        code: 3368,
        name: 'INFORMAÇÃO SOBRE APROVAÇÃO DE EJA - FUNDAMENTAL'
      },
      {
        code: 3370,
        name: 'CREDENCIAMENTO E RECREDENCIAMENTO DA INSTITUIÇÃO DE EDUCAÇÃO PROFISSIONAL TÉCNICA DE NÍVEL MÉDIO'
      },
      {
        code: 3372,
        name: 'INFORMAÇÕES SOBRE AVANÇO PROGRESSIVO - CARÁTER EXCEPCIONAL'
      },
      {
        code: 3373,
        name: 'SOLICITAÇÃO DE RECREDENCIAMENTO, AUTORIZAÇÃO, RECONHECIMENTO E RENOVAÇÃO DE RECONHECIMENTO DE CURSO DE ESCOLA PÚBLICA'
      },
      {
        code: 3374,
        name: 'RECREDENCIAMENTO E AUTORIZAÇÃO DA EDUCAÇÃO INFANTIL DE INSTITUIÇÃO PÚBLICA E PARTICULAR, QUE NÃO FUNCIONAM CONSELHO MUNICIPAL DE EDUCAÇÃO'
      },
      {
        code: 3375,
        name: 'APROVAÇÃO DE REGIMENTO COM PROGRESSÃO PARCIAL'
      },
      {
        code: 3376,
        name: 'SOLICITAÇÃO DE RECREDENCIAMENTO E AUTORIZAÇÃO DO CURSO DE EDUCAÇÃO INFANTIL DA INSTITUIÇÃO PARTICULAR - FORTALEZA-CE'
      },
      {
        code: 3377,
        name: 'APOIO A OFERTA DE UNIDADES HABITACIONAIS DE INTERESSE SOCIAL NO ÂMBITO DO PROGRAMA MINHA CASA MINHA VIDA - PMCMV, DO GOVERNO FEDERAL.'
      },
      {
        code: 3378,
        name: 'RECONHECIMENTO E RENOVAÇÃO DO RECONHECIMENTO DO CURSO TÉCNICO'
      },
      {
        code: 3379,
        name: 'INFORMAÇÕES SOBRE APROVAÇÃO DE NUCLEAÇÃO'
      },
      {
        code: 3380,
        name: 'CREDENCIAMENTO E RECREDENCIAMENTO DA INSTITUIÇÃO NA MODALIDADE DE EDUCAÇÃO A DISTÂNCIA - EAD'
      },
      {
        code: 3381,
        name: 'OFERTA DE FOGÕES COM EFICIÊNCIA ENERGÉTICA.'
      },
      {
        code: 3383,
        name: 'OFERTA DE UNIDADES SANITÁRIAS DOMICILIARES.'
      },
      {
        code: 3384,
        name: 'REGULARIZAÇÃO DE VIDA ESCOLAR'
      },
      {
        code: 3385,
        name: 'TRABALHO SOCIAL PARA IMPLEMENTAÇÃO DOS PROJETOS DE HABITAÇÃO DE INTERESSE SOCIAL.'
      },
      {
        code: 3386,
        name: 'INFORMAÇÕES SOBRE CLASSIFICAÇÃO'
      },
      {
        code: 3387,
        name: 'INFORMAÇÕES SOBRE RECLASSIFICAÇÃO'
      },
      {
        code: 3388,
        name: 'PROXY CORPORATIVO'
      },
      {
        code: 3389,
        name: 'SOLICITAÇÃO DE EQUIVALÊNCIA OU RECLASSIFICAÇÂO DE ESTUDOS REALIZADOS NO EXTERIOR'
      },
      {
        code: 3390,
        name: 'DENÚNCIAS SOBRE MAUS TRATOS'
      },
      {
        code: 3391,
        name: 'SOLICITAÇÃO DE CREDENCIAMENTO, AUTORIZAÇÃO E RECONHECIMENTO DE CURSO.'
      },
      {
        code: 3392,
        name: 'INFORMAÇÕES SOBRE PREENCHIMENTO DO HISTÓRICO ESCOLAR'
      },
      {
        code: 3393,
        name: 'DENÚNCIA DE PROFESSORES SEM HABILITAÇÃO'
      },
      {
        code: 3819,
        name: 'DOAÇÃO BENS MÓVEIS'
      },
      {
        code: 3394,
        name: 'SOLICITAÇÃO PARA AUTORIZAÇÃO TEMPORÁRIA PARA PROFESSOR'
      },
      {
        code: 3395,
        name: 'AUTORIZAÇÃO PARA OFERTA DE CURSO TÉCNICO DE NÍVEL MÉDIO NA MODALIDADE A DISTÂNCIA - EAD'
      },
      {
        code: 3396,
        name: 'INFORMAÇÃO SOBRE SISTEMÁTICA DE AVALIAÇÃO PARA A EDUCAÇÃO BÁSICA'
      },
      {
        code: 3397,
        name: 'MANUTENÇÃO PREVENTIVA'
      },
      {
        code: 3398,
        name: 'DENÚNCIA DE DESCUMPRIMENTO DA LDB'
      },
      {
        code: 3399,
        name: 'MANUTENÇÃO CORRETIVA'
      },
      {
        code: 3400,
        name: 'DENÚNCIA SOBRE AUTORITARISMO'
      },
      {
        code: 3401,
        name: 'APOIO TÉCNICO E FINANCEIRO À EXECUÇÃO DE PROJETOS DE INSERÇÃO PRODUTIVA'
      },
      {
        code: 3402,
        name: 'VESTIBULAR'
      },
      {
        code: 3403,
        name: 'HOMOLOGAÇÃO DE REGIMENTO'
      },
      {
        code: 3404,
        name: 'APOIO TÉCNICO E FINANCEIRO AOS MUNICÍPIOS PARA EXECUÇÃO DE OBRAS DE ESTRUTURAÇÃO E REQUALIFICAÇÃO URBANA'
      },
      {
        code: 3405,
        name: 'INTERNET'
      },
      {
        code: 3408,
        name: 'SUPERVISÃO DO PROGRAMA DE VALORIZAÇÃO DO PROFISSIONAL DA ATENÇÃO BÁSICA - PROVAB (CATEGORIA MÉDICO)'
      },
      {
        code: 3411,
        name: 'MINISTRAR PALESTRAS SOBRE SMS (SEGURANÇA, MEIO AMBIENTE E SAÚDE) NA UTILIZAÇÃO DO GN.'
      },
      {
        code: 3413,
        name: 'INTERVENÇÕES NA REDE DE GASODUTOS'
      },
      {
        code: 3414,
        name: 'DETERMINAÇÃO DO PADRÃO DO CRM'
      },
      {
        code: 3415,
        name: 'SALA DO CLIENTE'
      },
      {
        code: 3416,
        name: 'LIGAÇÃO DO CLIENTE'
      },
      {
        code: 3418,
        name: 'PARADA PROGRAMADA PARA MANUTENÇÃO DO CLIENTE'
      },
      {
        code: 3420,
        name: 'PARADA PROGRAMADA'
      },
      {
        code: 3423,
        name: 'LOCAÇÃO DO ABRIGO'
      },
      {
        code: 3426,
        name: 'LIBERAÇÃO DE MERCADORIA MEDIANTE DEPÓSITO ADMINISTRATIVO'
      },
      {
        code: 3429,
        name: 'Emissão de Guia de Trânsito Animal (GTA)'
      },
      {
        code: 3430,
        name: 'REGULARIZAÇÃO FUNDIÁRIA DE IMOVEIS URBANOS'
      },
      {
        code: 3432,
        name: 'FISCALIZAÇÃO DE EVENTOS AGROPECUÁRIOS'
      },
      {
        code: 3433,
        name: 'CADASTRO AGROPECUÁRIO'
      },
      {
        code: 3434,
        name: 'Serviço de Inspeção Estadual - SIE'
      },
      {
        code: 3435,
        name: 'EDITAL DE SELEÇÃO PARA PONTOS DE CULTURA DO ESTADO DO CEARÁ'
      },
      {
        code: 3436,
        name: 'REGISTRO DE OCORRÊNCIAS DE CRIMES CONTRA O IDOSO'
      },
      {
        code: 3437,
        name: 'PROCESSO DE TERMO DE ACORDO/CREDENCIAMENTO TRANSPORTADORAS'
      },
      {
        code: 3439,
        name: 'FISCALIZAÇÃO DA CAMPANHA DE VACINAÇÃO CONTRA FEBRE AFTOSA'
      },
      {
        code: 3440,
        name: 'VISITAS ÀS EXPOSIÇÕES DO MUSEU DO CEARÁ'
      },
      {
        code: 3442,
        name: 'VISITA AO MUSEU SACRO SÃO JOSÉ DE RIBAMAR.'
      },
      {
        code: 3443,
        name: 'VISITA AS EXPOSIÇÕES DO MUSEU SACRO SÃO JOSÉ DE RIBAMAR'
      },
      {
        code: 3444,
        name: 'PROCESSO DE SINISTRO'
      },
      {
        code: 3445,
        name: 'BIBLIOTECA MOZART MONTEIRO'
      },
      {
        code: 3446,
        name: 'SELAGEM / REGISTRO DE NOTAS FISCAIS'
      },
      {
        code: 3447,
        name: 'ALTERAÇÃO DE SELAGEM / REGISTRO DE NOTAS FISCAIS'
      },
      {
        code: 3448,
        name: 'EDUCAÇÃO SANITÁRIA ANIMAL'
      },
      {
        code: 3450,
        name: 'FISCALIZAÇÃO DE ESTABELECIMENTOS QUE COMERCIALIZAM PRODUTOS DE USO VETERINÁRIO'
      },
      {
        code: 3451,
        name: 'EMISSÃO DE NOTA FISCAL AVULSA DO AUTO DE INFRAÇÃO E APREENSÃO DE MERCADORIAS'
      },
      {
        code: 3453,
        name: 'ANULAÇÃO DO IMPOSTO REFERENTE NA AQUISIÇÃO DE MERCADORIAS EM OPERAÇÃO INTERESTADUAL'
      },
      {
        code: 3455,
        name: 'CANCELAMENTO DE SELO DE TRÂNSITO / REGISTRO DE NOTAS FISCAIS NO SITRAM'
      },
      {
        code: 3457,
        name: 'GESTÃO DE SISTEMAS'
      },
      {
        code: 3458,
        name: 'SISTEMA DE INFORMAÇÕES CULTURAIS - SINF'
      },
      {
        code: 3459,
        name: 'CONTROLE E FISCALIZAÇÃO DO TRÂNSITO DE ANIMAIS, SEUS PRODUTOS E SUBPRODUTOS'
      },
      {
        code: 3461,
        name: 'ADMINISTRAÇÃO DA CASA DE JUVENAL GALENO'
      },
      {
        code: 3462,
        name: 'EDITAL DE SELEÇÃO ALBERTO NEPOMUCENO'
      },
      {
        code: 3463,
        name: 'CONCEDER AUDITÓRIOS PARA REUNIÕES CULTURAIS QUE NÃO POSSUEM SEDES PRÓPRIAS.'
      },
      {
        code: 3464,
        name: 'EXECUTAR OS PROGRAMAS SANITÁRIOS DA ÁREA ANIMAL (FEBRE AFTOSA, BRUCELOSE, TUBERCULOSE, RAIVA, ANEMIA INFECCIOSA EQUINA, MORMO, PESTE SUÍNA CLÁSSICA, INFLUENZA AVIÁRIA, DOENÇA DE NEW CASTLE, MICOPLAMOSE AVIÁRIA, SALMONELOSE, DENTRE OUTRAS)'
      },
      {
        code: 3465,
        name: 'PROJETOS CULTURAIS ATRAVÉS DE EDITAIS.'
      },
      {
        code: 3466,
        name: 'PROMOVER EVENTOS CULTURAIS'
      },
      {
        code: 3467,
        name: 'EXPOSIÇÕES'
      },
      {
        code: 3468,
        name: 'AÇÃO EDUCATIVA'
      },
      {
        code: 3469,
        name: 'OFICINAS'
      },
      {
        code: 3470,
        name: 'APOIO À FORMAÇÃO E PROFISSIONALIZAÇÃO ARTÍSTICA'
      },
      {
        code: 3471,
        name: 'SESSÃO DO AUDITÓRIO'
      },
      {
        code: 3473,
        name: 'SESSÕES ESPECIAIS DE CINECLUBE'
      },
      {
        code: 3474,
        name: 'BIBLIOTECA'
      },
      {
        code: 3475,
        name: 'ACESSO À INTERNET'
      },
      {
        code: 3476,
        name: 'EDITAL DE SUBVENÇÕES SOCIAIS.'
      },
      {
        code: 3477,
        name: 'FISCALIZAÇÃO DE PROPRIEDADES RURAIS E ESTABELECIMENTOS DE RISCO SANITÁRIO'
      },
      {
        code: 3478,
        name: 'BUSCA, RESGATE E SALVAMENTO DE PESSOAS E BENS'
      },
      {
        code: 3483,
        name: 'TABELA DE PREÇOS'
      },
      {
        code: 3485,
        name: 'ATENDIMENTO MÉDICO PARA PORTADORES DE HIV/AIDS NO AMBULATÓRIO DO HSJ'
      },
      {
        code: 3486,
        name: 'ATENDIMENTO DE ENDOCRINOLOGIA DO HSJ'
      },
      {
        code: 3487,
        name: 'ACOMPANHAMENTO MULTIDISCIPLINAR AOS RECÉM-NASCIDOS E LACTENTES ATÉ 06 MESES COM ALTERAÇÃO DE DESENVOLVIMENTO.'
      },
      {
        code: 3488,
        name: 'AMBULATÓRIO DE DIAGNÓSTICO PRECOCE DE CÂNCER'
      },
      {
        code: 3489,
        name: 'AMBULATÓRIO DE DOENÇA DE GAUCHER'
      },
      {
        code: 3490,
        name: 'AMBULATÓRIO DE FIBROSE CÍSTICA'
      },
      {
        code: 3491,
        name: 'ATENDIMENTO ONCOLÓGICO EM REGIME AMBULATORIAL (PACIENTES QUE CONCLUÍRAM TRATAMENTO)'
      },
      {
        code: 3492,
        name: 'ATENDIMENTO ORTODÔNTICO AO PACIENTE FISSURADO, AO PACIENTE PORTADOR DE DEFICIÊNCIA FÍSICA E/OU MENTAL, ADOLESCENTES DO PROGRAMA DE ADOLESCENTES DO HIAS E PACIENTES DO CENTRO PEDIÁTRICO DO CÂNCER (CPC).'
      },
      {
        code: 3493,
        name: 'EXAMES LABORATORIAIS'
      },
      {
        code: 3495,
        name: 'ENFOQUE ECONÔMICO'
      },
      {
        code: 3496,
        name: 'INFORME IPECE'
      },
      {
        code: 3498,
        name: 'IPECE INFORME'
      },
      {
        code: 3499,
        name: 'ENFOQUE ECONÔMICO'
      },
      {
        code: 3500,
        name: 'REALIZAÇÃO DE BIÓPSIA HEPÁTICA PERCUTÂNEA EM PACIENTES ACOMPANHADOS NO HSJ'
      },
      {
        code: 3506,
        name: 'PESQUISA DE LINHAS REGULARES DE PASSAGEIROS (ÕNIBUS,VANS)'
      },
      {
        code: 3517,
        name: 'INTERNAÇÃO PARA DIAGNÓSTICO E TRATAMENTO CLÍNICO DE PACIENTES COM DOENÇAS INFECCIOSAS NAS UNIDADES DO HSJ'
      },
      {
        code: 3518,
        name: 'ATENDIMENTO E ACOMPANHAMENTO DE PESSOAS EXPOSTAS AO RISCO DE CONTAMINAÇÃO COM MATERIAL BIOLÓGICO'
      },
      {
        code: 3519,
        name: 'ORIENTAÇÃO TÉCNICA NA REALIZAÇÃO DE CONFERÊNCIAS MUNICIPAIS DAS CIDADES'
      },
      {
        code: 3523,
        name: 'Programa Estadual de Prevenção, Monitoramento, Controle de Queimadas e Combate aos Incêndios Florestais - PREVINA'
      },
      {
        code: 3524,
        name: 'Programa Selo Município Verde'
      },
      {
        code: 3526,
        name: 'DIVIDA ATIVA - MULTAS APLICADAS POR COMETIMENTO DE INFRAÇÃO A LEGISLAÇÃO DE TRÂNSITO E DE TRANSPORTE.'
      },
      {
        code: 3527,
        name: 'OFERTA DE UNIDADES HABITACIONAIS DE INTERESSE SOCIAL, NO ÂMBITO DOS PROJETOS RIO MARANGUAPINHO, RIO COCÓ E DENDÊ'
      },
      {
        code: 3530,
        name: 'TRABALHO SOCIAL PARA A IMPLEMENTAÇÃO DOS PROJETOS RIO MARANGUAPINHO, RIO COCÓ E DENDÊ'
      },
      {
        code: 3531,
        name: 'PACAD – PROGRAMA DE AÇÕES CONTINUADAS DE ASSISTÊNCIA AOS DROGADICTOS'
      },
      {
        code: 3533,
        name: 'SERVIÇO DE ATENDIMENTO PSICOSSOCIAL AO TRABALHADOR'
      },
      {
        code: 3534,
        name: 'SERVIÇOS DE OUVIDORIA.'
      },
      {
        code: 3536,
        name: 'FORMAÇÃO CONTÍNUA DE PROFESSORES'
      },
      {
        code: 3537,
        name: 'PROGRAMA NACIONAL DOS LIVROS - PNLD'
      },
      {
        code: 3538,
        name: 'APOIO ÀS ESCOLAS PARA INTENSIFICAREM A PREPARAÇÃO DOS ALUNOS PARA O ENEM E VESTIBULARES.'
      },
      {
        code: 3539,
        name: 'APOIO À INICIAÇÃO CIENTÍFICA'
      },
      {
        code: 3543,
        name: 'VISITA GUIADA AO THEATRO JOSÉ DE ALENCAR'
      },
      {
        code: 3544,
        name: 'PROGRAMA BOLSA FAMÍLIA - ACOMPANHAMENTO DA FREQUÊNCIA ESCOLAR DOS ALUNOS BENEFICIÁRIOS'
      },
      {
        code: 3549,
        name: 'CADASTRO PARA DOAÇÃO DE MEDULA ÓSSEA'
      },
      {
        code: 3550,
        name: 'REAÇÃO DE IMUNOFLUORESCÊNCIA INDIRETA PARA FEBRE MACULOSA- RIFI'
      },
      {
        code: 3551,
        name: 'CULTURA DE FEZES OU COPROCULTURA'
      },
      {
        code: 3552,
        name: 'CULTURA DE SANGUE OU HEMOCULTURA'
      },
      {
        code: 3553,
        name: 'CULTURAS EM GERAL'
      },
      {
        code: 3554,
        name: 'CULTURA PARA MENINGITE BACTERIANA'
      },
      {
        code: 3556,
        name: 'CULTURA PARA COQUELUCHE'
      },
      {
        code: 3562,
        name: 'EMISSÃO DE DAE'
      },
      {
        code: 3563,
        name: 'DAE DE IPVA'
      },
      {
        code: 3564,
        name: 'RESIDÊNCIA MULTIPROFISSIONAL EM SAÚDE'
      },
      {
        code: 3565,
        name: 'CURSOS DE ATUALIZAÇÃO NAS ÁREAS DE ATENÇÃO E VIGILÂNCIA EM SAÚDE'
      },
      {
        code: 3566,
        name: 'ATENDIMENTO A PESSOAS COM COAGULOPATIAS HEREDITÁRIAS (HEMOFILIA)'
      },
      {
        code: 3567,
        name: 'DOAÇÃO DO SANGUE DE CORDÃO UMBILICAL E PLACENTÁRIO'
      },
      {
        code: 3568,
        name: 'ATENDIMENTO A PESSOAS COM HEMOGLOBINOPATIAS HEREDITÁRIAS (DOENÇA FALCIFORME)'
      },
      {
        code: 3569,
        name: 'AVALIAÇÃO DE IMÓVEIS PARA FINS DE DESAPROPRIAÇÃO, LOCAÇÃO OU PERMUTA.'
      },
      {
        code: 3570,
        name: 'ESPECIFICAÇÃO TÉCNICA PARA OBRAS DE EDIFICAÇÃO.'
      },
      {
        code: 3571,
        name: 'ELABORAÇÃO DE CRONOGRAMA FÍSICO-FINANCEIRO PARA OBRAS DE EDIFICAÇÃO.'
      },
      {
        code: 3572,
        name: 'ELABORAÇÃO DE PROJETOS PARA OBRAS DE EDIFICAÇÃO.'
      },
      {
        code: 3573,
        name: 'GERENCIAMENTO DE ARQUIVAMENTO DE DOCUMENTOS.'
      },
      {
        code: 3574,
        name: 'ANÁLISE DE PROJETO.'
      },
      {
        code: 3575,
        name: 'COMPATIBILIZAÇÃO DE PROJETOS.'
      },
      {
        code: 3576,
        name: 'PARECER TÉCNICO.'
      },
      {
        code: 3577,
        name: 'ASSESSORIA EM OBRA DE EDIFICAÇÃO EM EXECUÇÃO.'
      },
      {
        code: 3578,
        name: 'ELABORAÇÃO DE ORÇAMENTO.'
      },
      {
        code: 3579,
        name: 'ACOMPANHAMENTO NO LICENCIAMENTO AMBIENTAL.'
      },
      {
        code: 3580,
        name: 'ELABORAÇÃO DE EDITAIS.'
      },
      {
        code: 3581,
        name: 'VISTÓRIA TÉCNICA.'
      },
      {
        code: 3582,
        name: 'FISCALIZAÇÃO DE OBRA DE EDIFICAÇÃO.'
      },
      {
        code: 3583,
        name: 'FISCALIZAÇÃO DE OBRA DE EDIFICAÇÃO.'
      },
      {
        code: 3584,
        name: 'VISTÓRIA TÉCNICA.'
      },
      {
        code: 3585,
        name: 'FISCALIZAÇÃO DE OBRA DE EDIFICAÇÃO.'
      },
      {
        code: 3586,
        name: 'EMISSÃO DE ORDEM DE SERVIÇO DA OBRA.'
      },
      {
        code: 3587,
        name: 'ELABORAÇÃO DE ADITIVO DE PRAZO DA OBRA.'
      },
      {
        code: 3588,
        name: 'ELABORAÇÃO DE ADITIVO DE VALOR.'
      },
      {
        code: 3589,
        name: 'CADASTRO DO ORÇAMENTO CONTRATUAL DAS OBRAS DE EDIFICAÇÕES.'
      },
      {
        code: 3590,
        name: 'ACOMPANHAMENTO DO PROCESSAMENTO DAS MEDIÇÕES DAS OBRAS DE EDIFICAÇÃO.'
      },
      {
        code: 3591,
        name: 'CÁLCULO DO REAJUSTE CONTRATUAL DAS OBRAS DE EDIFICAÇÃO.'
      },
      {
        code: 3592,
        name: 'EMISSÃO DE ATESTADOS TÉCNICOS DOS SERVIÇOS EXECUTADOS DE OBRAS DE EDIFICAÇÃO.'
      },
      {
        code: 3593,
        name: 'ORÇAMENTO DE OBRA CARACTERIZADA COMO ESPECIAL.'
      },
      {
        code: 3594,
        name: 'ANÁLISE DE ORÇAMENTO DE OBRAS COM CARACTERISTICA ESPECIAL.'
      },
      {
        code: 3595,
        name: 'FISCALIZAÇÃO DE OBRAS COM CARACTERISTICA ESPECIAL.'
      },
      {
        code: 3596,
        name: 'Políticas Ambientais relacionadas aos Agrotóxicos'
      },
      {
        code: 3597,
        name: 'ANÁLISE DE PROJETOS.'
      },
      {
        code: 3598,
        name: 'PROJETO MANEJO SUSTENTÁVEL DA PRODUÇÃO AGROPECUÁRIA'
      },
      {
        code: 3601,
        name: 'Implantação do Sistema de Monitoramento da Aquicultura nos Açudes Públicos do Ceará: Açude Castanhão, Açude General Sampaio, Açude Pentecoste, Açude Sítios Novos e Açude Orós.'
      },
      {
        code: 3602,
        name: 'Implementação da Eficiência Energética para as Indústrias Cerâmicas do Baixo Jaguaribe'
      },
      {
        code: 3603,
        name: 'PROJETO “IDENTIFICAÇÃO DAS ÁREAS DE RISCO DE ACIDENTES COM PRODUTOS QUÍMICOS PERIGOSOS NO ESTADO DO CEARÁ”'
      },
      {
        code: 3604,
        name: 'CAPACITAÇÃO PEDAGÓGICA DE DOCENTES'
      },
      {
        code: 3605,
        name: 'CURSOS BÁSICOS EM SAÚDE'
      },
      {
        code: 3606,
        name: 'CURSOS DE APERFEIÇOAMENTO EM SAÚDE'
      },
      {
        code: 3607,
        name: 'CURSOS DE ATUALIZAÇÃO EM SAÚDE'
      },
      {
        code: 3608,
        name: 'CURSOS DE ESPECIALIZAÇÃO PÓS-TÉCNICA EM SAÚDE'
      },
      {
        code: 3609,
        name: 'CURSOS DE FORMAÇÃO TÉCNICA DE NÍVEL MÉDIO EM SAÚDE, ABERTO À COMUNIDADE'
      },
      {
        code: 3610,
        name: 'CURSOS DE FORMAÇÃO TÉCNICA DE NÍVEL MÉDIO EM SAÚDE'
      },
      {
        code: 3611,
        name: 'CURSOS DE PÓS-GRADUAÇÃO LATO SENSU NAS ÁREAS DE GESTÃO, ATENÇÃO E VIGILÂNCIA EM SAÚDE'
      },
      {
        code: 3612,
        name: 'RESIDÊNCIA MÉDICA'
      },
      {
        code: 3613,
        name: 'PRECEPTORIA DE RESIDÊNCIA MÉDICA'
      },
      {
        code: 3614,
        name: 'CURSOS DE APERFEIÇOAMENTO NAS ÁREAS DE GESTÃO, ATENÇÃO E VIGILÂNCIA EM SAÚDE'
      },
      {
        code: 3615,
        name: 'CURSOS BÁSICOS NAS ÁREAS DE GESTÃO, ATENÇÃO E VIGILÂNCIA EM SAÚDE'
      },
      {
        code: 3616,
        name: 'O CATÁLOGO ELETRÔNICO DE SERVIÇOS – ACESSO CIDADÃO'
      },
      {
        code: 3617,
        name: 'TRANSPORTE ESCOLAR PARA ALUNOS DA REDE PÚBLICA ESTADUAL'
      },
      {
        code: 3618,
        name: 'ESCRITURA'
      },
      {
        code: 3619,
        name: 'CURSOS DE QUALIFICAÇÃO DE REPRESENTANTES DA SOCIEDADE CIVIL NAS POLÍTICAS PÚBLICAS DE JUVENTUDE'
      },
      {
        code: 3620,
        name: 'ATENDIMENTOS A REPRESENTANTES DE ORGANIZAÇÕES DA SOCIEDADE CIVIL'
      },
      {
        code: 3621,
        name: 'REALIZAR ORIENTAÇÕES ÀS PREFEITURAS PARA CRIAÇÃO DOS CONSELHOS MUNICIPAIS DE DIREITOS HUMANOS'
      },
      {
        code: 3622,
        name: 'REALIZAÇÃO DE REUNIÕES DA COMISSÃO DE CREDENCIAMENTO PERMANENTE DA CARTEIRA DE ESTUDANTE DAS MACRORREGIÕES DO ESTADO DO CEARÁ'
      },
      {
        code: 3623,
        name: 'EXAMES DE ANÁLISES CLÍNICAS - INTERIOR'
      },
      {
        code: 3624,
        name: 'SUPERINTENDÊNCIA ESCOLAR'
      },
      {
        code: 3625,
        name: 'ALIMENTAÇÃO ESCOLAR'
      },
      {
        code: 3626,
        name: 'COORDENAÇÃO DE PROGRAMAS E PROJETOS DE GESTÃO ESCOLAR'
      },
      {
        code: 3627,
        name: 'PROCESSO DE PROVIMENTO DOS NÚCLEOS GESTORES'
      },
      {
        code: 3629,
        name: 'ACOMPANHAMENTO DE PROCEDIMENTO DO ESTAGIO NÃO OBRIGATÓRIO DO ENSINO MÉDIO NAS ESCOLAS PÚBLICAS'
      },
      {
        code: 3630,
        name: 'ACOMPANHAMENTO DAS ESCOLAS ESTADUAIS PARTICIPANTES DO PROGRAMA MAIS EDUCAÇÃO.'
      },
      {
        code: 3631,
        name: 'COORDENAÇÃO ESTADUAL DO PROJETO PROFESSOR DIRETOR DE TURMA'
      },
      {
        code: 3632,
        name: 'PROGRAMA SAÚDE NA ESCOLA (PSE)'
      },
      {
        code: 3633,
        name: 'PROJETO SAÚDE E PREVENÇÃO NAS ESCOLA (SPE)'
      },
      {
        code: 3634,
        name: 'APRENDIZAGEM COOPERATIVA'
      },
      {
        code: 3636,
        name: 'RESISTÊNCIA À COMPRESSÃO DE BLOCOS VAZADOS DE CONCRETO PARA ALVENARIA - COM LARGURA DE 19 CM'
      },
      {
        code: 3641,
        name: 'POTÁSSIO EM ÁGUA'
      },
      {
        code: 3643,
        name: 'INDICE DE ESTER EM ÓLEOS E GRAXAS NATURAIS'
      },
      {
        code: 3645,
        name: 'CONSTATAÇÃO DE VENENO DA CLASSE DOS CARBAMATOS EM AMOSTRAS NÃO-BIOLÓGICAS'
      },
      {
        code: 3646,
        name: 'CONSTATAÇÃO DE VENENOS DA CLASSE DOS ORGANOFOSFORADOS EM AMOSTRAS NÃO BIOLÓGICAS'
      },
      {
        code: 3648,
        name: 'PERICIA GRAFOTECNICA PARA VERIFICAÇÃO DE AUTORIA DE ESCRITA'
      },
      {
        code: 3649,
        name: 'PERICIA GRAFOTECNICA PARA VERIFICAÇÃO DE UNICIDADE DE PUNHO ESCRITOR.'
      },
      {
        code: 3650,
        name: 'PERICIA GRAFOTECNICA PARA VERIFICAÇÃO DE ACRESCIMOS/ SOBREPOSIÇÕES/ E/OU QUALQUER TIPO DE MODIFICAÇÃO TEXTUAL RELACIONADA AO GRAFISMO NO DOCUMENTO.'
      },
      {
        code: 3651,
        name: 'PERICIA DOCUMENTOSCOPICA EM DOCUMENTOS OFICIAIS.'
      },
      {
        code: 3652,
        name: 'PERICIA DOCUMENTOSCOPICA EM DOCUMENTOS RELACIONADOS AO ART. 171 - CP.'
      },
      {
        code: 3654,
        name: 'CAPACITAÇÃO EM GESTÃO DOS RECURSOS HÍDRICOS'
      },
      {
        code: 3655,
        name: 'MEDIAÇÃO DE CONFLITOS'
      },
      {
        code: 3656,
        name: 'ALOCAÇÃO PARTICIPATIVA DE ÁGUA'
      },
      {
        code: 3663,
        name: 'PROGRAMA DE PRÓTESE OCULAR'
      },
      {
        code: 3664,
        name: 'ENSAIOS FÍSICO-QUÍMICO EM EFLUENTES'
      },
      {
        code: 3665,
        name: 'FLUORETO'
      },
      {
        code: 3668,
        name: 'ARGAMASSA DE REVESTIMENTO E ALVENARIA.'
      },
      {
        code: 3669,
        name: 'COLETA DE AMOSTRA DE CIMENTO'
      },
      {
        code: 3670,
        name: 'CAPACITAÇÃO PROFISSONAL'
      },
      {
        code: 3673,
        name: 'EFETIVAÇÃO DOS DIREITOS DA PESSOA COM DEFICIÊNCIA.'
      },
      {
        code: 3676,
        name: 'RECEBIMENTO E MONITORAMENTO DE DENÚNCIAS DE CASOS DE TORTURA, BEM COMO VISITAÇÃO AOS LOCAIS DE PRIVAÇÃO DE LIBERDADE COM O INTUITO DE ELABORA'
      },
      {
        code: 3677,
        name: 'SERVIÇO JURÍDICOS - CONSELHO PENITENCIÁRIO'
      },
      {
        code: 3678,
        name: 'Recebimento, apuração e monitoramento de denúncias de violações de direitos humanos, compreendendo os direitos fundamentais, individuais, col'
      },
      {
        code: 3679,
        name: 'ATENDIMENTO ÀS VÍTIMAS DE CRIMES VIOLENTOS'
      },
      {
        code: 3680,
        name: 'Programa de Proteção a Vítimas e Testemunhas Ameaçadas – PROVITA'
      },
      {
        code: 3681,
        name: 'Programa de Proteção aos Defensores(as) de Direitos Humanos – PPDDH'
      },
      {
        code: 3682,
        name: 'Programa de Proteção a Crianças e Adolescentes Ameaçados de Morte – PPCAAM'
      },
      {
        code: 3683,
        name: 'ENFRENTAMENTO AO TRÁFICO DE PESSOAS'
      },
      {
        code: 3684,
        name: 'RÁDIO LIVRE'
      },
      {
        code: 3685,
        name: 'SERVIÇO DE SAÚDE PARA O SISTEMA PRISIONAL'
      },
      {
        code: 3686,
        name: 'Formação Continuada de Servidores da Secretaria de Justiça e Cidadania - SEJUS'
      },
      {
        code: 3687,
        name: 'CARTÃO PROVISÓRIO ISSEC'
      },
      {
        code: 3689,
        name: 'ATENDIMENTO HUMANIZADO AO MIGRANTE'
      },
      {
        code: 3691,
        name: 'PROGRAMA DE MONITORIA ACADÊMICA - PROMAC'
      },
      {
        code: 3693,
        name: 'CONCESSÃO DE AUXÍLIO À INOVAÇÃO TECNOLÓGICA:'
      },
      {
        code: 3694,
        name: 'CONCESSÃO DE AUXÍLIOS'
      },
      {
        code: 3695,
        name: 'DEFINIR E ATUALIZAR POLÍTICAS DE TECNOLOGIA DA INFORMAÇÃO E COMUNICAÇÃO'
      },
      {
        code: 3696,
        name: 'CONCESSÃO DE BOLSAS:'
      },
      {
        code: 3698,
        name: 'ACOMPANHAR OS PLANEJAMENTOS DAS ESTRATÉGIAS (PETIC) E DOS PLANOS DE AÇÕES (PA) DE TECNOLOGIA DA INFORMAÇÃO E COMUNICAÇÃO DOS ÓRGÃOS E ENTIDAD'
      },
      {
        code: 3699,
        name: 'ISENÇÃO/RESTITUIÇÃO DO IMPOSTO DE RENDA'
      },
      {
        code: 3700,
        name: 'ACOMPANHAR METAS DE SOFTWARE LIVRE (SL)'
      },
      {
        code: 3701,
        name: 'RANKING DOS SITES INSTITUCIONAIS'
      },
      {
        code: 3704,
        name: 'ELABORAÇÃO DO PROJETO DE LEI DO PLANO PLURIANUAL'
      },
      {
        code: 3705,
        name: 'IMPLANTAÇÃO DE DECISÕES JUDICIAIS EM FOLHA DE PAGAMENTO'
      },
      {
        code: 3706,
        name: 'ELABORAÇÃO DO PROJETO DE LEI DA REVISÃO DO PPA'
      },
      {
        code: 3707,
        name: 'ELABORAÇÃO DE RELATÓRIOS DE MONITORAMENTO DO PPA'
      },
      {
        code: 3708,
        name: 'GESTÃO DA FOLHA DE PAGAMENTO DOS ÓRGÃOS/ENTIDADES'
      },
      {
        code: 3709,
        name: 'ELABORAÇÃO DO RELATÓRIO DE AVALIAÇÃO DO PPA'
      },
      {
        code: 3710,
        name: 'ELABORAÇÃO DA MENSAGEM DE GOVERNO'
      },
      {
        code: 3716,
        name: 'Assessoria na Doação de Equipamentos de TIC'
      },
      {
        code: 3719,
        name: 'ANALISAR E LIBERAR PARCELAS DE TIC'
      },
      {
        code: 3723,
        name: 'ELABORAÇÃO DE PROJETOS DE LEI DE CRÉDITOS ADICIONAIS ESPECIAIS'
      },
      {
        code: 3724,
        name: 'ELABORAÇÃO DE DECRETOS DE CRÉDITOS ADICIONAIS SUPLEMENTARES (ORDINÁRIO)'
      },
      {
        code: 3725,
        name: 'ELABORAÇÃO DE RELATÓRIOS BIMESTRAIS E SEMESTRAIS DA EXECUÇÃO ORÇAMENTÁRIA'
      },
      {
        code: 3727,
        name: 'ACOMPANHAMENTO E MONITORAMENTO DA EXECUÇÃO FINANCEIRA DOS RECURSOS DO GRUPO TESOURO'
      },
      {
        code: 3729,
        name: 'ASSESSORAMENTO DO COMITÊ DE GESTÃO POR RESULTADO E GESTÃO FISCAL NO PROCESSO DE ACOMPANHAMENTO E CONTROLE DA EXECUÇÃO FINANCEIRA'
      },
      {
        code: 3731,
        name: 'ASSESSORAMENTO AOS ÓRGÃOS E ENTIDADES DA ADMINISTRAÇÃO ESTADUAL NA GESTÃO DO CUSTEIO'
      },
      {
        code: 3732,
        name: 'ASSESSORAMENTO AOS ÓRGÃOS E ENTIDADES DA ADMINISTRAÇÃO ESTADUAL NO LEVANTAMENTO DOS CUSTOS DE EQUIPAMENTOS'
      },
      {
        code: 3737,
        name: 'TERCEIRIZAÇÃO'
      },
      {
        code: 3739,
        name: 'ASSISTÊNCIA AO COMITÊ DE GESTÃO POR RESULTADOS E GESTÃO FISCAL - COGERF'
      },
      {
        code: 3741,
        name: 'ESTABILIDADE'
      },
      {
        code: 3742,
        name: 'PRESTAR CONSULTORIA AOS ÓRGÃOS/ENTIDADES SOBRE A FOLHA DE PAGAMENTO'
      },
      {
        code: 3744,
        name: 'ASCENSÃO FUNCIONAL'
      },
      {
        code: 3746,
        name: 'ANÁLISE DE PROCESSO DE CONCESSÃO DE REFORMA A MILITARES - SUPSEC'
      },
      {
        code: 3747,
        name: 'CONCURSO PÚBLICO'
      },
      {
        code: 3748,
        name: 'CONTROLE DE ACUMULAÇÃO DE CARGOS NO ÂMBITO DO PODER EXECUTIVO'
      },
      {
        code: 3751,
        name: 'PORTAL DE CONCURSOS PÚBLICOS'
      },
      {
        code: 3753,
        name: 'CESSÃO DE SERVIDORES'
      },
      {
        code: 3754,
        name: 'TERMO DE COOPERAÇÃO TÉCNICA'
      },
      {
        code: 3756,
        name: 'PROGRAMA DE ESTÁGIO DE NÍVEL SUPERIOR'
      },
      {
        code: 3758,
        name: 'PROGRAMA DE ESTÁGIO DE NÍVEL MÉDIO'
      },
      {
        code: 3761,
        name: 'REPASSE DE METODOLOGIA DE REDESENHO DE PROCESSOS'
      },
      {
        code: 3766,
        name: 'ANÁLISE DE PROCESSO DE CONCESSÃO DE PENSÃO DO SUPSEC POR MORTE DE SEGURADO CIVIL'
      },
      {
        code: 3768,
        name: 'INCLUSÃO/ATUALIZAÇÃO DE MODELOS DE DOCUMENTOS NO SISTEMA EDOWEB'
      },
      {
        code: 3773,
        name: 'CADASTRAMENTO DE USUÁRIO COM PERFIL DE ADMINISTRADOR SETORIAL NO VIPROC'
      },
      {
        code: 3776,
        name: 'INCLUSÃO / ATUALIZAÇÃO DE ESTRUTURA ORGANIZACIONAL NO VIPROC'
      },
      {
        code: 3779,
        name: 'ANÁLISE DE PROCESSO DE APOSENTADORIA DO SUPSEC'
      },
      {
        code: 3784,
        name: 'REMANEJAMENTO/RESGATE DE PROCESSOS NO VIPROC'
      },
      {
        code: 3788,
        name: 'TREINAMENTO DE ADMINISTRADOR SETORIAL NO VIPROC'
      },
      {
        code: 3798,
        name: 'ELABORAÇÃO/ATUALIZAÇÃO DE ORGANOGRAMAS DO PODER EXECUTIVO ESTADUAL'
      },
      {
        code: 3799,
        name: 'INCLUSÃO/ATUALIZAÇÃO DE ESTRUTURA ORGANIZACIONAL NO SIGE-RH'
      },
      {
        code: 3800,
        name: 'ELABORAÇÃO DE MODELOS DE INSTRUMENTOS LEGAIS VOLTADOS À ESTRUTURAÇÃO ORGANIZACIONAL'
      },
      {
        code: 3801,
        name: 'ASSESSORAMENTO TÉCNICO EM DESENVOLVIMENTO DE PROJETOS DE ESTRUTURAÇÃO ORGANIZACIONAL'
      },
      {
        code: 3802,
        name: 'ANÁLISE DE PROJETO DE LEI DE CRIAÇÃO E EXTINÇÃO DE CARGOS EM COMISSÃO'
      },
      {
        code: 3818,
        name: 'GESTÃO E SUPORTE AO USUÁRIO NO USO DO SISTEMA DE AVALIAÇÃO NO MODELO DE EXCELÊNCIA EM GESTÃO PÚBLICA - MEGP'
      },
      {
        code: 3821,
        name: 'CESSÃO BENS MÓVEIS'
      },
      {
        code: 3822,
        name: 'TRANSFERÊNCIA PATRIMONIAL DE BENS MÓVEIS'
      },
      {
        code: 3824,
        name: 'CESSÃO DE IMÓVEIS'
      },
      {
        code: 3825,
        name: 'DOAÇÃO DE IMOVEIS'
      },
      {
        code: 3826,
        name: 'PERMISSÃO DE USO DE IMÓVEIS PÚBLICOS'
      },
      {
        code: 3827,
        name: 'PERMUTA DE BENS IMÓVEIS'
      },
      {
        code: 3828,
        name: 'ANÁLISE DE PROCESSOS DE USUCAPIÃO'
      },
      {
        code: 3829,
        name: 'MATRÍCULA DE ALUNOS'
      },
      {
        code: 3830,
        name: 'GESTÃO E SUPORTE NO ACESSO CIDADÃO'
      },
      {
        code: 3832,
        name: 'PROMOTOS ( PROGRAMA DE EDUCAÇÃO E DEFESA DA VIDA DOS CONDUTORES DE MOTOCICLETA E MOTONETAS QUE EXERCEM ATIVIDADE REMUNERADA)'
      },
      {
        code: 3834,
        name: 'CARTEIRA DE MOTORISTA POPULAR'
      },
      {
        code: 3835,
        name: 'REGISTRO DE ESTRANGEIRO.'
      },
      {
        code: 3849,
        name: 'RESTITUIÇÃO DE BENS APREENDIDOS.'
      },
      {
        code: 3851,
        name: 'CERTIDÃO DE DISTRIBUIÇÃO CÍVEL DE 1º GRAU'
      },
      {
        code: 3853,
        name: 'BUSCA DE INFORMAÇÕES DE PROCESSOS ANTIGOS'
      },
      {
        code: 3855,
        name: 'SERVIÇO DE PROTOCOLO ADMINISTRATIVO E JUDICIAL.'
      },
      {
        code: 3857,
        name: 'AUTORIZAÇÕES JUDICIAIS DIVERSAS PARA CRIANÇAS E ADOLESCENTES.'
      },
      {
        code: 3858,
        name: 'CERTIDÃO DE ANTECEDENTES CRIMINAIS (FOLHA CRIMINAL)DO 1º GRAU'
      },
      {
        code: 3859,
        name: 'LEILÕES.'
      },
      {
        code: 3860,
        name: 'TELEJUSTIÇA: SERVIÇO DE CONSULTAS PROCESSUAIS E ADMINISTRATIVAS.'
      },
      {
        code: 3861,
        name: 'FISCALIZAÇÃO DAS NORMAS DE PROTEÇÃO AOS DIREITOS DA CRIANÇA E DO ADOLESCENTE.'
      },
      {
        code: 3863,
        name: 'APOIO AO PETICIONAMENTO ELETRÔNICO DO PORTAL DE SERVIÇOS E-SAJ.'
      },
      {
        code: 3864,
        name: 'BOLETIM DIÁRIO DE PREÇOS'
      },
      {
        code: 3866,
        name: 'CONSULTA DE 2ª. VIA DE BOLETO BANCÁRIO'
      },
      {
        code: 3867,
        name: 'COMPARATIVO DE PREÇOS'
      },
      {
        code: 3868,
        name: 'COMPARATIVO DO ATACADO SEMANAL'
      },
      {
        code: 3869,
        name: 'RENOVAÇÃO DE LOCADORA DE VEÍCULOS'
      },
      {
        code: 3870,
        name: 'RESTITUIÇÃO DO ITCD'
      },
      {
        code: 3871,
        name: 'SÉRIE HISTÓRICA DE OFERTAS DE PRODUTOS'
      },
      {
        code: 3872,
        name: 'ARTERIOGRAFIA PULMONAR'
      },
      {
        code: 3873,
        name: 'ARTERIOGRAFIA DAS CARÓTIDAS'
      },
      {
        code: 3874,
        name: 'HISTÓRICO DE PREÇOS POR PRODUTO'
      },
      {
        code: 3875,
        name: 'ANÁLISE DE PROCESSO DE CONCESSÃO DE PENSÃO DO SUPSEC POR MORTE DE MILITAR'
      },
      {
        code: 3876,
        name: 'ESTATÍSTICAS DE VOLUME E VALOR DE HORTIGRANJEIROS NA CEASA/CE'
      },
      {
        code: 3881,
        name: 'ESTATÍSTICAS DE PRINCIPAIS PRODUTOS HORTIGRANJEIROS NA CEASA/CE'
      },
      {
        code: 3882,
        name: 'ESTATÍSTICAS DE COMERCIALIZAÇÃO NOS ENTREPOSTOS DA CEASA/CE'
      },
      {
        code: 3883,
        name: 'HANSENOLOGIA'
      },
      {
        code: 3884,
        name: 'DERMATOLOGIA PEDIÁTRICA'
      },
      {
        code: 3885,
        name: 'ONCOLOGIA CUTÂNEA CLÍNICA E CIRURGICA'
      },
      {
        code: 3886,
        name: 'DERMATOSES OCUPACIONAIS / ALERGIA'
      },
      {
        code: 3887,
        name: 'CIRURGIA DERMATOLÓGICA'
      },
      {
        code: 3888,
        name: 'FOTOTERAPIA / TERAPIA FOTODINÂMICA'
      },
      {
        code: 3889,
        name: 'REGULAMENTO PARA TRANSFERÊCIA (BOX, PEDRA ou MODULOS) CEASA-CE'
      },
      {
        code: 3890,
        name: 'CEASA NOS BAIRROS'
      },
      {
        code: 3898,
        name: 'ANÁLISE MICROBIOLÓGICA EM ALIMENTOS: ESCHERICHIA COLI'
      },
      {
        code: 3899,
        name: 'ANALISE MICROBIOLÓGICA: CONTAGEM DE ESTAFILOCOCOS COAGULASE POSITIVA'
      },
      {
        code: 3900,
        name: 'ANÁLISE MICROBIOLÓGICA EM DOMISSANITÁRIO: AVALIAÇÃO DA ATIVIDADE GERMICIDA'
      },
      {
        code: 3901,
        name: 'ANÁLISE MICROBIOLÓGICA: CONTAGEM DE PSEUDOMONAS AERUGINOSAS'
      },
      {
        code: 3902,
        name: 'ANÁLISE MICROBIOLÓGICA:CONTAGEM DE AERÓBIOS MESÓFILOS'
      },
      {
        code: 3905,
        name: 'NITRITO EM ÁGUA'
      },
      {
        code: 3906,
        name: 'PH EM ÁGUA'
      },
      {
        code: 3907,
        name: 'SÓDIO EM ÁGUA'
      },
      {
        code: 3908,
        name: 'SÓLIDOS DISSOLVIDOS EM ÁGUAS E EFLUENTES'
      },
      {
        code: 3909,
        name: 'SÓLIDOS EM SUSPENSÃO/EFLUENTES(FIXOS/TOTAIS)'
      },
      {
        code: 3910,
        name: 'SÓLIDOS SEDIMENTÁVEIS /EFLUENTES'
      },
      {
        code: 3911,
        name: 'SULFATOS EM ÁGUA/EFLUENTES'
      },
      {
        code: 3912,
        name: 'SULFETOS EM EFLUENTES'
      },
      {
        code: 3913,
        name: 'TEMPERATURA EM ÁGUA'
      },
      {
        code: 3914,
        name: 'TURBIDEZ EM ÁGUA'
      },
      {
        code: 3915,
        name: 'FERRO TOTAL EM ÁGUA'
      },
      {
        code: 3920,
        name: 'ANÁLISE DE PROCESSO DE CONCESSÃO DE RESERVA A MILITARES - SUPSEC'
      },
      {
        code: 3923,
        name: 'TOLERÂNCIA DE PARTÍCULAS LAMELARES PARA LASTRO PADRÃO'
      },
      {
        code: 3928,
        name: 'RESISTÊNCIA A COMPRESSÃO UNIAXIAL EM ROCHAS'
      },
      {
        code: 3929,
        name: 'ANÁLISE FÍSICO-QUÍMICO EM ALIMENTOS:TESTE DE ÉBER (RANCIDEZ)'
      },
      {
        code: 3932,
        name: 'ANÁLISE FÍSICO-QUÍMICA EM ALIMENTOS: CARBOIDRATOS TOTAIS'
      },
      {
        code: 3934,
        name: 'DETERMINAÇÃO DE SÓLIDOS TOTAIS'
      },
      {
        code: 3937,
        name: 'DETERMINAÇÃO DE VITAMINA C'
      },
      {
        code: 3941,
        name: 'ANÁLISE FÍSICO-QUÍMICA: ÍNDICE DE REFRAÇÃO'
      },
      {
        code: 3942,
        name: 'ANAL. FÍSICO – QUÍMICO EM ALIMENTOS: NITRITO (QUALITATIVO)'
      },
      {
        code: 3945,
        name: 'TEOR ALCOÓLICO EM ÁLCOOL'
      },
      {
        code: 3948,
        name: 'ANÁLISE DE LÍTIO'
      },
      {
        code: 3949,
        name: 'AVALIAÇÃO DE CARACTERÍSTICAS ORGANOLÉPTICAS'
      },
      {
        code: 3950,
        name: 'CINZAS (RESÍDUO MINERAL FIXO)'
      },
      {
        code: 3951,
        name: 'UMIDADE E VOLÁTEIS EM LCC E OUTROS.'
      },
      {
        code: 3960,
        name: 'Restituição de custas judiciais'
      },
      {
        code: 3962,
        name: 'Certidão de Tempo de Serviço'
      },
      {
        code: 3963,
        name: 'CERTIDÃO DE ANTECEDENTES CRIMINAIS DE SEGUNDO GRAU'
      },
      {
        code: 3964,
        name: 'SÍLICA EM ÁGUA'
      },
      {
        code: 3965,
        name: 'SÓLIDOS EM SUSPENSÃO/EFLUENTES'
      },
      {
        code: 3967,
        name: 'DENSIDADE EM LODO DE ESTAÇÃO DE TRATAMENTO DE ÁGUA/ESGOTO'
      },
      {
        code: 3970,
        name: 'ORTOFOSFATO SOLÚVEL'
      },
      {
        code: 3972,
        name: 'UMIDADE EM IODO DE ETE – ESTAÇÃO DE TRATAMENTO DE ESGOTO OU ETA – ESTAÇÃO DE TRATAMENTO DE ÁGUA.'
      },
      {
        code: 3973,
        name: 'ÁGUA: POTABILIDADE/ EFLUENTES/ IRRIGAÇÃO/ SISTEMA DE REFRIGERAÇÃO/ CONCRETO/ PSICULT'
      },
      {
        code: 3977,
        name: 'Atendimento ao cidadão'
      },
      {
        code: 3979,
        name: 'DBO EM ÁGUA/EFLUENTES'
      },
      {
        code: 3982,
        name: 'CONSULTA DE URGÊNCIA / EMERGÊNCIA - CAPITAL'
      },
      {
        code: 3991,
        name: 'CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE CIÊNCIAS DA SAÚDE - CCS'
      },
      {
        code: 3993,
        name: 'CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE EDUCAÇÃO - CED'
      },
      {
        code: 3994,
        name: 'CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE ESTUDOS SOCIAIS APLICADOS - CESA'
      },
      {
        code: 3995,
        name: 'CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE CIÊNCIAS E TECNOLOGIAS - CCT'
      },
      {
        code: 3996,
        name: 'CURSOS DE ESPECIALIZAÇÃO DO CENTRO DE HUMANIDADES - CH'
      },
      {
        code: 3997,
        name: 'Programa de Pós-Graduação Ciências Veterinárias'
      },
      {
        code: 3999,
        name: 'Programa de Pós-Graduação em Educação'
      },
      {
        code: 4001,
        name: 'Programa de Pós-Graduação em Saúde Coletiva'
      },
      {
        code: 4004,
        name: 'Programa de Pós-Graduação em Geografia'
      },
      {
        code: 4005,
        name: 'Programa de Pós-Graduação em Ciências Fisiológicas'
      },
      {
        code: 4006,
        name: 'Programa de Pós-Graduação em Administração'
      },
      {
        code: 4007,
        name: 'Programa de Pós-Graduação em Ciência da Computação'
      },
      {
        code: 4008,
        name: 'Programa de Pós-Graduação em Nutrição e Saúde'
      },
      {
        code: 4010,
        name: 'Programa de Pós-Graduação em Ciências Físicas Aplicadas'
      },
      {
        code: 4011,
        name: 'PROGRAMA DE PÓS GRADUAÇÃO EM SOCIOLOGIA'
      },
      {
        code: 4012,
        name: 'Programa de Pós-Graduação em Filosofia'
      },
      {
        code: 4013,
        name: 'Programa de Pós-Graduação em História e Culturas'
      },
      {
        code: 4014,
        name: 'Programa de Pós-Graduação em Serviço Social, Trabalho e Questão Social'
      },
      {
        code: 4015,
        name: 'Programa de Pós-Graduação em Recursos Naturais'
      },
      {
        code: 4016,
        name: 'Programa de Pós-Graduação INTERCAMPI EM EDUCAÇÃO E ENSINO'
      },
      {
        code: 4018,
        name: 'MESTRADO PROFISSIONAL EM ENSINO NA SAÚDE'
      },
      {
        code: 4019,
        name: 'Programa de Pós-Graduação em Gestão de Negócios Turísticos'
      },
      {
        code: 4020,
        name: 'MESTRADO PROFISSIONAL EM PLANEJAMENTO E POLÍTICAS PÚBLICAS'
      },
      {
        code: 4022,
        name: 'Programa de Pós-Graduação em Saúde da Família'
      },
      {
        code: 4023,
        name: 'Mestrado Profissional em Letras (em Rede Nacional) PROFLETRAS'
      },
      {
        code: 4024,
        name: 'Mestrado Profissional em Matemática (em Rede Nacional) PROFMAT'
      },
      {
        code: 4025,
        name: 'Programa de Pós-Graduação em Biotecnologia em Saúde Humana e Animal'
      },
      {
        code: 4027,
        name: 'CADASTRO DE PARTICIPANTE DA CAMPANHA SUA NOTA VALE DINHEIRO'
      },
      {
        code: 4028,
        name: 'CONSULTA DE DADOS DO PARTICIPANTE DA CAMPANHA SUA NOTA VALE DINHEIRO'
      },
      {
        code: 4029,
        name: 'CONSULTA DE CRÉDITOS DA CAMPANHA SUA NOTA VALE DINHEIRO'
      },
      {
        code: 4030,
        name: 'INFORMAÇÕES SOBRE A DIGITAÇÃO DE DOCUMENTOS ON-LINE DA CAMPANHA SUA NOTA VALE DINHEIRO'
      },
      {
        code: 4031,
        name: 'LOCALIZAÇÃO DAS URNAS DA CAMPANHA SUA NOTA VALE DINHEIRO'
      },
      {
        code: 4032,
        name: 'CPE - COMPLEXO POLIESPORTIVO'
      },
      {
        code: 4034,
        name: 'ATENDIMENTO EMERGENCIAL ÀS FAMÍLIAS VÍTIMAS DE DESASTRES.'
      },
      {
        code: 4038,
        name: 'CADASTRO/ACESSO DE USUÁRIO NOS SISTEMAS CORPORATIVOS (ORÇAMENTÁRIOS, FINANCEIROS, RECURSOS HUMANOS)'
      },
      {
        code: 4042,
        name: 'TREINAMENTO NOS SISTEMAS CORPORATIVOS'
      },
      {
        code: 4044,
        name: 'TESTE'
      },
      {
        code: 4045,
        name: 'COMISSÃO EXECUTIVA DO VESTIBULAR - CEV'
      },
      {
        code: 4049,
        name: 'ACOMPANHAMENTO E MANUTENÇÃO DE DEPÓSITO DE PEDIDO DE PATENTE.'
      },
      {
        code: 4050,
        name: 'ATENDIMENTO OPERACIONAL AOS SISTEMAS CORPORATIVOS'
      },
      {
        code: 4051,
        name: 'ATENDIMENTO A FORNECEDORES (S2GPR) E EMPRESAS TERCEIRIZADAS (SISTER)'
      },
      {
        code: 4055,
        name: 'Assessoria na contratação de Contratos de Gestão e seus aditivos'
      },
      {
        code: 4056,
        name: 'ASSESSORIA NA EXECUÇÃO DE CONTRATOS DE GESTÃO E SEUS ADITIVOS.'
      },
      {
        code: 4058,
        name: 'Assessoria na contratação de operações de crédito'
      },
      {
        code: 4059,
        name: 'PRESERVAR DOCUMENTAÇÃO E INFORMAÇÃO INSTITUCIONAL'
      },
      {
        code: 4061,
        name: 'Executar registros de atos e fatos contábeis/emitir balanços e demonstrativos contábeis'
      },
      {
        code: 4062,
        name: 'Assessoria na execução de operações de crédito'
      },
      {
        code: 4063,
        name: 'Assessoria na contratação de projetos de Parcerias Público-Privadas'
      },
      {
        code: 4064,
        name: 'Assessoria na execução de projetos de Parcerias Público-Privadas'
      },
      {
        code: 4065,
        name: 'CONTROLAR OS SUPRIMENTOS DE FUNDOS, REALIZAR SUA PRESTAÇÃO DE CONTAS E ENVIAR OS RELATÓRIOS À DIREÇÃO SUPERIOR PARA ANÁLISE E DIRECIONAMENTO'
      },
      {
        code: 4066,
        name: 'Administrar e coordenar os processos seletivos conforme a legislação vigente'
      },
      {
        code: 4067,
        name: 'CAPACITAÇÃO DA REDE DE GESTORES PATRIMONIAIS'
      },
      {
        code: 4069,
        name: 'EXECUTAR, ACOMPANHAR E CONTROLAR AS ATIVIDADES INERENTES AOS ESTAGIÁRIOS DE NÍVEL MÉDIO E SUPERIOR'
      },
      {
        code: 4070,
        name: 'ATENDIMENTO AO SERVIDOR SOBRE CONSULTA DA SUA MARGEM CONSIGNÁVEL.'
      },
      {
        code: 4071,
        name: 'ASSESSORAMENTO AOS ÓRGÃOS E ENTIDADES DA ADMINISTRAÇÃO ESTADUAL NAS METODOLOGIAS, PROCESSOS E SISTEMAS DE GERENCIAMENTO DE PROJETOS'
      },
      {
        code: 4072,
        name: 'ELABORAÇÃO E ACOMPANHAMENTO DE TODO O PROCESSO DE CONTRATAÇÃO DE BENS E SERVIÇOS DA SEPLAG'
      },
      {
        code: 4073,
        name: 'consulta, acompanhamento e arquivamento das publicações referentes à SEPLAG, em DOE'
      },
      {
        code: 4075,
        name: 'CONTROLE E ACOMPANHAMENTO DOS CONTRATOS E CONVÊNIOS REFERENTES À SEPLAG'
      },
      {
        code: 4076,
        name: 'ACOMPANHAMENTO DE PROJETOS DURANTE SUA EXECUÇÃO FÍSICA/FINANCEIRA.'
      },
      {
        code: 4077,
        name: 'ENVIO DAS PÚBLICAÇÕES E CÓPIAS DOS CONTRATOS E CONVÊNIOS REFERENTES À SEPLAG, TANTO PARA O TCE, COMO PARA A AL'
      },
      {
        code: 4078,
        name: 'GERENCIAMENTO DO ARQUIVO E CONTROLE DOS BENS MÓVEIS E IMÓVEIS'
      },
      {
        code: 4079,
        name: 'gestão do protocolo e malote (entrada e movimentação dos documentos)'
      },
      {
        code: 4080,
        name: 'SUBSIDIAMENTO A PESQUISA SOBRE APOSENTADORIA E ENVELHECIMENTO.'
      },
      {
        code: 4081,
        name: 'MONITORAMENTO E GESTÃO DOS PROCESSOS DE COTAÇÃO ELETRÔNICA, DE INTERESSE DA SEPLAG E ENVIO, VIA S2GPR, PARA A SEFAZ'
      },
      {
        code: 4082,
        name: 'ORIENTAÇÃO AOS ÓRGÃOS E ENTIDADES NA ELABORAÇÃO DE PROPOSTAS DE PROJETOS FINALÍSTICOS E NA PROGRAMAÇÃO OPERATIVA ANUAL'
      },
      {
        code: 4084,
        name: 'CONSULTA À LEGISLAÇÃO DE COMPRAS'
      },
      {
        code: 4085,
        name: 'CONSULTA ÀS LICITAÇÕES E CONTRATAÇÕES DIRETAS PUBLICADAS NO PORTAL DE COMPRAS'
      },
      {
        code: 4086,
        name: 'DIVULGAÇÃO DAS LICITAÇÕES E CONTRATAÇÕES DIRETAS POR MEIO DO SISTEMA LICITAWEB'
      },
      {
        code: 4087,
        name: 'CONSULTA À SITUAÇÃO CADASTRAL DO FORNECEDOR E EMISSÃO DE CERTIFICADO DE REGISTRO CADASTRAL (CRC)'
      },
      {
        code: 4088,
        name: 'INSCRIÇÃO NO CADASTRO DE FORNECEDORES DO ESTADO'
      },
      {
        code: 4089,
        name: 'ADESÃO A REGISTROS DE PREÇOS EXTERNOS'
      },
      {
        code: 4090,
        name: 'CONSULTA AO CATÁLOGO DE BENS, MATERIAIS E SERVIÇOS'
      },
      {
        code: 4091,
        name: 'CONSULTA ÀS ATAS DE REGISTRO DE PREÇOS NO PORTAL DE COMPRAS'
      },
      {
        code: 4092,
        name: 'COMPRAS E CONTRATAÇÕES POR MEIO DE COTAÇÃO ELETRÔNICA'
      },
      {
        code: 4094,
        name: 'ATENDIMENTO PREVIDENCIÁRIO RELATIVO AO SUPSEC'
      },
      {
        code: 4095,
        name: 'ANÁLISE DE PROJETOS DO FUNDO ESTADUAL DE COMBATE À POBREZA – FECOP'
      },
      {
        code: 4096,
        name: 'ELABORAÇÃO DO RELATÓRIO FINANCEIRO TRIMESTRAL DO FUNDO ESTADUAL DE COMBATE À POBREZA - FECOP.'
      },
      {
        code: 4097,
        name: 'ANÁLISE DE SOLICITAÇÃO DE LIBERAÇÃO DE PARCELAS FINANCEIRAS, DO FUNDO ESTADUAL DE COMBATE À POBREZA - FECOP.'
      },
      {
        code: 4098,
        name: 'ACESSO AO RELATÓRIO DE DESEMPENHO DA GESTÃO, DO FUNDO ESTADUAL DE COMBATE À POBREZA – FECOP.'
      },
      {
        code: 4108,
        name: 'ADESÃO AO PROGRAMA GARANTIA SAFRA'
      },
      {
        code: 4109,
        name: 'PROJETO PAIS - PRODUÇÃO AGROECOLÓGICO INTEGRADA E SUSTENTÁVEL'
      },
      {
        code: 4112,
        name: 'CERTIDÃO POR TEMPO DE SERVIÇO'
      },
      {
        code: 4115,
        name: 'DOAÇÃO DE ALIMENTOS PARA ENTIDADES SÓCIOASSISTENCIAIS EM ATENDIMENTO AO PROGRAMA DE AQUISIÇÃO DE ALIMENTOS – MOD COMPRA COM DOAÇÃO SIMULTÂNEA'
      },
      {
        code: 4116,
        name: 'ADESÃO DE BENEFICIÁRIO CONSUMIDOR AO PAA-LEITE'
      },
      {
        code: 4117,
        name: 'AQUISIÇÃO DE LEITE BOVINO E CAPRINO DE AGRICULTORES FAMILIARES PARA O PAA-LEITE.'
      },
      {
        code: 4118,
        name: 'DOAÇÃO DE GÊNEROS ALIMENTÍCIOS PARA ENTIDADES SÓCIOASSISTENCIAIS EM ATENDIMENTO AO PAA-LEITE'
      },
      {
        code: 4596,
        name: 'EXPEDIÇÃO DE DIPLOMA 2º VIA'
      },
      {
        code: 4119,
        name: 'CONTRATAÇÃO DE LATICÍNIOS E/OU COOPERATIVAS PARA PRESTAÇÃO DE SERVIÇOS AO PAA-LEITE.'
      },
      {
        code: 4120,
        name: 'APOIO A SISTEMAS DE AQUISIÇÕES INSTITUCIONAIS DA AGRICULTURA FAMILIAR (COMPRAS GOVERNAMENTAIS)'
      },
      {
        code: 4121,
        name: 'FINANCIAMENTO DE ATIVIDADES PRODUTIVAS ATRAVÉS DE RECURSOS DO FUNDO ESTADUAL DE DESENVOLVIMENTO DA AGRICULTURA FAMILIAR - FEDAF'
      },
      {
        code: 4122,
        name: 'PERMISSÃO DE USO DE MOTO ENSILADEIRAS'
      },
      {
        code: 4123,
        name: 'PROJETO DE IRRIGAÇÃO NA MINHA PROPRIEDADE - PIMP'
      },
      {
        code: 4124,
        name: 'CONTRATAÇÃO DE FORNECEDORES DE MANIVAS SEMENTE DE MANDIOCA PARA O PROJETO “HORA DE PLANTAR”'
      },
      {
        code: 4125,
        name: 'CONTRATAÇÃO DE FORNECEDORES DE PALMA FORRAGEIRA PARA O PROJETO “HORA DE PLANTAR”'
      },
      {
        code: 4126,
        name: 'ELABORAÇÃO DE TERMO DE REFERÊNCIA'
      },
      {
        code: 4127,
        name: 'REGISTRO DE MANIFESTAÇÕES, SOLICITAÇÕES DE INFORMAÇÕES.'
      },
      {
        code: 4128,
        name: 'DESENVOLVIMENTO DA CADEIA PRODUTIVA DA BOVINOCULTURA LEITEIRA'
      },
      {
        code: 4129,
        name: 'DESENVOLVIMENTO DA CADEIA PRODUTIVA DA OVINOCAPRINOCULTURA'
      },
      {
        code: 4130,
        name: 'CONTRATAÇÃO DE FORNECEDORES DE MUDAS DE ESSÊNCIAS FLORESTAIS NATIVAS E EXÓTICAS E CAJUEIRO PRECOCE PARA O PROJETO “HORA DE PLANTAR”'
      },
      {
        code: 4131,
        name: 'APOIO TÉCNICO E FINANCEIRO AOS MUNICÍPIOS PARA EXECUÇÃO DE OBRAS DE ESTRUTURAÇÃO E REQUALIFICAÇÃO DE ABATEDOUROS/MATADOUROS PÚBLICOS'
      },
      {
        code: 4132,
        name: 'HABITAÇÕES RURAIS NAS ÁREAS DO PROGRAMA NACIONAL DO CRÉDITO FUNDIÁRIO - PNCF'
      },
      {
        code: 4136,
        name: 'PROJETOS PILOTO DE REAPROVEITAMENTO DA ÁGUA (REÚSO DE ÁGUAS CINZA): UNIDADE DE GERENCIAMENTO DO PROJETO DE DESENVOLVIMENTO RURAL SUSTENTÁVEL'
      },
      {
        code: 4137,
        name: 'ACOMPANHAMENTO DE PROCESSOS LICITATÓRIOS.'
      },
      {
        code: 4138,
        name: 'TRANSMISSÕES DAS LICITAÇÕES PRESENCIAIS.'
      },
      {
        code: 4139,
        name: 'MODELOS DE EDITAIS DE LICITAÇÕES – MODALIDADE PREGÃO'
      },
      {
        code: 4140,
        name: 'CONSULTA DE DOCUMENTOS DIGITALIZADOS DOS PREGÕES ELETRÔNICOS'
      },
      {
        code: 4142,
        name: 'INFORMAÇÃO SOBRE ESTUDOS DE RECUPERAÇÃO'
      },
      {
        code: 4143,
        name: 'COMUNICAÇÃO DE MUDANÇA DE DENOMINAÇÃO DE INSTITUIÇÃO DE ENSINO'
      },
      {
        code: 4144,
        name: 'COMUNICAÇÃO DE ENCERRAMENTO DE ATIVIDADES'
      },
      {
        code: 4145,
        name: 'COMUNICAÇÃO DE MUDANÇA DE MANTENEDOR DE INSTITUIÇÃO DE ENSINO'
      },
      {
        code: 4146,
        name: 'ASSINATURA DO BOLETIM INFORMATIVO "CGE NOTÍCIAS"'
      },
      {
        code: 4147,
        name: 'PERÍCIA DE EFICIÊNCIA EM COLETES BALÍSTICOS'
      },
      {
        code: 4148,
        name: 'AUTORIZAÇÃO PARA OFERTAR ESPECIALIZAÇÃO TÉCNICA DE NÍVEL MÉDIO'
      },
      {
        code: 4149,
        name: 'AUTORIZAÇÃO PARA OFERTA DE CURSOS TÉCNICOS OU ESPECIALIZAÇÃO TÉCNICA DE NÍVEL MÉDIO FORA DE SEDE'
      },
      {
        code: 4150,
        name: 'AGENTE INTELIGENTE PARA IRREGULARIDADE DE PARCEIROS'
      },
      {
        code: 4151,
        name: 'AGENTE INTELIGENTE PARA INADIMPLÊNCIA DE PARCEIROS'
      },
      {
        code: 4152,
        name: 'AGENTE INTELIGENTE PARA INTEGRAÇÃO COM A CAIXA ECONÔMICA'
      },
      {
        code: 4153,
        name: 'PERÍCIA INDIRETA - ANÁLISE DE FOTOS E OBJETOS.'
      },
      {
        code: 4154,
        name: 'PERÍCIA INDIRETA - ANÁLISE DE FOTOS E OBJETOS'
      },
      {
        code: 4155,
        name: 'MOBILIZAÇÃO SOCIAL'
      },
      {
        code: 4156,
        name: 'DESAPROPRIAÇÃO'
      },
      {
        code: 4157,
        name: 'REASSENTAMENTO'
      },
      {
        code: 4158,
        name: 'ACUMULAÇÃO E TRANSFERÊNCIA HÍDRICA'
      },
      {
        code: 4159,
        name: 'ATIVIDADES HIDROGEOLÓGICAS E PROGRAMA ÁGUA DOCE'
      },
      {
        code: 4160,
        name: 'RECURSO À NEGATIVA DE INFORMAÇÃO'
      },
      {
        code: 4161,
        name: 'CONTROLE E GESTÃO AMBIENTAL'
      },
      {
        code: 4162,
        name: 'CLASSIFICAÇÃO DE INFORMAÇÃO SIGILOSA'
      },
      {
        code: 4163,
        name: 'PARTICIPAÇÃO EM REUNIÕES TÉCNICAS'
      },
      {
        code: 4164,
        name: 'REAVALIAÇÃO DE INFORMAÇÃO SECRETA E ULTRASSECRETA'
      },
      {
        code: 4165,
        name: 'INFORMAÇÃO AO CIDADÃO'
      },
      {
        code: 4166,
        name: 'AUTORIZAÇÃO PARA TRANSFERÊNCIA DE VEÍCULOS BLINDADOS DE PESSOA FÍSICA'
      },
      {
        code: 4170,
        name: 'IMPLEMENTAÇÃO DA CASA DA MULHER BRASILEIRA'
      },
      {
        code: 4172,
        name: 'ANALISAR CUSTOS DE BENS, OBRAS E SERVIÇOS DE INFRAESTRUTURA HÍDRICA'
      },
      {
        code: 4173,
        name: 'CENTRO DE REFERÊNCIA DE DIREITOS HUMANOS'
      },
      {
        code: 4174,
        name: 'Unidades Móveis de Atendimento às Mulheres do Campo, Floresta e Águas'
      },
      {
        code: 4175,
        name: 'ELABORAÇÃO DE EDITAIS DE LICITAÇÃO'
      },
      {
        code: 4176,
        name: 'SERVIÇO DE ASSESSORIA JURÍDICA POPULAR E ATENDIMENTO PSICOSSOCIAL'
      },
      {
        code: 4177,
        name: 'DENÚNCIA DE VIOLAÇÃO DE DIREITOS HUMANOS NAS UNIDADES DO SISTEMA SOCIOEDUCATIVO DO ESTADO DO CEARÁ'
      },
      {
        code: 4178,
        name: 'Campanha de abrangência Estadual pelo Enfrentamento à Violência contra as mulheres'
      },
      {
        code: 4179,
        name: 'Fórum do Campo da Floresta e das Águas'
      },
      {
        code: 4180,
        name: 'Grupo de Trabalho Segurança Pública para as Mulheres (GT das Delegadas)'
      },
      {
        code: 4181,
        name: 'CAPACITAÇÃO SOBRE ELABORAÇÃO DE PLANOS MUNICIPAIS DE PROMOÇÃO DA IGUALDADE RACIAL'
      },
      {
        code: 4182,
        name: 'CAPACITAÇÃO SOBRE CRIAÇÃO DE CONSELHOS MUNICIPAIS DE PROMOÇÃO DA IGUALDADE RACIAL.'
      },
      {
        code: 4183,
        name: 'COMISSÃO DE ENFRENTAMENTO AO TRABALHO ESCRAVO DO ESTADO DO CEARÁ'
      },
      {
        code: 4184,
        name: 'OUVIDORIA'
      },
      {
        code: 4185,
        name: 'ACOMPANHAMENTO DE CASOS DE CONFLITOS FUNDIÁRIOS, URBANOS E RURAIS, NO ESTADO DO CEARÁ'
      },
      {
        code: 4186,
        name: 'ELABORAR A POLÍTICA ESTADUAL DE MEMÓRIA DO ESTADO DO CEARÁ'
      },
      {
        code: 4187,
        name: 'EQUIVALENCIA DE ESTUDOS REALIZADOS EM OUTROS PAÍSES. PARA ALUNOS ESTRANGEIROS E BRASILEIROS.'
      },
      {
        code: 4188,
        name: 'CONSULTORIA GERAL'
      },
      {
        code: 4189,
        name: 'EXAME DE VERIFICAÇÃO DE EDIÇÃO EM IMAGENS'
      },
      {
        code: 4190,
        name: 'EXAME DE VERIFICAÇÃO DE EDIÇÃO EM ÁUDIO'
      },
      {
        code: 4191,
        name: 'EXAME DE MÁQUINAS, MOTORES, DISPOSITIVOS MECÂNICOS, ELÉTRICOS, ELETRO-MECÂNICO E OBJETOS EM GERAL'
      },
      {
        code: 4192,
        name: 'PERÍCIA EM MEIO AMBIENTE'
      },
      {
        code: 4193,
        name: 'EXAME DE LESÃO CORPORAL - MARCAS DE MORDIDA'
      },
      {
        code: 4194,
        name: 'CREDENCIAMENTO NA ÁREA DE SAÚDE'
      },
      {
        code: 4195,
        name: 'TRATAMENTO DE ÁUDIO.'
      },
      {
        code: 4196,
        name: 'PROCADIN'
      },
      {
        code: 4197,
        name: 'PROCADIN'
      },
      {
        code: 4198,
        name: 'PROCADIN'
      },
      {
        code: 4199,
        name: 'PROCADIN'
      },
      {
        code: 4200,
        name: 'EXAME DE TRATAMENTO DE IMAGENS.'
      },
      {
        code: 4201,
        name: 'EXAME DE CONVERSÃO DE ARQUIVOS'
      },
      {
        code: 4202,
        name: 'EXAME DE CONVERSÃO DE ARQUIVOS'
      },
      {
        code: 4204,
        name: 'EXAME DE CONVERSÃO DE ARQUIVOS'
      },
      {
        code: 4206,
        name: 'EXAME DE CONVERSÃO DE ARQUIVOS.'
      },
      {
        code: 4209,
        name: 'NÚCLEO DE ENFRENTAMENTO AO TRÁFICO DE PESSOAS (NETP)'
      },
      {
        code: 4210,
        name: 'EXAME DE EXTRAÇÃO DE ARQUIVOS DE APARELHOS ELETRÔNICOS.'
      },
      {
        code: 4211,
        name: 'EXAME EM IMAGENS DOS LOCAIS DE CRIME E ACIDENTE DE TRANSITO.'
      },
      {
        code: 4212,
        name: 'EXAME DE FOTOGRAMETRIA.'
      },
      {
        code: 4213,
        name: 'CONSELHO ESTADUAL DE DEFESA DOS DIREITOS HUMANOS'
      },
      {
        code: 4214,
        name: 'Comissão Especial de Anistia Wanda Rita Othon Sidou'
      },
      {
        code: 4215,
        name: 'CRIAÇÃO DE UNIDADE DE CONSERVAÇÃO (UC)'
      },
      {
        code: 4216,
        name: 'ABERTURA DE MICROEMPREENDEDOR INDIVIDUAL - MEI UNIDADE MÓVEL DE EMPREENDEDORISMO'
      },
      {
        code: 4217,
        name: 'CASA DO CIDADÃO BENFICA - CCBENFICA'
      },
      {
        code: 4221,
        name: 'BALCÃO DA CIDADANIA - SEJUS'
      },
      {
        code: 4222,
        name: 'VISITA AS(OS) PRESAS(OS)'
      },
      {
        code: 4224,
        name: 'VISITAS - IPF'
      },
      {
        code: 4225,
        name: 'VISITAS - CPPL 3'
      },
      {
        code: 4226,
        name: 'VISITAS - CPPL 1'
      },
      {
        code: 4227,
        name: 'VISITAS - CPPL 2'
      },
      {
        code: 4228,
        name: 'VISITAS - IPPOO 2'
      },
      {
        code: 4229,
        name: 'VISITAS - HSPOL'
      },
      {
        code: 4230,
        name: 'VISITAS - IPGSG'
      },
      {
        code: 4231,
        name: 'SERVIÇO SOCIAL - CPPL 3'
      },
      {
        code: 4232,
        name: 'CURSO PARA AGENTES MULTIPLICADORES EM EDUCAÇÃO AMBIENTAL'
      },
      {
        code: 4233,
        name: 'SERVIÇO SOCIAL - CPPL 1'
      },
      {
        code: 4234,
        name: 'CURSO DE FORMAÇÃO DE EDUCADORES AMBIENTAIS'
      },
      {
        code: 4235,
        name: 'SERVIÇO SOCIAL - IPPOO II'
      },
      {
        code: 4236,
        name: 'CURSO DE GESTÃO AMBIENTAL MUNICIPAL'
      },
      {
        code: 4237,
        name: 'SERVIÇO SOCIAL - IPF'
      },
      {
        code: 4239,
        name: 'CASA DO CIDADÃO DA ASSEMBLEIA LEGISLATIVA DO CEARÁ - CCALCE'
      },
      {
        code: 4241,
        name: 'SERVIÇO SOCIAL - HSPOL'
      },
      {
        code: 4242,
        name: 'CARTEIRA RELIGIOSA'
      },
      {
        code: 4243,
        name: 'CADASTRAMENTO DA IGREJA'
      },
      {
        code: 4248,
        name: 'REPÓRTER TVC'
      },
      {
        code: 4249,
        name: 'PALESTRAS'
      },
      {
        code: 4250,
        name: 'FORNECIMENTO DE MATERIAL EDUCATIVO'
      },
      {
        code: 4251,
        name: 'CAMPANHA FESTA ANUAL DAS ÁRVORES'
      },
      {
        code: 4252,
        name: 'CAMPANHA SEMANA DO MEIO AMBIENTE'
      },
      {
        code: 4253,
        name: 'CAMPANHA DIA NACIONAL DE LIMPEZA DE PRAIAS, RIOS, LAGOS E LAGOAS'
      },
      {
        code: 4254,
        name: 'OFICINA DE ARTE-EDUCAÇÃO AMBIENTAL'
      },
      {
        code: 4255,
        name: 'PLANTANDO O AMANHÃ.'
      },
      {
        code: 4257,
        name: 'NÚCLEO DE CADASTRO DE VISITANTES- NUCAV'
      },
      {
        code: 4259,
        name: 'AGENDA AMBIENTAL NA ADMINISTRAÇÃO PÚBLICA - A3P'
      },
      {
        code: 4260,
        name: 'CONTROLADORIA E OUVIDORIA GERAL DO ESTADO- CGE'
      },
      {
        code: 4261,
        name: 'SEBRAE: SERVIÇO DE APOIO ÀS MICRO E PEQUENAS EMPRESAS DO ESTADO DO CEARÁ'
      },
      {
        code: 4262,
        name: 'UNIDADE VAPT VUPT -'
      },
      {
        code: 4263,
        name: 'PERÍCIA FORENSE DO ESTADO DO CEARÁ - PEFOCE - NAS UNIDADES DO VAPT VUPT.'
      },
      {
        code: 4264,
        name: 'E - VAPT VUPT'
      },
      {
        code: 4265,
        name: 'DEFENSORIA PÚBLICA GERAL DO ESTADO DO CEARÁ - DPGE - NA UNIDADE DO VAPT VUPT.'
      },
      {
        code: 4266,
        name: 'ARCE'
      },
      {
        code: 4267,
        name: 'PROJETO JUVENTUDE EMPREENDEDORA- JUVEMP'
      },
      {
        code: 4269,
        name: 'PROJETO EMPREENDEDOR JUVENIL'
      },
      {
        code: 4270,
        name: 'PÓLOS DE CONVIVÊNCIA E FORTALECIMENTO DE VÍNCULOS SOCIAIS (ABCS, CIRCOS ESCOLAS E CIP´S)'
      },
      {
        code: 4271,
        name: 'FISCALIZAÇÃO DOS SERVIÇOS DE GERAÇÃO DE ENERGIA ELÉTRICA'
      },
      {
        code: 4272,
        name: 'COFINANCIAMENTO DE BENEFÍCIOS EVENTUAIS PARA FAMÍLIAS E PESSOAS EM SITUAÇÃO DE VULNERABILIDADE SOCIAL - BE'
      },
      {
        code: 4273,
        name: 'CAGECE - UNIDADE VAPT VUPT'
      },
      {
        code: 4274,
        name: 'ESPAÇO VIVA GENTE'
      },
      {
        code: 4275,
        name: 'SECRETARIA DA FAZENDA - SEFAZ - NAS UNIDADES DO VAPT VUPT ANTONIO BEZERRA E MESSEJANA.'
      },
      {
        code: 4276,
        name: 'CENTROS COMUNITÁRIOS - (FAMÍLIAS – DESAFIOS E INCLUSÃO SOCIAL)'
      },
      {
        code: 4277,
        name: 'JUNTA COMERCIAL DO CEARÁ – JUCEC'
      },
      {
        code: 4278,
        name: 'CADASTRAMENTO DE ARTESÃOS E CREDENCIAMENTO DE ENTIDADES ARTESANAIS'
      },
      {
        code: 4279,
        name: 'CAPACITAÇÃO TECNOLÓGICA E DE GESTÃO EMPREENDEDORA'
      },
      {
        code: 4280,
        name: 'MESMAS DAS PERÍCIAS REALIZADAS PELOS NÚCLEOS DE FORTALEZA'
      },
      {
        code: 4281,
        name: 'MESMOS DAS PERÍCIAS REALIZADAS PELOS NÚCLEOS DE FORTALEZA'
      },
      {
        code: 4282,
        name: 'MESMO DAS PERÍCIAS REALIZADAS PELOS NÚCLEOS DE FORTALEZA'
      },
      {
        code: 4283,
        name: 'MESMO DAS PERÍCIAS REALIZADAS PELOS NÚCLEOS DE FORTALEZA'
      },
      {
        code: 4284,
        name: 'MESMAS DAS PERÍCIAS REALIZADAS PELOS NÚCLEOS DE FORTALEZA'
      },
      {
        code: 4285,
        name: 'MESMAS DAS PERÍCIAS REALIZADAS PELOS NÚCLEOS DE FORTALEZA'
      },
      {
        code: 4286,
        name: 'MESMOS DAS PERÍCIAS REALIZADAS PELOS NÚCLEOS DE FORTALEZA'
      },
      {
        code: 4287,
        name: 'PROGRAMA AGENTE VOLUNTARIO AMBIENTAL - AVA'
      },
      {
        code: 4288,
        name: 'PROJETO ESTADUAL DE FLORESTAMENTO E REFLORESTAMENTO.'
      },
      {
        code: 4289,
        name: 'RESERVA PARTICULAR DO PATRIMôNIO NATURAL - RPPN'
      },
      {
        code: 4294,
        name: 'CERTIFICAÇÃO PRAIA LIMPA'
      },
      {
        code: 4295,
        name: 'EDITAIS'
      },
      {
        code: 4296,
        name: 'ANÁLISE DE PROJETO'
      },
      {
        code: 4297,
        name: 'FORNECIMENTO DE CÓPIAS'
      },
      {
        code: 4298,
        name: 'INFORMAÇÃO SOBRE A SITUAÇÃO DO PROCESSO'
      },
      {
        code: 4300,
        name: 'AULAS DE ATIVIDADES FÍSICAS DIVERSAS NA GRADUAÇÃO, PÓS-GRADUAÇÃO E PROJETOS DE EXTENSÃO.'
      },
      {
        code: 4301,
        name: 'VISTORIA DE HABITE-SE'
      },
      {
        code: 4309,
        name: 'REDESIMPLES'
      },
      {
        code: 4310,
        name: 'ESPECIALIZAÇÃO EM ACUPUNTURA TRADICIONAL'
      },
      {
        code: 4311,
        name: 'MEDIÇÃO DE VAZÃO DE ÁGUA'
      },
      {
        code: 4312,
        name: 'MANUTENÇÃO DE HIDRÔMETROS.'
      },
      {
        code: 4314,
        name: 'MEDIÇÃO DE VAZÃO DE ÁGUA.'
      },
      {
        code: 4315,
        name: 'MEDIÇÃO DE PRESSÃO DE REDE ÁGUA.'
      },
      {
        code: 4316,
        name: 'MEDIÇÃO DE PRESSÃO DE ÁGUA'
      },
      {
        code: 4317,
        name: 'VERIFICAÇÃO INICIAL OU EVENTUAL DE HIDRÔMETROS.'
      },
      {
        code: 4318,
        name: 'VERIFICAÇÃO INICIAL OU EVENTUAL DE HIDRÔMETROS'
      },
      {
        code: 4319,
        name: 'TEATRO DE FANTOCHES DA CAGECE'
      },
      {
        code: 4320,
        name: 'OFICINAS PONTUAIS DE RECICLAGEM: PELO RECICLOCIDADES-INCENTIVO AO TALENTO QUE RECICLA'
      },
      {
        code: 4321,
        name: 'FORMAÇÃO DE GRUPO PRODUTIVO PELO RECICLOCIDADES - INCENTIVO AO TALENTO QUE RECICLA'
      },
      {
        code: 4322,
        name: 'PROGRAMA DE CAPACITAÇÃO PROFISSIONAL E INCLUSÃO DIGITAL'
      },
      {
        code: 4323,
        name: 'PRESENÇA DOS MASCOTES DA CAGECE PINGO, GOTA D´ÁGUA E SUPER A'
      },
      {
        code: 4324,
        name: 'IMPRESSÃO DE MAPA DE CADASTRO DE REDE DE ÁGUA E ESGOTO'
      },
      {
        code: 4326,
        name: 'ESPECIALIZAÇÃO EM HEMATOLOGIA E HEMOTERAPIA'
      },
      {
        code: 4327,
        name: 'ESPECIALIZAÇÃO EM DIREITO PROCESSUAL CIVIL'
      },
      {
        code: 4328,
        name: 'ESPECIALIZAÇÃO EM DIREITO PENAL E DIREITO PROCESSUAL PENAL'
      },
      {
        code: 4329,
        name: 'ESPECIALIZAÇÃO EM SERVIÇO SOCIAL, POLÍTICAS PÚBLICAS E DIREITOS SOCIAIS'
      },
      {
        code: 4330,
        name: 'ESPECIALIZAÇÃO EM PSICOLOGIA ORGANIZACIONAL E DO TRABALHO'
      },
      {
        code: 4331,
        name: 'ESPECIALIZAÇÃO EM ADMINISTRAÇÃO FINANCEIRA'
      },
      {
        code: 4332,
        name: 'ESPECIALIZAÇÃO EM ENSINO DE QUÍMICA'
      },
      {
        code: 4333,
        name: 'ESPECIALIZAÇÃO EM ENFERMAGEM CARDIOVASCULAR'
      },
      {
        code: 4334,
        name: 'ESPECIALIZAÇÃO EM ENFERMAGEM OBSTÉTRICA E SAÚDE DA MULHER'
      },
      {
        code: 4335,
        name: 'ESPECIALIZAÇÃO EM ENFERMAGEM EM CENTRO DE TERAPIA INTENSIVA'
      },
      {
        code: 4336,
        name: 'ESPECIALIZAÇÃO EM ORTODONTIA'
      },
      {
        code: 4337,
        name: 'ESPECIALIZAÇÃO EM ENFERMAGEM EM CENTRO DE TERAPIA INTENSIVA'
      },
      {
        code: 4338,
        name: 'ANÁLISES LABORATORIAIS DE ÁGUA E ESGOTO'
      },
      {
        code: 4339,
        name: 'O MESTRADO NACIONAL PROFISSIONAL EM ENSINO DE FÍSICA'
      },
      {
        code: 4595,
        name: 'PROJETO PROFESSOR DIRETOR DE TURMA - PPDT'
      },
      {
        code: 4340,
        name: 'O Mestrado Profissional em Climatologia e Aplicações nos Países da CPLP e África'
      },
      {
        code: 4342,
        name: 'ESPECIALIZAÇÃO EM BIOTECNOLOGIA E BIOLOGIA MOLECULAR APLICADAS A ÁREAS DE SAÚDE'
      },
      {
        code: 4343,
        name: 'CONHECENDO NOSSA CAGECE'
      },
      {
        code: 4344,
        name: 'PALESTRA SOBRE EDUCAÇÃO AMBIENTAL'
      },
      {
        code: 4345,
        name: 'SETOR DE CERTIFICAÇÃO DA PROEX'
      },
      {
        code: 4348,
        name: 'PROGRAMA SOCIOAMBIENTAL DE EDUCAÇÃO EM SAÚDE - PSAES'
      },
      {
        code: 4349,
        name: 'NOVOS NEGÓCIOS'
      },
      {
        code: 4351,
        name: 'Manifestações de ouvidoria'
      },
      {
        code: 4352,
        name: 'MESTRADO PROFISSIONAL EM COMPUTAÇÃO APLICADA'
      },
      {
        code: 4354,
        name: 'FLEXÃO POR CARREGAMENTO EM TRÊS PONTOS EM ROCHA'
      },
      {
        code: 4356,
        name: 'DETERMINAÇÃO DE CLORETOS EM AGREGADOS'
      },
      {
        code: 4358,
        name: 'DETERMINAÇÃO DE SULFATOS SOLÚVEIS'
      },
      {
        code: 4359,
        name: 'DETERMINAÇÃO DO TEOR DE UMIDADE'
      },
      {
        code: 4362,
        name: 'DETERMINAÇÃO DE FERRO EM ALIMENTOS'
      },
      {
        code: 4364,
        name: 'SERVIÇO DE PRESTAÇÃO DE INFORMAÇÕES A UMA ENTIDADE (INDIVÍDUO/INSTITUIÇÃO) SOBRE ASSUNTOS RELATIVOS A PROCURADORIA GERAL DO ESTADO DO CEARÁ'
      },
      {
        code: 4365,
        name: 'SERVIÇO DE INFORMAÇÕES REFERENTES ÀS LEIS ESTADUAIS'
      },
      {
        code: 4366,
        name: 'DIAGNÓSTICO ENERGÉTICO E REVISÃO ENERGÉTICA'
      },
      {
        code: 4367,
        name: 'DIAGNÓSTICO ENERGÉTICO E REVISÃO ENERGÉTICA EM PROCESSO INDUSTRIAL ENERGO-INTENSIVO.'
      },
      {
        code: 4368,
        name: 'AVALIAÇÃO E DECLARAÇÃO DE CONFORMIDADE DE MÁQUINA E EQUIPAMENTO COM A NR-12'
      },
      {
        code: 4369,
        name: 'ENSAIO DE OPACIDADE'
      },
      {
        code: 4370,
        name: 'ENSAIO DE RUIDO'
      },
      {
        code: 4371,
        name: 'LAUDO DE INSPEÇÃO VEICULAR'
      },
      {
        code: 4372,
        name: 'ELABORAÇÃO, REVISÃO E EXAME DE PROJETOS DE LEI, DECRETOS E INSTRUÇÕES NORMATIVAS DE INTERESSE DO GABINETE DO GOVERNADOR.'
      },
      {
        code: 4375,
        name: 'MÓDULO DE ELASTICIDADE DO CONCRETO'
      },
      {
        code: 4376,
        name: 'LAUDO DE INSPEÇÃO TÉCNICA VEICULAR – VEÍCULO LEVE'
      },
      {
        code: 4377,
        name: 'LAUDO DE INSPEÇÃO TÉCNICA VEICULAR – VEÍCULO PESADO'
      },
      {
        code: 4378,
        name: 'AVALIAÇÃO DE VEICULO USADO PARA FINS DE GARANTIA'
      },
      {
        code: 4379,
        name: 'AUTOMAÇÃO DE PLANTA INDUSTRIAL'
      },
      {
        code: 4382,
        name: 'MEDIÇÃO DE CAMPOS ELÉTRICOS, MAGNÉTICOS E ELETROMAGNÉTICOS REGULADA PELA LEI Nº 11.934/2009'
      },
      {
        code: 4384,
        name: 'LAUDO TÉCNICO DE AVALIAÇÃO DE MÁQUINA, TIPO 1.'
      },
      {
        code: 4385,
        name: 'LAUDO TÉCNICO DE AVALIAÇÃO DE MÁQUINAS, TIPO: 2.'
      },
      {
        code: 4386,
        name: 'LAUDO TÉCNICO DE AVALIAÇÃO DE MÁQUINAS, TIPO 3'
      },
      {
        code: 4387,
        name: 'LAUDO TÉCNICO DE AVALIAÇÃO DE MÁQUINAS, TIPO 4'
      },
      {
        code: 4388,
        name: 'LAUDO TÉCNICO DE AVALIAÇÃO DE MÁQUINAS, TIPO 5'
      },
      {
        code: 4389,
        name: 'LAUDO DA ALFÂNDEGA (PORTO DO MUCURIPE)'
      },
      {
        code: 4390,
        name: 'AVALIAÇÃO DE CONFORMIDADE DE ESTAÇÕES TRANSMISSORAS DE RADIOCOMUNICAÇÃO,INCLUINDO TERMINAIS DE USUÁRIO COM A LEI 13.116/2015(LEI DAS ANTENAS)'
      },
      {
        code: 4391,
        name: '2ª VIA DE SERVIÇO PRESTADO'
      },
      {
        code: 4392,
        name: 'RETIFICAÇÃO DE LAUDO TÉCNICO'
      },
      {
        code: 4393,
        name: 'LAUDO DA ALFÂNDEGA (PORTO DO PECEM)'
      },
      {
        code: 4394,
        name: 'LAUDO DA ALFÂNDEGA (AEROPORTO)'
      },
      {
        code: 4395,
        name: 'LAUDO DE IMPRESTABILIDADE (CAPITAL FORTALEZA)'
      },
      {
        code: 4396,
        name: 'CONSULTORIA (LISV)'
      },
      {
        code: 4397,
        name: 'CONSULTORIA (GEMEA)'
      },
      {
        code: 4398,
        name: 'LAUDO DE IMPRESTABILIDADE (INTERIOR DO CEARÁ)'
      },
      {
        code: 4399,
        name: 'CONSULTORIA (LER)'
      },
      {
        code: 4400,
        name: 'CONSULTORIA (CENTAURO)'
      },
      {
        code: 4401,
        name: 'CONSULTORIA (LME)'
      },
      {
        code: 4402,
        name: 'PREVINA'
      },
      {
        code: 4403,
        name: 'PREVINA'
      },
      {
        code: 4404,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4405,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4406,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4409,
        name: 'DETERMINAÇÃO DE FÓSFORO EM ALIMENTOS'
      },
      {
        code: 4410,
        name: 'LAUDO METEOROLÓGICO'
      },
      {
        code: 4411,
        name: 'PREPARAÇÃO DE AMOSTRA'
      },
      {
        code: 4412,
        name: 'CONSULTORIA'
      },
      {
        code: 4413,
        name: 'CONSULTA PROCESSUAL'
      },
      {
        code: 4414,
        name: 'ENSAIOS POR MICROSCOPIA ÓPTICA (METALOGRAFIA)'
      },
      {
        code: 4415,
        name: 'PONTO DE FULGOR VASO ABERTO EM ÓLEO E OUTROS.'
      },
      {
        code: 4417,
        name: 'VISITA TÉCNICA.'
      },
      {
        code: 4419,
        name: 'PODER CALORÍFICO EM COMBUSTÍVEIS LÍQUIDOS E SÓLIDOS (SUPERIOR)'
      },
      {
        code: 4425,
        name: 'DETERMINAÇÃO DE AFLATOXINA TOTAL POR ENSAIO IMUNO ENZIMÁTICO - ELISA'
      },
      {
        code: 4430,
        name: 'DETERMINAÇÃO DE ÁCIDO BENZÓICO - HPLC'
      },
      {
        code: 4431,
        name: 'DETERMINAÇÃO DE ÁCIDO SÓRBICO - HPLC'
      },
      {
        code: 4432,
        name: 'DETERMINAÇÃO DE ÁCIDO ASCÓRBICO - HPLC'
      },
      {
        code: 4433,
        name: 'DETERMINAÇÃO DA CAFEÍNA - HPLC'
      },
      {
        code: 4434,
        name: 'DETERMINAÇÃO DE BENZOATO DE SÓDIO - HPLC'
      },
      {
        code: 4435,
        name: 'DETERMINAÇÃO DE SORBATO DE POTÁSSIO - HPCL'
      },
      {
        code: 4436,
        name: 'DETERMINAÇÃO DE ÁCIDOS GRAXOS EM ÓLEOS VEGETAIS ( GORDURA SATURADA E GORDURA INSATURADA ) - CG/FID'
      },
      {
        code: 4437,
        name: 'DETERMINAÇÃO DE ÁCIDOS GRAXOS EM ALIMENTOS ( GORDURA SATURADA E GORDURA INSATURADA ) - CG/FID'
      },
      {
        code: 4438,
        name: 'DETERMINAÇÃO DE MULTIRESÍDUOS DE AGROTÓXICOS EM ÁGUA - CG/MS'
      },
      {
        code: 4453,
        name: 'PONTO DE FUSÃO EM CERA DE CARNAÚBA'
      },
      {
        code: 4455,
        name: 'DIÁRIO OFICIAL DO ESTADO DO CEARÁ (DOE)'
      },
      {
        code: 4456,
        name: 'ANÁLISE DIÁRIA DAS CHUVAS'
      },
      {
        code: 4457,
        name: 'PREVISÃO DO TEMPO POR REGIÕES HOMOGÊNEAS'
      },
      {
        code: 4458,
        name: 'PREVISÃO DIÁRIA POR REGIÕES HIDROGRÁFICAS DO CEARÁ'
      },
      {
        code: 4460,
        name: 'PREVISÃO DO TEMPO POR SUB-BACIAS DO CEARÁ'
      },
      {
        code: 4462,
        name: 'MONITORAMENTO GLOBAL MENSAL'
      },
      {
        code: 4463,
        name: 'NASCER E PÔR DO SOL.'
      },
      {
        code: 4464,
        name: 'POSTOS PLUVIOMÉTRICOS'
      },
      {
        code: 4465,
        name: 'SERVIÇO DE CONTROLE DE MANDADOS JUDICIAIS'
      },
      {
        code: 4466,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4467,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4468,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4469,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4470,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4471,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4472,
        name: 'PREVINA - PROGRAMA DE PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4473,
        name: 'PREVINA - PREVENÇÃO, MONITORAMENTO, CONTROLE DE QUEIMADAS E COMBATE AOS INCÊNDIOS FLORESTAIS'
      },
      {
        code: 4474,
        name: 'PSMV - PROGRAMA SELO MUNICÍPIO VERDE'
      },
      {
        code: 4475,
        name: 'PEIXAMENTO - DISTRIBUIÇÃO DE ALEVINOS DE PEIXES NOS AÇUDES PÚBLICOS E COMUNITÁRIOS DO ESTADO DO CEARÁ.'
      },
      {
        code: 4476,
        name: 'VISCOSIDADE EM CERA DE CARNAÚBA A 100 ±5°C'
      },
      {
        code: 4490,
        name: 'ENGENHARIA DE VEÍCULO AUTÔNOMO PILOTADO E OPERADO REMOTAMENTE'
      },
      {
        code: 4491,
        name: 'ENGENHARIA DE CONTROLE AUTOMÁTICO AVANÇADO E SISTEMAS ESPECIALISTAS EM UNIDADES E EQUIPAMENTOS DE PROCESSO'
      },
      {
        code: 4492,
        name: 'ENGENHARIA DE MOBILIDADE DE INSTRUMENTOS ANALÍTICOS E SISTEMAS EMBARCADOS'
      },
      {
        code: 4493,
        name: 'SEGURANÇA E AUTOMAÇÃO DE EQUIPAMENTOS E MÁQUINAS'
      },
      {
        code: 4494,
        name: 'ASSESSORIA DE IMPRENSA PARA O CONSELHO ESTADUAL DO MEIO AMBIENTE-COEMA.'
      },
      {
        code: 4495,
        name: 'PRESTAR INFORMAÇÕES INSTITUCIONAIS À IMPRENSA.'
      },
      {
        code: 4496,
        name: 'ASSESSORIA DE IMPRENSA'
      },
      {
        code: 4497,
        name: 'CONTEÚDO JORNALÍSTICO'
      },
      {
        code: 4498,
        name: 'PROGRAMA DE BOLSA PERMANÊNCIA UNIVERSITARIA - PBPU'
      },
      {
        code: 4500,
        name: 'SOLICITAÇÃO DE DOCUMENTOS'
      },
      {
        code: 4501,
        name: 'AUXÍLIO FINANCEIRO A ESTUDANTES PARA A PARTICIPAÇÃO EM EVENTOS'
      },
      {
        code: 4502,
        name: 'CURSINHO PRE-VESTIBULAR PREVEST/UVA'
      },
      {
        code: 4503,
        name: 'CURSINHO PRE-VESTIBULAR PREVEST/UVA'
      },
      {
        code: 4504,
        name: 'CURSINHO PRE-VESTIBULAR PREVEST/UVA'
      },
      {
        code: 4510,
        name: 'SERVIÇO SOCIAL'
      },
      {
        code: 4512,
        name: 'NÚCLEO DE NUTRIÇÃO E DIETÉTICA'
      },
      {
        code: 4516,
        name: 'VISTORIAS AOS DIVERSOS USOS, OBRAS OU SERVIÇOS DE INTERFERÊNCIA, DOS RECURSOS HÍDRICOS DE DOMÍNIO DO ESTADO DO CEARÁ.'
      },
      {
        code: 4517,
        name: 'ABERTURA DOS PEDIDOS DE OUTORGA PARA EXECUÇÃO DE OBRAS OU DE SERVIÇOS DE INTERFERÊNCIA HÍDRICA.'
      },
      {
        code: 4518,
        name: 'ABERTURA DOS PROCESSOS DE PEDIDO DE OUTORGA DE DIREITO DE USO DE ÁGUA BRUTA DE DOMÍNIO DO ESTADO OU DA UNIÃO POR DELEGAÇÃO.'
      },
      {
        code: 4519,
        name: 'SERVIÇO DE GINECOLOGIA'
      },
      {
        code: 4520,
        name: 'SERVIÇO DE IMAGEM - EXAMES CONTRASTADOS (ENEMA OPACO, TRÂNSITO INTESTINAL, ALÇOGRAMA DISTAL , SERIOGRAFIA GASTRODUODENAL, DEGLUTOGRAMA, ESOFA'
      },
      {
        code: 4521,
        name: 'ATENDIMENTO ÀS GESTANTES E MULHERES COM DÚVIDAS E/OU DIFICULDADES PARA AMAMENTAR'
      },
      {
        code: 4522,
        name: 'TIME DE ACESSO VASCULAR (TAV)'
      },
      {
        code: 4523,
        name: 'AUTORIZAÇÃO DE INTERNAÇÃO DE PACIENTES COM PATOLOGIAS CLÍNICAS E CIRÚRGICAS.'
      },
      {
        code: 4524,
        name: 'REGULAÇÃO DE INTERNAÇÃO DE PACIENTES EXTERNOS'
      },
      {
        code: 4525,
        name: 'REGULAÇÃO E TRANSFERÊNCIA DE PACIENTES DO HIAS PARA INTERNAÇÃO EM OUTROS HOSPITAIS.'
      },
      {
        code: 4526,
        name: 'SERVIÇO DE ANESTESIOLOGIA DO HIAS SALA DE RECUPERAÇÃO ANESTÉSICA'
      },
      {
        code: 4527,
        name: 'SERVIÇO DE ANESTESIOLOGIA DO HIAS – PROCEDIMENTOS DE URGÊNCIA E EMERGÊNCIA'
      },
      {
        code: 4528,
        name: 'SERVIÇO DE ANESTESIOLOGIA DO HIAS – PROCEDIMENTOS ELETIVOS'
      },
      {
        code: 4529,
        name: 'AMBULATÓRIO DE AVALIAÇÃO PRÉ-ANESTÉSICA'
      },
      {
        code: 4530,
        name: 'SCIH - SERVIÇO DE CONTROLE DE INFECÇÃO HOSPITALAR'
      },
      {
        code: 4535,
        name: 'CASRM'
      },
      {
        code: 4536,
        name: 'SERVIÇO DE MAMOGRAFIA'
      },
      {
        code: 4537,
        name: 'SERVIÇO DE ULTRASSONOGRAFIA'
      },
      {
        code: 4538,
        name: 'SERVIÇO DE FARMÁCIA'
      },
      {
        code: 4539,
        name: 'AMBULATÓRIO DE DISFAGIA'
      },
      {
        code: 4540,
        name: 'ASSISTÊNCIA FONOAUDIOLÓGICA NAS UNIDADES DE INTERNAMENTO'
      },
      {
        code: 4541,
        name: 'NÚCLEO DE ORIENTAÇÃO E ESTIMULAÇÃO AO LACTENTE ( NOEL )'
      },
      {
        code: 4542,
        name: 'NÚCLEO ESPECIALIZADO NO TRATAMENTO INFANTIL DA INCONTINÊNCIA FECAL (NETIIF)'
      },
      {
        code: 4543,
        name: 'CENTRO DE REFERÊNCIA PARA IMUNOBIOLÓGICOS ESPECIAIS - CRIE'
      },
      {
        code: 4544,
        name: 'AVALIAÇÃO DE PROJETOS DE PESQUISA'
      },
      {
        code: 4545,
        name: 'CURSOS E TREINAMENTOS PARA FUNCIONÁRIOS DO HIAS'
      },
      {
        code: 4546,
        name: 'FORMAÇÃO EM PESQUISA PARA OS PROGRAMAS DE RESIDÊNCIA MÉDICA E MULTIPROFISSIONAL DO HIAS'
      },
      {
        code: 4547,
        name: 'PRÁTICA DE ESTÁGIOS CURRICULARES'
      },
      {
        code: 4548,
        name: 'RESIDÊNCIA MÉDICA DO HIAS'
      },
      {
        code: 4549,
        name: 'RESIDÊNCIA MULTIPROFISSIONAL EM SAÚDE DE OUTRAS INSTITUIÇÕES'
      },
      {
        code: 4550,
        name: 'EXAME DE RAIO X – ULTRASSOM – ELETROCARDIOGRAMA – ECOCARDIOGRAMA – TESTE ERGOMÉTRICO – ELETROENCEFALOGRAMA – TOMOGRAFIA – DENSITOMETRIA ÓSSEA'
      },
      {
        code: 4551,
        name: 'RESIDÊNCIA MULTIPROFISSIONAL EM SAÚDE'
      },
      {
        code: 4552,
        name: 'FISIOTERAPIA'
      },
      {
        code: 4553,
        name: 'EXAMES DE SANGUE, EXAMES DE FEZES, CULTURA, ESCARRO, EXUDATOS E TRANSUDATOS, LINFA.'
      },
      {
        code: 4554,
        name: 'TERAPIA DE SUBSTITUIÇÃO RENAL: HEMODIÁLISE E DIÁLISE PERITONEAL'
      },
      {
        code: 4555,
        name: 'CONSULTAS NO AMBULATÓRIO'
      },
      {
        code: 4556,
        name: 'SEÇÃO DE DESENVOLVIMENTO DE PESSOAS'
      },
      {
        code: 4557,
        name: 'AMBULATÓRIO DE DEFICIÊNCIA DO HORMÔNIO DE CRESCIMENTO'
      },
      {
        code: 4558,
        name: 'AMBULATÓRIO DE PUBERDADE PRECOCE'
      },
      {
        code: 4559,
        name: 'SERVIÇO DE TESTE DIAGNÓSTICO EM CARDIOLOGIA'
      },
      {
        code: 4560,
        name: 'AMBULATÓRIO DO PÉ DIABÉTICO'
      },
      {
        code: 4561,
        name: 'AMBULATÓRIO DE DIABETES E GESTAÇÃO'
      },
      {
        code: 4562,
        name: 'SERVIÇO DE OFTALMOLOGIA PARA DIABETES'
      },
      {
        code: 4563,
        name: 'SERVIÇO DE ATENDIMENTO AO USUÁRIO COM DIABETES MELLITUS TIPO 2'
      },
      {
        code: 4564,
        name: 'SERVIÇO DE ATENDIMENTO AO USUÁRIO COM DIABETES MELLITUS TIPO 1'
      },
      {
        code: 4565,
        name: 'SERVIÇO DE ATENDIMENTO AO USUÁRIO COM HIPERTENSÃO ARTERIAL'
      },
      {
        code: 4566,
        name: 'ESTUDO ELETROFISIOLÓGICO'
      },
      {
        code: 4567,
        name: 'Programa de Atenção à Saúde da Pessoa Ostomizada'
      },
      {
        code: 4568,
        name: 'FORNECIMENTO DE MEDICAMENTOS'
      },
      {
        code: 4570,
        name: 'OUVIDORIA GERAL DA SECRETARIA DA SAÚDE DO ESTADO DO CEARÁ'
      },
      {
        code: 4572,
        name: 'O Espaço Ekobé'
      },
      {
        code: 4574,
        name: 'ABLAÇÃO POR CATETER'
      },
      {
        code: 4576,
        name: 'PIRATA'
      },
      {
        code: 4577,
        name: 'CAMPOS DE TSM E VENTO NO ATLÂNTICO TROPICAL'
      },
      {
        code: 4578,
        name: 'AMBULATÓRIO ESPECIALIZADO - CLINICA CIRÚRGICA'
      },
      {
        code: 4579,
        name: 'ATENDIMENTO A DENÚNCIAS E RECLAMAÇÕES SOBRE OS ESTABELECIMENTOS SUJEITOS A VIGILÂNCIA SANITÁRIA.'
      },
      {
        code: 4580,
        name: 'Alvará Sanitário'
      },
      {
        code: 4581,
        name: 'Bloqueio ou Quimioprofilaxia de Doenças de Notificação Compulsória (DNC)'
      },
      {
        code: 4582,
        name: 'CENTRO DE INFORMAÇÕES ESTRATÉGICAS DE VIGILÂNCIA EM SAÚDE'
      },
      {
        code: 4583,
        name: 'Investigação de Surtos'
      },
      {
        code: 4584,
        name: 'Plantão Epidemiológico'
      },
      {
        code: 4585,
        name: 'POLICIAMENTO EM EVENTO'
      },
      {
        code: 4586,
        name: 'MARÉS E LUAS'
      },
      {
        code: 4589,
        name: 'PROGRAMA NOVO MAIS EDUCAÇÃO'
      },
      {
        code: 4590,
        name: 'CENTRO DE LÍNGUAS'
      },
      {
        code: 4591,
        name: 'PROGRAMA DE ESTÍMULO À COOPERAÇÃO NA ESCOLA – PRECE.'
      },
      {
        code: 4593,
        name: 'NÚCLEO TRABALHO, PESQUISA E PRÁTICAS SOCIAIS - NTPPS'
      },
      {
        code: 4594,
        name: 'PROGRAMA ENSINO MÉDIO INOVADOR – PROEMI'
      },
      {
        code: 4597,
        name: 'TRANCAMENTO TOTAL DE MATRÍCULA'
      },
      {
        code: 4598,
        name: 'TRANCAMENTO PARCIAL DE MATRÍCULA'
      },
      {
        code: 4600,
        name: 'PROGRAMA PARQUE ESCOLA: APRENDENDO COM A NATUREZA'
      },
      {
        code: 4601,
        name: 'PROJETOS PERMACULTURAIS NAS ESCOLAS'
      },
      {
        code: 4602,
        name: 'MATRÍCULA INSTITUCIONAL'
      },
      {
        code: 4603,
        name: 'SELO ESCOLA SUSTENTÁVEL'
      },
      {
        code: 4604,
        name: 'MATRÍCULA CURRICULAR'
      },
      {
        code: 4605,
        name: 'ACOMPANHAMENTO DO PDDE ESCOLA SUSTENTÁVEL'
      },
      {
        code: 4606,
        name: 'MATRÍCULA CLASSIFICADOS NO VESTIBULAR'
      },
      {
        code: 4607,
        name: 'MATRÍCULA CLASSIFICÁVEIS NO VESTIBULAR'
      },
      {
        code: 4608,
        name: 'OUVIDORIA EM SAUDE'
      },
      {
        code: 4609,
        name: 'CAPACITAÇÃO/FORMAÇÃO DE PROFESSORES E ALUNOS VINCULADOS À SECRETARIA ESTADUAL DA EDUCAÇÃO.'
      },
      {
        code: 4610,
        name: 'REGISTRO DE MANIFESTAÇÕES'
      },
      {
        code: 4611,
        name: 'FORMAÇÕES PEDAGÓGICAS NAS ESCOLAS - EDUCAÇÃO, GÊNERO E SEXUALIDADE'
      },
      {
        code: 4612,
        name: 'VISITA DE ALUNOS DOS NÍVEIS FUNDAMENTAL, MÉDIO E SUPERIOR DA REDE PRIVADA E DA PÚBLICA (MUNICIPAL, ESTADUAL E FEDERAL).'
      },
      {
        code: 4613,
        name: 'ENTREVISTAS PARA OS MEIOS DE COMUNICAÇÃO(TV, RÁDIO E JORNAL)'
      },
      {
        code: 4614,
        name: 'Solicitação de dados educacionais'
      },
      {
        code: 4619,
        name: 'PROJETO EDUCACIONAL'
      },
      {
        code: 4624,
        name: 'PROJETO EDUCACIONAL DO ESTADO DO CEARÁ'
      },
      {
        code: 4625,
        name: 'CÉLULA DE ACOMPANHAMENTO DE GESTÃO'
      },
      {
        code: 4626,
        name: 'DOCUMENTAÇÃO ESCOLAR'
      },
      {
        code: 4629,
        name: 'ABERTURA DE PROCESSOS'
      },
      {
        code: 4630,
        name: 'GERENCIAMENTO DE ARQUIVAMENTO DE DOCUMENTOS E PROCESSOS'
      },
      {
        code: 4631,
        name: 'SELEÇÃO DE GESTORES ESCOLARES'
      },
      {
        code: 4632,
        name: 'CONCESSÃO DE BOLSA ESTÁGIO PARA ALUNOS DAS ESCOLAS ESTADUAIS DE EDUCAÇÃO PROFISSIONAL DO ESTADO DO CEARÁ.'
      },
      {
        code: 4633,
        name: 'DESENHO E IMPLEMENTAÇÃO DO CURRÍCULO PRATICADO NAS ESCOLAS ESTADUAIS DE EDUCAÇÃO PROFISSIONAL – EEEP.'
      },
      {
        code: 4634,
        name: 'AQUISIÇÃO DE EQUIP., MOBILIÁRIOS, LABORATÓRIOS, ACERVOS TÉCNICOS E FARDAMENTOS ESCOLARES PARA AS ESCOLAS ESTADUAIS DE EDUCAÇÃO PROFISSIONAL'
      },
      {
        code: 4635,
        name: 'PROGRAMA NACIONAL DE ACESSO AO ENSINO TÉCNICO E EMPREGO - PRONATEC'
      },
      {
        code: 4636,
        name: 'BIÓPSIA ENDOMIOCÁRDICA'
      },
      {
        code: 4637,
        name: 'ANGIOPLASTIA CORONÁRIA OU INTERVENÇÃO CORONÁRIA PERCUTÂNEA'
      },
      {
        code: 4638,
        name: 'VALVULOPLASTIA PERCUTÂNEA'
      },
      {
        code: 4639,
        name: 'PLETISMOGRAFIA'
      },
      {
        code: 4640,
        name: 'Centro de Referência sobre Drogas – CRD'
      },
      {
        code: 4641,
        name: 'Teleatendimento sobre álcool e outras drogas (0800 275 1475)'
      },
      {
        code: 4642,
        name: 'UNIDADE MÓVEL (UM)'
      },
      {
        code: 4643,
        name: 'DENSIDADE POR PICNOMETRIA'
      },
      {
        code: 4644,
        name: 'Sistema Acolhe Ceará'
      },
      {
        code: 4645,
        name: 'Projeto Corre Pra Vida'
      },
      {
        code: 4646,
        name: 'ALUGUEL DE ROBÔS'
      },
      {
        code: 4649,
        name: 'LAUDO DE NÃO SIMILARIDADE (POR PRODUTO)'
      },
      {
        code: 4650,
        name: 'PESAGEM DE VEÍCULO / TRATOR'
      },
      {
        code: 4651,
        name: 'Desenho de protótipo em software de modelagem'
      },
      {
        code: 4652,
        name: 'Ouvidoria'
      },
      {
        code: 4653,
        name: 'Protocolo'
      },
      {
        code: 4654,
        name: 'ECG – Eletrocardiograma'
      },
      {
        code: 4655,
        name: 'Consulta de Enfermagem em Hipertensão e Diabetes - HIPERDIA'
      },
      {
        code: 4656,
        name: 'Consulta de Enfermagem para diagnóstico e tratamento das IST (Infecções Sexualmente Transmissíveis)'
      },
      {
        code: 4657,
        name: 'Aplicação do Palivizumabe'
      },
      {
        code: 4658,
        name: 'Testagem Rápida para HIV, Sífilis, Hepatite B e Hepatite C'
      },
      {
        code: 4659,
        name: 'PROGRAMA DE ASSISTÊNCIA DOMICILIAR - PAD'
      },
      {
        code: 4660,
        name: 'Vacinação'
      },
      {
        code: 4661,
        name: 'Programa de Alergia à Proteína do Leite de Vaca(APLV)'
      },
      {
        code: 4662,
        name: 'VIGILÂNCIA EPIDEMIOLÓGICA'
      },
      {
        code: 4663,
        name: 'Coleta de Sangue para exames laboratoriais'
      },
      {
        code: 4664,
        name: 'SERVIÇO DE ACOLHIMENTO AO FAMILIAR ACOMPANHANTE'
      },
      {
        code: 4665,
        name: 'SERVIÇO MÉDICO HOSPITALAR - SESSÕES DE OXIGENOTERAPIA HIPERBÁRICA'
      },
      {
        code: 4672,
        name: 'CADASTRO DE ADOÇÃO. HABILITAÇÃO PARA ADOÇÃO. PROCESSO PARA ADOÇÃO.'
      },
      {
        code: 4673,
        name: 'AUTORIZAÇÃO DE VIAGENS'
      },
      {
        code: 4675,
        name: 'PROGRAMA DE APADRINHAMENTO,REGULAMENTADO PELA RESOLUÇÃO Nº 13/2015, DO ÓRGÃO ESPECIAL DO EGRÉGIO TRIBUNAL DE JUSTIÇA DO ESTADO DO CEARÁ.'
      },
      {
        code: 4676,
        name: 'PROJETO ANJOS DA ADOÇÃO'
      },
      {
        code: 4677,
        name: 'PLANEJAMENTO FAMILIAR'
      },
      {
        code: 4680,
        name: 'DETERMINAÇÃO DE METAIS POR ICP-OES EM SOLO.'
      },
      {
        code: 4681,
        name: 'DETERMINAÇÃO DE METAIS POR ICP-OES EM LIGAS METÁLICAS'
      },
      {
        code: 4682,
        name: 'PREPARAÇÃO DE AMOSTRA DE SOLO PARA ANÁLISE EM ICP-OES.'
      },
      {
        code: 4683,
        name: 'DETERMINAÇÃO DE HPAS(HIDROCARBONETOS POLICÍCLICOS AROMÁTICOS)EM SOLO.'
      },
      {
        code: 4684,
        name: 'DETERMINAÇÃO DE BTEX EM SOLO.'
      },
      {
        code: 4685,
        name: 'COMISSÃO DE CONTROLE DE INFECÇÃO HOSPITALAR (CCIH)'
      },
      {
        code: 4686,
        name: 'TESTE DO PEZINHO'
      },
      {
        code: 4687,
        name: 'DETERMINAÇÃO DE ANIDRIDO SULFÚRICO EM CIMENTO'
      },
      {
        code: 4688,
        name: 'DETERMINAÇÃO DO TEOR DE ÓXIDO DE FERRO'
      },
      {
        code: 4689,
        name: 'DETERMINAÇÃO DO TEOR DE ÓXIDO DE MANGANÊS'
      },
      {
        code: 4690,
        name: 'PERDA POR CALCINAÇÃO EM CIMENTO PORTLAND'
      },
      {
        code: 4691,
        name: 'DETERMINAÇÃO DO TEOR DE ÓXIDO DE SILÍCIO'
      },
      {
        code: 4692,
        name: 'ÓXIDO DE SILÍCIO EM CIMENTO PORTLAND'
      },
      {
        code: 4693,
        name: 'DETERMINAÇÃO DE PRNT'
      },
      {
        code: 4694,
        name: 'DETERMINAÇÃO DE ANIDRIDO SULFÚRICO EM CIMENTO PORTLAND'
      },
      {
        code: 4695,
        name: 'PODER DE NEUTRALIZAÇÃO'
      },
      {
        code: 4696,
        name: 'DETERMINAÇÃO DO ÓXIDO DE MAGNÉSIO EM CIMENTO PORTLAND'
      },
      {
        code: 4697,
        name: 'DETERMINAÇÃO DO ÓXIDO DE FERRO E ÓXIDO DE ALUMÍNIO EM CIMENTO PORTLAND'
      },
      {
        code: 4698,
        name: 'DETERMINAÇÃO DO TEOR DE ENXOFRE'
      },
      {
        code: 4699,
        name: 'DETERMINAÇÃO DE RESÍDUO INSOLÚVEL EM CIMENTO PORTLAND'
      },
      {
        code: 4700,
        name: 'DETERMINAÇÃO DO ÓXIDO DE CÁLCIO EM CIMENTO PORTLAND'
      },
      {
        code: 4712,
        name: 'DETERMINAÇÃO DE METAIS EM ROCHA/MINERAIS POR ICP-OES'
      },
      {
        code: 4714,
        name: 'PROGRAMA NOVO MAIS EDUCAÇÃO NAS ESCOLAS MUNICIPAIS'
      },
      {
        code: 4715,
        name: 'DETERMINAÇÃO DE METAIS EM ROCHA/MINERAIS/PEDRAS PRECIOSAS VIA ICP-OES'
      },
      {
        code: 4720,
        name: 'INSCRIÇÃO NO PROCESSO SELETIVO DE INCUBAÇÃO.'
      },
      {
        code: 4722,
        name: 'ACOMPANHAMENTO DO PEDIDO DE REGISTRO DE MARCA.'
      },
      {
        code: 4723,
        name: 'ELABORAÇÃO DA REDAÇÃO DA PATENTE - PESSOA FÍSICA.'
      },
      {
        code: 4724,
        name: 'PROGRAMA DE APOIO AO DESENVOLVIMENTO INFANTIL - PADIM'
      },
      {
        code: 4725,
        name: 'JUROS/MULTA.'
      },
      {
        code: 4726,
        name: 'CONSUMO DE ENERGIA DO MÓDULO (POR QUILO WATT-HORA).'
      },
      {
        code: 4727,
        name: 'PARCELAMENTO DE DÉBITO.'
      },
      {
        code: 4728,
        name: 'TAXA DE OCUPAÇÃO DO MÓDULO (POR METRO QUADRADO).'
      },
      {
        code: 4729,
        name: 'TAXA DE PARTICIPAÇÃO SOBRE O FATURAMENTO DA INCUBADA GRADUADA (UM POR CENTO SOBRE O VALOR DO FATURAMENTO LÍQUIDO MENSAL).'
      },
      {
        code: 4730,
        name: 'PRÊMIO ESCOLA NOTA DEZ'
      },
      {
        code: 4732,
        name: 'CONTRIBUIÇÃO MENSAL (INCUBAÇÃO RESIDENTE MICRO/PEQUENA EMPRESA) - EDITAL 2016.'
      },
      {
        code: 4733,
        name: 'CONTRIBUIÇÃO MENSAL (INCUBAÇÃO NÃO RESIDENTE) MICRO EMPRESA - PRIMEIRO ANO E DEMAIS.'
      },
      {
        code: 4735,
        name: 'CONTRIBUIÇÃO MENSAL - PRORROGAÇÃO DE CONTRATO.'
      },
      {
        code: 4738,
        name: 'CONTRIBUIÇÃO MENSAL - GRANDE EMPRESA.'
      },
      {
        code: 4739,
        name: 'DIFERENÇA DE COBRANÇA DA TAXA DE OCUPAÇÃO DE ESPAÇO FÍSICO, REFERENTE A METRAGEM E AO TEMPO DE USO DE MÓDULO.'
      },
      {
        code: 4740,
        name: 'SERVIÇO DE COWORKING - PLANO 1.'
      },
      {
        code: 4741,
        name: 'SERVIÇO DE COWORKING - PLANO 2.'
      },
      {
        code: 4742,
        name: 'EIXO FORMAÇÃO DO LEITOR - PAIC: PROSA E POESIA'
      },
      {
        code: 4743,
        name: 'SERVIÇO DE COWORKING - PLANO 3.'
      },
      {
        code: 4744,
        name: 'GREMIO ESTUDANTIL'
      },
      {
        code: 4745,
        name: 'PORTAL ALUNO ONLINE'
      },
      {
        code: 4746,
        name: 'QUALIFICAÇÃO PROFISSIONAL - APRENDIZ NA ESCOLA'
      },
      {
        code: 4747,
        name: 'PROGRAMA DE FORMAÇÃO DE GESTORES - PFOR'
      },
      {
        code: 4748,
        name: 'MEDIAÇÃO SOCIAL E CULTURA DE PAZ'
      },
      {
        code: 4749,
        name: 'ELABORAÇÃO DA REDAÇÃO DA PATENTE - PESSOA JURÍDICA.'
      },
      {
        code: 4750,
        name: 'PROGRAMA DE APRENDIZAGEM NA IDADE CERTA - MAISPAIC'
      },
      {
        code: 4751,
        name: 'RADIOGRAFIA SEIOS DA FACE'
      },
      {
        code: 4752,
        name: 'PROGRAMA DE ALFABETIZAÇÃO NA IDADE CERTA - MAISPAIC'
      },
      {
        code: 4753,
        name: 'RADIOGRAFIA DA COLUNA TORÁCICA'
      },
      {
        code: 4754,
        name: '2ª VIA DO RELATÓRIO DE PESQUISA.'
      },
      {
        code: 4755,
        name: 'DEPÓSITO DE PATENTE.'
      },
      {
        code: 4756,
        name: 'BUSCA DE ANTERIORIDADE PARA MARCAS.'
      },
      {
        code: 4757,
        name: 'CONTRIBUIÇÃO MENSAL - MEI (MICROEMPREENDEDOR INDIVIDUAL).'
      },
      {
        code: 4758,
        name: 'CONTRIBUIÇÃO MENSAL - MICRO/PEQUENA EMPRESA.'
      },
      {
        code: 4759,
        name: 'CONTRIBUIÇÃO MENSAL MÉDIA EMPRESA.'
      },
      {
        code: 4760,
        name: 'BUSCA DE ANTERIORIDADE PARA PATENTE.'
      },
      {
        code: 4761,
        name: 'PEDIDO DE REGISTRO DE MARCA JUNTO AO INPI.'
      },
      {
        code: 4762,
        name: 'PESQUISA BIBLIOGRÁFICA.'
      },
      {
        code: 4763,
        name: 'REGISTRO DE SOFTWARE.'
      },
      {
        code: 4764,
        name: 'PROGRAMA SAÚDE NA ESCOLA'
      },
      {
        code: 4766,
        name: 'OUVIDORIA DO FORUM CLOVIS BEVILÁQUA'
      },
      {
        code: 4767,
        name: 'INFORMAÇÕES SOBRE DISTRIBUIÇÃO DE PROCESSOS.'
      },
      {
        code: 4770,
        name: 'PRÓTESE PENIANA'
      },
      {
        code: 4771,
        name: 'APARELHO BIPAP'
      },
      {
        code: 4772,
        name: 'APARELHO CPAP'
      },
      {
        code: 4774,
        name: 'CADEIRAS DE RODAS'
      },
      {
        code: 4775,
        name: 'COBERTURA DE PELE PARA PACIENTES PORTADORES DE EPIDERMÓLISE BOLHOSA'
      },
      {
        code: 4778,
        name: 'ÓRTESES DIVERSAS'
      },
      {
        code: 4782,
        name: 'ACOLHER MANIFESTAÇÕES QUE TENHA COMO ASSUNTO A PRESTAÇÃO DE SERVIÇOS PÚBLICOS.'
      },
      {
        code: 4788,
        name: 'AMBULATÓRIO DE CIRURGIA GERAL E PEDIÁTRICA NO HOSPITAL GERAL DR WALDEMAR ALCANTARA'
      },
      {
        code: 4790,
        name: 'Auditoria Preventiva'
      },
      {
        code: 4791,
        name: 'Auditoria de Tomada de Contas Especial'
      },
      {
        code: 4792,
        name: 'Comprovação de Legalidade'
      },
      {
        code: 4793,
        name: 'FÉRIAS E 13º SALÁRIO PROPORCIONAIS PARA EX-SERVIDORES.'
      },
      {
        code: 4794,
        name: 'Elaboração de Normatizações'
      },
      {
        code: 4795,
        name: 'Convênios e Contratos de repasse.'
      },
      {
        code: 4796,
        name: 'Elaboração de Instrução Normativa'
      },
      {
        code: 4797,
        name: 'CARTA DE AVERBAÇÃO PARA EMPRÉSTIMO CONSIGNADO.'
      },
      {
        code: 4798,
        name: 'Elaboração de Normatizações'
      },
      {
        code: 4799,
        name: 'Apoio Técnico ao Sistema de Protocolo Único'
      },
      {
        code: 4800,
        name: 'Protocolo de Processos'
      },
      {
        code: 4801,
        name: 'ADMISSÃO DE ESTAGIÁRIOS'
      },
      {
        code: 4802,
        name: 'ATO DE NOMEAÇÃO'
      },
      {
        code: 4803,
        name: 'Gerir o portal da Transparência da Prefeitura Municipal, assegurando o direito de acesso à informação e observância dos dados.'
      },
      {
        code: 4804,
        name: 'ATOS DE EXONERAÇÃO'
      },
      {
        code: 4805,
        name: 'LICENÇA PRÊMIO'
      },
      {
        code: 4806,
        name: 'LICENÇA PARA TRATAR DE INTERESSES PARTICULARES'
      },
      {
        code: 4807,
        name: 'PAGAMENTO DE ESTAGIÁRIOS'
      },
      {
        code: 4808,
        name: 'ELABORAÇÃO DA FOLHA DE PAGAMENTO DOS SERVIDORES'
      },
      {
        code: 4809,
        name: 'LANÇAMENTO DE FÉRIAS'
      },
      {
        code: 4810,
        name: 'CESSÃO DE SERVIDOR'
      },
      {
        code: 4811,
        name: 'SELEÇÕES PÚBLICAS'
      },
      {
        code: 4813,
        name: 'APOSENTADORIA POR IPM (INSTITUTO DE PREVIDÊNCIA DO MUNICÍPIO)'
      },
      {
        code: 4814,
        name: 'INFORMAÇÃO DE G FIP'
      },
      {
        code: 4815,
        name: 'GESTÃO DE CONTRATOS E TERCEIRIZAÇÃO DE MÃO DE OBRA'
      },
      {
        code: 4816,
        name: 'APOSENTADORIA POR TEMPO DE CONTRIBUIÇÃO E POR IDADE'
      },
      {
        code: 4817,
        name: 'CAPACITAÇÃO'
      },
      {
        code: 4818,
        name: 'PROFISSIOGRÁFICO PREVIDENCIÁRIO'
      },
      {
        code: 4819,
        name: 'CONSULTAS AMBULATORIAIS DE EGRESSOS CLÍNICOS E PEDIÁTRICOS NO HOSPITAL GERAL DR WALDEMAR ALCANTARA'
      },
      {
        code: 4822,
        name: 'IMPLANTAÇÃO DO ENSINO MÉDIO EM TEMPO INTEGRAL - E.E.M.T.I.'
      },
      {
        code: 4823,
        name: 'REALIZAÇÃO DE EXAMES LABORATORIAIS E DE IMAGEM'
      },
      {
        code: 4824,
        name: 'O FÓRUM MAIS PRÓXIMO DA SOCIEDADE'
      },
      {
        code: 9999,
        name: 'Outros',
        other_organs: true
      }
    ]

    service_types_data.each do |service_type_data|
      service_type = ServiceType.find_or_initialize_by(name: service_type_data[:name])

      service_type.update_attributes!(service_type_data)
    end
  end
end
