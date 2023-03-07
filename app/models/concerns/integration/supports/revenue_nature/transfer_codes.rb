class  Integration::Supports::RevenueNature < ApplicationDataRecord
  module TransferCodes
    extend ActiveSupport::Concern

    # Receitas consideradas transferências (obrigatórias e voluntárias)

    TRANSFER_CODES = {
      required: [
        '117213501', # Transferências do Salário-Educação
        '117212230', # Cota-parte Royalties - Compensação Financeira pela Produção de Petróleo - Lei nº 7.990/89
        '117210101', # Cota-Parte do Fundo de Participação dos Estados e do Distrito Federal117210112 - Cota-Parte do Imposto Sobre Produtos Industrializados - Estados Exportadores de Produtos Industrializados
        '117210112', # Cota-Parte da Contribuição de Intervenção no Domínio Econômico
        '117210113', # Cota-Parte do Imposto Sobre Operações de Crédito, Câmbio e Seguro, ou Relativas a Títulos ou Valores Mobiliários - Comercialização do Ouro
        '117210132', # Não encontrado.
        '117610700', # Não encontrado.
        '117430000', # Não encontrado.
        '117440000', # Não encontrado.
        '117210901', # Não encontrado.
        '124710700',  # Não encontrado.
        '1718011101', # Cota-Parte do Fundo de Participação dos Estados e do Distrito Federal
        '1718011199', # Cota-Parte do Fundo de Participação dos Estados e do Distrito Federal - FUNDEB
        '1718016101', # Cota-Parte do Imposto Sobre Produtos Industrializados – Estados Exportadores de Produtos Industrializados
        '1718016199', # Cota-Parte do Imposto Sobre Produtos Industrializados – Estados Exportadores de Produtos Industrializados - FUNDEB
        '1718017101', # Cota-Parte da Contribuição de Intervenção no Domínio Econômico
        '1718018101', # Cota-Parte do Imposto Sobre Operações de Crédito, Câmbio e Seguro, ou Relativas a Títulos ou Valores Mobiliários – Comercialização do Ouro
        '1718021101', # Cota-parte da Compensação Financeira de Recursos Hídricos
        '1718022101', # Cota-parte da Compensação Financeira de Recursos Minerais - CFEM
        '1718023101', # Cota-parte Royalties – Compensação Financeira pela Produção de Petróleo – Lei nº 7.990/89
        '1718024101', # Cota-parte Royalties pelo Excedente da Produção do Petróleo – Lei nº 9.478/97, artigo 49, I e II
        '1718025101', # Cota-parte Royalties pela Participação Especial – Lei nº 9.478/97, artigo 50
        '1718026101', # Cota-Parte do Fundo Especial do Petróleo – FEP
        '1718029101', # Outras Transferências decorrentes de Compensação Financeira pela Exploração de Recursos Naturais
        '1718031101', # Atenção Básica - Piso de Atenção Básica Fixo (PAB Fixo)
        '1718031102', # Atenção Básica - Saúde da Família
        '1718031103', # Atenção Básica - Agentes Comunitários de Saúde
        '1718031104', # Atenção Básica - Saúde Bucal
        '1718031105', # Atenção Básica - Compensação de Especificidades Regionais
        '1718031106', # Atenção Básica - Fator Incentivo Atenção Básica  -  Povos Indígenas
        '1718031107', # Atenção Básica - Incentivo Atenção à Saúde -  Sistema Penitenciário
        '1718031108', # Atenção Básica - Incentivo: Atenção Integral à Saúde do Adolescente
        '1718031109', # Atenção Básica - Núcleo Apoio Saúde Família
        '1718031110', # Atenção Básica - Outros Programas Financ por Transf Fundo a Fundo
        '1718032101', # MAC TF - Teto financeiro
        '1718032102', # MAC TF - SAMU - Serviço de Atendimento Móvel de Urgência
        '1718032103', # MAC TF - CEO -  Centro Espec Odontológica
        '1718032104', # MAC TF - CAPS - Centro de Atenção Psicosocial
        '1718032105', # MAC TF - CEREST - Centro de Ref em Saúde do Trabalhador
        '1718032106', # MAC TF - Outros Programas Financ por Transf Fundo a Fundo
        '1718032107', # MAC FAEC - CNRAC -  Centro Nacional Regulação de Alta Complex
        '1718032108', # MAC FAEC - Terapia Renal Substitutiva
        '1718032109', # MAC FAEC - Transplantes - Cornea
        '1718032110', # MAC FAEC - Transplantes - Rim
        '1718032111', # MAC FAEC - Transplantes  - Fígado
        '1718032112', # MAC FAEC - Transplantes  - Pulmão
        '1718032113', # MAC FAEC - Transplantes  - Coração
        '1718032114', # MAC FAEC - Transplantes - Outros
        '1718032199', # MAC FAEC - Outros Programas Financ por Transf Fundo a Fundo
        '1718033101', # V SAÚDE - Vigilância Epidmiológica e Ambiental em Saúde
        '1718033102', # V SAÚDE - Vigilância Sanitária
        '1718033199', # V SAÚDE - Outros Programas Financ por Transf Fundo a Fundo (6)
        '1718034101', # A FARM - Componente Básico da Assistência Farmacêutica
        '1718034102', # A FARM - Componente Estratégico da Assistência Farmacêutica
        '1718034103', # A FARM - Componente Medicamentos de Dispensação Excepcional
        '1718034199', # A FARM - Outros Programas Financ por Transf Fundo a Fundo (6)
        '1718035101', # G SUS - Qualificação da Gestão do SUS
        '1718035102', # G SUS - Implantação de Ações e Serviços de Saúde
        '1718035199', # G SUS - Outros Programas Financ por Transf Fundo a Fundo (6)
        '1718039101', # Outros Programas Financ por Transf Fundo a Fundo
        '1718051101', # Transferências do Salário-Educação
        '1718053101', # Transferências Diretas do FNDE referentes ao Programa Nacional de Alimentação Escolar – PNAE
        '1718054101', # Transferências Diretas do FNDE referentes ao Programa Nacional de Apoio ao Transporte do Escolar – PNATE
        '1718061101', # Transferência Financeira do ICMS – Desoneração – LC Nº 87/96
        '1718061199', # Transferência Financeira do ICMS – Desoneração – L.C. Nº 87/96 - FUNDEB - Principal
        '1718091101', # Complementação da União ao FUNDEB do Exercício 
        '1718091102', # Complementação da União ao FUNDEB de Exercícios Anteriores
        '1718111101', # Transferência de Recursos do Fundo Penitenciário Nacional - Fupen
        '1718121101', # Transferências de Recursos do Fundo Nacional de Assistência Social – FNAS
        '1718991101', # Transferências ao Fundo de Defesa Civil
        '1718991102', # Transferências Oriundas da Lei Pelé
        '1718991199', # Outras Transferências da União
        '1728021101', # Cota-parte da Compensação Financeira de Recursos Hídricos
        '1728022101', # Cota-parte da Compensação Financeira de Recursos Minerais - CFEM
        '1728023101', # Cota-parte Royalties – Compensação Financeira pela Produção do Petróleo – Lei nº 7.990/89, artigo 9º
        '1728029101', # Outras Transferências Decorrentes de Compensações Financeiras
        '1738991101', # Transferências SUS - Assistência Farmacêutica - Municípios
        '1738991102', # Transferências SUS - Média e Alta Complexidade Ambulatorial e Hospitalar - Municípios
        '1738991199', # Outras Transferências dos Municípios
        '1758011101', # Transferências de Recursos do Fundo de Manutenção e Desenvolvimento da Educação Básica e de Valorização dos Profissionais da Educação – FUNDEB
        '1758012101', # Transferências de Recursos da Complementação da União ao Fundo de Manutenção e Desenvolvimento da Educação Básica e de Valorização dos Profissionais da Educação – FUNDEB - Exercício
        '1758012102', # Transferências de Recursos da Complementação da União ao Fundo de Manutenção e Desenvolvimento da Educação Básica e de Valorização dos Profissionais da Educação – FUNDEB - Exercícios Anteriores
        '1758991199', # Outras Transferências Multigovernamentais
        '2418031101', # Transferência de Recursos do SUS – Atenção Básica
        '2418991101', # Transferências ao Fundo de Defesa Civil
        '2418991102', # Transferencias do Fundo Penitenciario Nacional - FUPEN
        '2418991198' # Outras Transferências da União
      ],

      voluntary: [
        '117212220', # Cota-parte da Compensação Financeira de Recursos Minerais - CFEM
        '117212240', # Cota-parte Royalties pelo Excedente da Produção do Petróleo - Lei nº 9.478/97, artigo 49, I e II
        '117212270', # Atenção Básica - Saúde Bucal
        '117213333', # MAC TF - Teto financeiro
        '117213336', # MAC TF - CEO -  Centro Espec. Odontológica
        '117213339', # MAC TF - Outros Programas Financ. por Transf. Fundo a Fundo
        '117213341', # MAC FAEC - Transplantes - Outros
        '117213342', # V SAÚDE - Vigilância Epidmiológica e Ambiental em Saúde
        '117213343', # V SAÚDE - Vigilância Sanitária
        '117213345', # A FARM - Componente Medicamentos de Dispensação Excepcional
        '117213349', # G SUS - Outros Programas Financ por Transf Fundo a Fundo (6)
        '117213358', # Transferências Diretas do FNDE referentes ao Programa Nacional de Apoio ao Transporte do Escolar - PNATE
        '117213359', # Outras Transferências Diretas do Fundo Nacional do Desenvolvimento da Educação - FNDE
        '117213361', # Transferência Financeira do ICMS - Desoneração - L.C. Nº 87/96
        '117213362', # Transferências ao Fundo de Defesa Civil
        '117213363', # Transferências Oriundas da Lei Pelé
        '117213373', # Transferências de Recursos do Sistema Único de Saúde - SUS
        '117213389', # Transferências de Recursos do Fundo de Manutenção e Desenvolvimento da Educação Básica e de Valorização dos Profissionais da Educação - FUNDEB
        '117213400', # Complementação do FUNDEB de Exercícios anteriores
        '117213503', # Transferências de Instituições Privadas
        '117213504', # Transferências de Convênios da União para o Sistema Único de Saúde - SUS
        '117213599', # Outras Transferências de Convênios da União
        '117213600', # Transferências de Convênio dos Municípios para o Sistema Único de Saúde – SUS
        '117219951', # Outras Transferências de Convênios dos Municípios
        '117219952', # Transferência de Convênios de Instituições Privadas
        '117230100', # Transferências de Recursos Destinados a Programas de Educação
        '117240100', # Transferências do Exterior
        '117240251', # Transferências de Convênio da União para o Sistema Único de Saúde - SUS
        '117240252', # Transferências de Convênio da União destinadas a Programas de Educação
        '117300000', # Transferências de Convênios da União destinadas a Programas de Saneamento Básico
        '117500000', # Transferências de Convênios da União destinadas a Programas de Infra-Estrutura em Transporte
        '117610100', # Outras Transferências de Convênios dos Municípios
        '117610200', # Cota-Parte do Fundo Especial do Petróleo - FEP
        '117619900', # Atenção Básica - Incentivo Atenção à Saúde -  Sistema Penitenciário
        '117630100', # Atenção Básica - Outros Programas Financ. por Transf. Fundo a Fundo
        '117639900', # MAC TF - SAMU - Serviço de Atendimento Móvel de Urgência
        '117640000', # MAC TF - CEREST - Centro de Ref. em Saúde do Trabalhador
        '117650000', # MAC FAEC - Outros Programas Financ por Transf Fundo a Fundo
        '124210100', # V SAÚDE - Outros Programas Financ por Transf Fundo a Fundo (6)
        '124230100', # Transferências de Recursos do Fundo Nacional de Assistência Social - FNAS
        '124230200', # Transferências Diretas do FNDE referentes ao Programa Nacional de Alimentação Escolar - PNAE
        '124300000', # Complementação do FUNDEB do Exercício
        '124400000', # Transferências de Pessoas
        '124710100', # Transferências de Convênios da União Destinadas a Programas de Educação
        '124710200', # Transferência de Convênios do Exterior
        '124710300', # Transferências de Recursos do Sistema Único de Saúde - SUS
        '124710400', # Transferências de Recursos Destinados a Programas de Saúde
        '124710500', # Transferências de Instituições Privadas
        '124719900', # Transferências de Convênios da União destinadas a Programas de Meio Ambiente
        '124739999',  # Outras Transferências de Convênios da União
        '1718052101', # Transferências Diretas do FNDE referentes ao Programa Dinheiro Direto na Escola – PDDE
        '1718059101', # Outras Transferências Diretas do Fundo Nacional do Desenvolvimento da Educação – FNDE
        '1718071101', # Transferências da União a Consórcios Públicos
        '1718101101', # Transferências de Convênios da União para o Sistema Único de Saúde – SUS
        '1718102101', # Transferências de Convênios da União Destinadas a Programas de Educação
        '1718103101', # Transferências de Convênios da União Destinadas a Programas de Assistência Social
        '1718104101', # Transferências de Convênios da União Destinadas a Programas de Combate à Fome
        '1718105101', # Transferências de Convênios da União Destinadas a Programas de Saneamento Básic
        '1718109101', # Outras Transferências de Convênios da União
        '1728041101', # Transferências de Estados a Consórcios Públicos
        '1728101101', # Transferências de Convênio dos Estados para o Sistema Único de Saúde – SUS
        '1728102101', # Transferências de Convênio dos Estados Destinadas a Programas de Educação
        '1728109199', # Outras Transferências de Convênio dos Estados
        '1738101101', # Transferências de Convênio dos Municípios para o Sistema Único de Saúde – SUS
        '1738102101', # Transferências de Convênio dos Municípios destinadas a Programas de Educação
        '1748101101', # Transferências de Instituições Privadas
        '1748101102', # Transferência de Convênios de Instituições Privadas
        '1760001101', # Transferências do Exterior
        '1768019199', # Outras Transferência de Convênios do Exterior - Não Especificadas Anteriormente
        '1770001101', # Transferências de Pessoas Físicas
        '1778019101', # Transferências de Pessoas Físicas
        '2418011101', # Transferências da União a Consórcios Públicos
        '2418051101', # Transferências do FNDE para Programa de Fomento à Implantação de Escolas em Tempo Integral
        '2418101101', # Transferências de Convênio da União para o Sistema Único de Saúde – SUS
        '2418102101', # Transferências de Convênio da União destinadas a Programas de Educação
        '2418105101', # Transferências de Convênios da União destinadas a Programas de Saneamento Básico
        '2418106101', # Transferências de Convênios da União destinadas a Programas de Meio Ambiente
        '2418107101', # Transferências de Convênios da União destinadas a Programas de Infra-Estrutura em Transporte
        '2418991199', # Outras Transferências de Convênios da União
        '2430001101', # Transferências de Municípios a Consórcios Públicos
        '2438101101', # Transferências de Convênios dos Municípios destinados a Programas de Saúde
        '2438102101', # Transferências de Convênios dos Municípios destinadas a Programas de Educação
        '2438109101', # Outras Transferências de Convênios dos Municípios
        '2438991198', # Outras Transferências dos Municípios
        '2448011101', # Transferências de Convênios de Instituições Privadas Destinados a Programas de Saúde
        '2448101101', # Outras Transferências de Instituições Privadas
        '2458011101', # Transferências de Outras Instituições Públicas
        '2468101101', # Transferências do Exterior
        '2468101199', # Outras Transferências do Exterior Não Especificadas Anteiormente
        '2470001101' # Transferências de Pessoas Físicas
      ]
    }
    
  end  
end
