
# Rake para criar os resultados de busca padrão de páginas estáticas

namespace :search_contents do
  namespace :pages do
    desc 'Cria ou atualiza os resultados de busca de páginas estáticas'
    task create_or_update: :environment do

      search_contents = [
        {
          title: "Acessibilidade",
          description: "Acessibilidade",
          content: "acessibilidade",
          link: "portal-da-transparencia/paginas/acessibilidade",
          locale: "pt-BR"
        },
        {
          title: "Acesso à informação",
          description: "Não encontrou a informação que queria? Peça aqui.",
          content: "acesso informacao informacoes sic transparencia",
          link: "portal-da-transparencia/paginas/acesso-a-informacao",
          locale: "pt-BR"
        },
        {
          title: "Access to Information",
          description: "Request access to information which, for some reason, have not been made available in the Transparency Portal.",
          content: "access information sic transparency",
          link: "portal-da-transparencia/paginas/acesso-a-informacao",
          locale: "en"
        },
        {
          title: "Acceso a la información",
          description: "Solicita el acceso a informaciones que, por alguna razón, no hayan sido disponibilizadas en el Portal de la Transparencia.",
          content: "accesso informacion informaciones sic transparencia",
          link: "portal-da-transparencia/paginas/acesso-a-informacao",
          locale: "es"
        },
        {
          title: "Balanço Geral do Estado",
          description: "Consulte a prestação de contas do Governador do Estado, com informações de origem das receitas e destinação de recursos públicos. Veja ainda demonstrativos e balanços de entidades vinculadas ao governo do Estado.",
          content: "balanco geral estado prestacao contas demonstrativos",
          link: "portal-da-transparencia/paginas/balanco-geral-do-estado",
          locale: "pt-BR"
        },
        {
          title: "State General Balance",
          description: "Verify the legal reporting of the State Governor, with information from the origin of revenues and allocation of public resources. You can also check statements and balances from institutionslinkd to the State government.",
          content: "state general balance revenues statements",
          link: "portal-da-transparencia/paginas/balanco-geral-do-estado",
          locale: "en"
        },
        {
          title: "Balance General del Estado",
          description: "Consulte la rendición de cuentas del Gobernador del Estado, con informaciones de origen de los ingresos y asignación de recursos públicos. Consulte todavía demostrativos y balances de entidades vinculadas al gobierno de Estado.",
          content: "balance general estado rendicion cuentas demostrativos",
          link: "portal-da-transparencia/paginas/balanco-geral-do-estado",
          locale: "es"
        },
        {
          title: "Cartão Corporativo",
          description: "Nessa página são disponibilizados os gastos com cartão corporativo instituído pelo Decreto n° 28.801/2007.",
          content: "cartao corporativo 28.801/2007 15.175/2012 gastos",
          link: "portal-da-transparencia/paginas/cartao-corporativo",
          locale: "pt-BR"
        },
        {
          title: "Corporate Card",
          description: "On this page, all expenses on Corporate Card are made available, according to the established Decree n° 28801/2007.",
          content: "corporate card expenses 28.801/2007 15.175/2012",
          link: "portal-da-transparencia/paginas/cartao-corporativo",
          locale: "en"
        },
        {
          title: "Tarjeta corporativa",
          description: "En esta página están disponibles los gastos con tarjeta corporativa instituida por el Decreto Nº 28.801/2007.",
          content: "tarejeta corporativa gastos 28.801/2007 15.175/2012",
          link: "portal-da-transparencia/paginas/cartao-corporativo",
          locale: "es"
        },
        {
          title: "Comitê de Gestão por Resultados e Gestão Fiscal - COGERF",
          description: "O Comitê de Gestão por Resultados e Gestão Fiscal – COGERF, regulamentado pelo Decreto Estadual nº 32.173/2017, tem como premissas a importância da boa gestão fiscal e da administração por resultados na viabilização do compromisso do governo de promover o bem-estar dos Cearenses...",
          content: "cogerf comite gestao resultados fiscal 21.173/2017",
          link: "portal-da-transparencia/paginas/comite-de-gestao-por-resultados-e-gestao-fiscal-cogerf",
          locale: "pt-BR"
        },
        {
          title: "Committee of Result-Oriented Management and Tax Management – COGERF",
          description: "The Committee of Result-Oriented Management and Tax Management – COGERF, ruled by the State Decree nº 32.173/2017, has as its propositions the importance of effective tax management and the result-oriented administration in the fruition of the government’s engagement on promoting the well-being of Cearense people...",
          content: "cogerf committee result management tax 21.173/2017",
          link: "portal-da-transparencia/paginas/comite-de-gestao-por-resultados-e-gestao-fiscal-cogerf",
          locale: "en"
        },
        {
          title: "Comité de Gestión por Resultados y Gestión Fiscal - COGERF",
          description: "El Comité de Gestión por Resultados y Gestión Fiscal - COGERF, regulado por el Decreto Estatal nº 32.173 / 2017, tiene como premisas la importancia de la buena gestión fiscal y de la administración por resultados en la viabilización del compromiso del gobierno de promover el bienestar de los Cearenses...",
          content: "cogerf comite gestion resultados fiscas 21.173/2017",
          link: "portal-da-transparencia/paginas/comite-de-gestao-por-resultados-e-gestao-fiscal-cogerf",
          locale: "es"
        },
        {
          title: "Controle Interno Preventivo",
          description: "O Controle Interno Preventivo consiste em uma metodologia de controle baseada no gerenciamento dos riscos identificados em atividades e processos, com vistas à eficiência e regularidade da gestão, proporcionando maior segurança administrativa na tomada de decisão pelos gestores estaduais...",
          content: "controle interno preventivo risco riscos processo processos fragilidades plano acao convenios",
          link: "portal-da-transparencia/paginas/controle-interno-preventivo",
          locale: "pt-BR"
        },
        {
          title: "Internal Preventive Control",
          description: "The Internal Preventive Control consists of a methodology of control based on the control of risks identified in activities and processes, aiming at efficiency and regularity of the management, allowing for more administrative security in the decision making by the state administrators...",
          content: "internal preventive control risk risks process processes weaknesses action plan covenants",
          link: "portal-da-transparencia/paginas/controle-interno-preventivo",
          locale: "en"
        },
        {
          title: "Control Interno Preventivo",
          description: "El Control Interno Preventivo consiste en una metodología de control basada en la gestión de los riesgos identificados en actividades y procesos, con miras a la eficiencia y regularidad de la gestión, que proporciona mayor seguridad administrativa en la toma de decisión por los gestores estaduales...",
          content: "control interno preventivo riesgo riesgos proceso procesos plan accion fragilidades convenios",
          link: "portal-da-transparencia/paginas/controle-interno-preventivo",
          locale: "es"
        },
        {
          title: "Despesas com Pessoal",
          description: "Corresponde à remuneração total dos funcionários em efetivo serviço acrescida: da contribuição do Estado para sua futura aposentadoria; e do pagamento das aposentadorias ou pensões dos funcionários já aposentados.",
          content: "despesas pessoal remuneracao funcionarios aposentadoria",
          link: "portal-da-transparencia/paginas/despesas-com-pessoal",
          locale: "pt-BR"
        },
        {
          title: "Expenses on Personnel",
          description: "This Corresponds to the total remuneration of the working personnel, Including the state contribution for their future retirement. And the pension payment of the retired ones.",
          content: "expenses personnes remuneration working retirement",
          link: "portal-da-transparencia/paginas/despesas-com-pessoal",
          locale: "en"
        },
        {
          title: "Gastos de personal",
          description: "Corresponde a la remuneración total de los funcionarios en efectivo servicio incrementado: de la contribución del Estado para su futura jubilación; y el pago de las jubilaciones o pensiones de los funcionarios ya jubilados.",
          content: "gastos personal remuneracion funcionarios jubilacion",
          link: "portal-da-transparencia/paginas/despesas-com-pessoal",
          locale: "es"
        },
        {
          title: "Diagnóstico das manifestações da ouvidoria da secretaria do trabalho e desenvolvimento social do estado do ceará (stds) com foco na resolubilidade",
          description: "Diagnóstico das manifestações da ouvidoria da secretaria do trabalho e desenvolvimento social do estado do ceará (stds) com foco na resolubilidade",
          content: "diagnostico manifestacoes ouvidoria resolubilidade",
          link: "portal-da-transparencia/paginas/diagnostico-das-manifestacoes-da-ouvidoria-da-secretaria-do-trabalho-e-desenvolvimento-social-do-estado-do-ceara-stds-com-foco-na-resolubilidade",
          locale: "pt-BR"
        },
        {
          title: "Dívida Consolidada Líquida",
          description: "Corresponde ao montante das obrigações assumidas pelo Estado (chamada, nos termos do Art. 29, I da LRF de Dívida Consolidada) deduzindo-se os haveres financeiros não vinculados a outros pagamentos.",
          content: "divida consolidada liquida lrf",
          link: "portal-da-transparencia/paginas/divida-consolidada-liquida",
          locale: "pt-BR"
        },
        {
          title: "Consolidated Net Debt",
          description: "It corresponds to the amount of financial obligations taken by the State (Known as Consolidated Debt according to LRF, Art. 29, I).",
          content: "consolidated net debt lrf",
          link: "portal-da-transparencia/paginas/divida-consolidada-liquida",
          locale: "en"
        },
        {
          title: "Deuda Neta Consolidada",
          description: "Corresponde al importe de las obligaciones asumidas por el Estado (llamada, de conformidad con el artículo 29, I de la LRF de Deuda Consolidada) deduciéndose los haberes financieros no vinculados a otros pagos.",
          content: "deuda neta consolidada lrf",
          link: "portal-da-transparencia/paginas/divida-consolidada-liquida",
          locale: "es"
        },
        {
          title: "Dúvidas Frequentes",
          description: "Veja as dúvidas frequentes.",
          content: "duvida duvidas frequentes questoes faq ajuda ?",
          link: "portal-da-transparencia/paginas/duvidas-frequentes",
          locale: "pt-BR"
        },
        {
          title: "Frequent Questions",
          description: "Check the frequent questions.",
          content: "frequent questions question faq help ?",
          link: "portal-da-transparencia/paginas/duvidas-frequentes",
          locale: "en"
        },
        {
          title: "Perguntas Frecuentes",
          description: "Ver las perguntas frecuentes",
          content: "duvida duvidas frecuentes faq ayuda ?",
          link: "portal-da-transparencia/paginas/duvidas-frequentes",
          locale: "es"
        },
        {
          title: "Educação",
          description: "Acompanhe aqui os gastos com Educação e compare com o valor mínimo de aplicação.",
          content: "educacao gastos despesas ensino",
          link: "portal-da-transparencia/paginas/educacao",
          locale: "pt-BR"
        },
        {
          title: "Education",
          description: "Follow here the expenses on education, and compare to the minimum application value.",
          content: "education expenses",
          link: "portal-da-transparencia/paginas/educacao",
          locale: "en"
        },
        {
          title: "Educación",
          description: "Acompañe aquí los gastos con Educación y compárelos al valor mínimo de aplicación.",
          content: "gastos educacion",
          link: "portal-da-transparencia/paginas/educacao",
          locale: "es"
        },
        {
          title: "Endereços e telefones",
          description: "Veja aqui endereço, telefone, horário de funcionamento e site institucional dos órgãos e entidades do Poder Executivo estadual Aqui também é possível verificar as informações de outras instituições como de escolas, delegacias e etc.",
          content: "endereco enderecos telefone telefones contato horario funcionamento",
          link: "portal-da-transparencia/paginas/enderecos-e-telefones",
          locale: "pt-BR"
        },
        {
          title: "Addresses and phone numbers",
          description: "Find here institutional information of the State executive Power organs and entities, such as: Address, phone number, working hours and website. It is also possible to find information about each organ’s branches, such as: schools, police stations, etc.",
          content: "address addresses phone contact working hours",
          link: "portal-da-transparencia/paginas/enderecos-e-telefones",
          locale: "en"
        },
        {
          title: "Direcciones y teléfonos",
          description: "Compruebe aquí informaciones institucionales de los órganos y entidades del poder ejecutivo estadual, como dirección, teléfono, horario de funcionamiento y sitio institucional. Aquí también es posible verificar las informaciones de las unidades de atención de cada órgano, como direcciones de escuelas, comisarías, etc.",
          content: "direccion direcciones telefono telefonos horario funcionamiento",
          link: "portal-da-transparencia/paginas/enderecos-e-telefones",
          locale: "es"
        },
        {
          title: "Estrutura Organizacional",
          description: "Aqui você poderá consultar informações sobre a estrutura organizacional do poder executivo estadual, além das informações institucionais de cada órgão, como endereço, telefone, horário de funcionamento e site institucional.",
          content: "estrutura organizacional enderecos telefones horario funcionamento competencias",
          link: "portal-da-transparencia/paginas/estrutura-organizacional",
          locale: "pt-BR"
        },
        {
          title: "Organizational structure",
          description: "Here you can see the state executive Power structure, and also, institutional information of each department, such as: phone numbers, address, working hours and website.",
          content: "organizational structure addresses phone working hours competences",
          link: "portal-da-transparencia/paginas/estrutura-organizacional",
          locale: "en"
        },
        {
          title: "Estructura Organizacional",
          description: "Aquí usted podrá consultar informaciones sobre la estructura organizativa del poder ejecutivo estadual, además de las informaciones institucionales de cada órgano, como dirección, teléfono, horario de funcionamiento y sitio institucional.",
          content: "estructura organizacional direcciones telefono horario funcionamiento competencias",
          link: "portal-da-transparencia/paginas/estrutura-organizacional",
          locale: "es"
        },
        {
          title: "Ferramentas de Controle Social",
          description: "A Ouvidoria atua como canal de intermediação do processo de participação popular, possibilitando ao cidadão contribuir com a implementação das políticas públicas e a avaliação dos serviços prestados.",
          content: "ferramentas controle social ouvidoria acesso informacao 15.175/2012 31.198 29.887/2009",
          link: "portal-da-transparencia/paginas/ferramentas-de-controle-social",
          locale: "pt-BR"
        },
        {
          title: "Social Control Tools",
          description: "The Ombudsman acts as an intermediary channel in the process of popular engagement, allowing the citizen to contribute with the implementation of public policies and assessment of services provided.",
          content: "social control tools ombudsman information access 15.175/2012 31.198 29.887/2009",
          link: "portal-da-transparencia/paginas/ferramentas-de-controle-social",
          locale: "en"
        },
        {
          title: "Herramientas de Control Social",
          description: "La Oidoría actúa como canal de intermediación del proceso de participación popular, posibilitando al ciudadano contribuir con la implementación de las políticas públicas y la evaluación de los servicios prestados.",
          content: "herramientas control social oidoria acceso informacion 15.175/2012 31.198 29.887/2009",
          link: "portal-da-transparencia/paginas/ferramentas-de-controle-social",
          locale: "es"
        },
        {
          title: "Garantia e Contragarantias",
          description: "As Garantias são concedidas pelo Governo do Estado com o objetivo de garantir o pagamento de obrigações financeiras assumidas por algum órgão do Estado, ou órgão ligado a ele, no caso de uma eventual falta de pagamento. As contragarantias, por sua vez, devem ser constituídas quando o Estado, ou algum órgão ligado a ele, atua como garantidor em uma operação de crédito.",
          content: "garantia garantias contragarantia contragarantias obrigacoes financeiras",
          link: "portal-da-transparencia/paginas/garantia-e-contragarantias",
          locale: "pt-BR"
        },
        {
          title: "Guarantees and Counter-guarantees",
          description: "The guarantees are given by the state government in order to ensure the payments of debts taken by any state entity, or entities which are related to the state, in case of defaults. Counter-guarantees must be defined when the state, or any related entity work as a guarantor in a credit operation.",
          content: "guarantee guarantees counter-guarantee counter-guarantees",
          link: "portal-da-transparencia/paginas/garantia-e-contragarantias",
          locale: "en"
        },
        {
          title: "Garantía y Contragarantía",
          description: "Las Garantías son concedidas por el Gobierno del Estado con el objetivo de asegurar el pago de obligaciones financieras asumidas por algún organismo del Estado, o entidad vinculada a él, en el caso de una eventual falta de pago. Las contragarantías, a su vez, deben ser constituidas cuando el Estado, o alguna entidad vinculada a él, actúa como garante en una operación de crédito.",
          content: "garantia contragarantia garantias contragarantias",
          link: "portal-da-transparencia/paginas/garantia-e-contragarantias",
          locale: "es"
        },
        {
          title: "Gestão participativa",
          description: "O modelo de gestão participativa confere ênfase às pessoas, tornando importante o envolvimento de todos, cidadãos e servidores públicos, contribuindo para a obtenção de melhores resultados para a Administração Pública, beneficiando à sociedade.",
          content: "gestao participativa ppa ouvidoria ideias participativo",
          link: "portal-da-transparencia/paginas/participative-management",
          locale: "pt-BR"
        },
        {
          title: "Participative management",
          description: "The participative management model focuses on people, which requests all the parts engagement, citizens and public servants, achieving better results for the public administration, which benefits society in general.",
          content: "participative management ombudsman ppa ideas",
          link: "portal-da-transparencia/paginas/participative-management",
          locale: "en"
        },
        {
          title: "Gestión Participativa",
          description: "El modelo de gestión participativa confiere énfasis a las personas, dándole importancia a la participación de todos, ciudadanos y servidores públicos, contribuyendo a la obtención de mejores resultados para la Administración Pública, en beneficio de la sociedad.",
          content: "gestion participativa ppa oidoria ideas participativo",
          link: "portal-da-transparencia/paginas/participative-management",
          locale: "es"
        },
        {
          title: "Gestão por Resultados",
          description: "Gestão Pública por resultados (GPR) envolve planejamento, equilíbrio, transparência e controle. Tudo em busca de indicadores quantitativos capazes de justificar, com resultados mensuráveis, a atuação dos órgãos públicos.",
          content: "gestao publica resultados gpr",
          link: "portal-da-transparencia/paginas/gestao-por-resultados",
          locale: "pt-BR"
        },
        {
          title: "Public Management by Results",
          description: "Public Management by Results (GPR) involves plannings, balance, transparency and control, all of which are focused on obtaining quantitative indicators capable of justifying, in measurable results, the actions of public bodies.",
          content: "public management results gpr",
          link: "portal-da-transparencia/paginas/gestao-por-resultados",
          locale: "en"
        },
        {
          title: "Gestión Pública por Resultados",
          description: "La Gestión Pública por Resultados (GPR) implica planificación, equilibrio, transparencia y control. Todo en busca de indicadores cuantitativos capaces de justificar, con resultados mensurables, la actuación de los órganos públicos",
          content: "gestion publica resultados gpr",
          link: "portal-da-transparencia/paginas/gestao-por-resultados",
          locale: "es"
        },
        {
          title: "Indicadores Complementares",
          description: "Veja aqui indicadores socieconômicos e informações para a análise do desempenho do comércio, indústria e mercado de trabalho cearense a partir de relatórios elaborados pelo IPECE.",
          content: "indicadores complementares",
          link: "portal-da-transparencia/paginas/indicadores-complementares",
          locale: "pt-BR"
        },
        {
          title: "Complementary Indicators",
          description: "See here socioeconomic indicators and information for the trade performance analyses, industry and the labor market of Ceará based on reports by IPECE.",
          content: "complementary indicators",
          link: "portal-da-transparencia/paginas/indicadores-complementares",
          locale: "en"
        },
        {
          title: "Indicadores Complementarios",
          description: "En el presente trabajo se analizan los resultados obtenidos en el análisis del desempeño del comercio, industria y mercado de trabajo cearense a partir de informes elaborados por el IPECE.",
          content: "indicadores complementarios",
          link: "portal-da-transparencia/paginas/indicadores-complementares",
          locale: "es"
        },
        {
          title: "Informações Socioeconômicas",
          description: "Os Indicadores Socioeconômicos vem na perspectiva de contribuir para uma adequada análise das condições sociais em que se encontra a população do Estado, enfatizando suas necessidades básicas.",
          content: "informacoes socioeconomicas",
          link: "portal-da-transparencia/paginas/informacoes-socioeconomicas",
          locale: "pt-BR"
        },
        {
          title: "Socioeconomic Information",
          description: "The Socioeconomic Indicators have been created in the hopes of contributing to an adequate analysis of the social conditions in which the people of the State are, emphasizing their basic needs.",
          content: "socioeconomic informations",
          link: "portal-da-transparencia/paginas/informacoes-socioeconomicas",
          locale: "en"
        },
        {
          title: "Informaciones Socioeconómicas",
          description: "Los Indicadores Socioeconómicos vienen en la perspectiva de contribuir a un adecuado análisis de las condiciones sociales en que se encuentra la población del Estado, enfatizando sus necesidades básicas.",
          content: "informacion socioeconomica",
          link: "portal-da-transparencia/paginas/informacoes-socioeconomicas",
          locale: "es"
        },
        {
          title: "LDO - Lei de Diretrizes Orçamentárias",
          description: "A Lei de Diretrizes Orçamentárias define as metas e prioridades da administração pública estadual, incluindo as despesas de capital para o exercício financeiro subseqüente, orienta a elaboração da lei orçamentária anual, dispõe sobre política de recursos humanos, dívida pública e alterações na legislação tributária.",
          content: "ldo lei diretrizes orcamentarias",
          link: "portal-da-transparencia/paginas/ldo-lei-de-diretrizes-orcamentarias",
          locale: "pt-BR"
        },
        {
          title: "LBG – Law of Budgetary Guidelines",
          description: "The Law of Budgetary Guidelines defines the goals and priorities of the state public administration, including the capital expenditures for the subsequent financial year, guides the elaboration of the yearly budgetary law, provides on the human resources policies, public debt and changes in the tax legislation.",
          content: "ldo lbg law budgetary guidelines",
          link: "portal-da-transparencia/paginas/ldo-lei-de-diretrizes-orcamentarias",
          locale: "en"
        },
        {
          title: "LDO - Ley de Directrices Presupuestarias",
          description: "La Ley de Directrices Presupuestarias define las metas y prioridades de la administración pública estatal, incluyendo los gastos de capital para el ejercicio financiero subsiguiente, orienta la elaboración de la ley presupuestaria anual, dispone sobre política de recursos humanos, deuda pública y cambios en la legislación tributaria.",
          content: "ldo ley directrices presupuestarias",
          link: "portal-da-transparencia/paginas/ldo-lei-de-diretrizes-orcamentarias",
          locale: "es"
        },
        {
          title: "Lei Orçamentária Anual",
          description: "Encontre aqui a discriminação da receita e despesa do Estado. Veja quanto foi orçado para cada programa de governo.",
          content: "loa lei orcamentaria anual receita despesa orcamento",
          link: "portal-da-transparencia/paginas/lei-orcamentaria-anual",
          locale: "pt-BR"
        },
        {
          title: "ABL – Annual Budgetary Law",
          description: "Find here the breakdown of State revenues and expenditures. Verify how much has been estimated for each governmental program.",
          content: "loa abl annual budgetary law revenues expenditures budget",
          link: "portal-da-transparencia/paginas/lei-orcamentaria-anual",
          locale: "en"
        },
        {
          title: "LOA - Ley Presupuestaria Anual",
          description: "Encuentre aquí la discriminación de los ingresos y gastos del Estado. Vea cuánto ha sido presupuestado para cada programa de gobierno.",
          content: "loa ley presupuestaria anual ingresos gastos presupuesto",
          link: "portal-da-transparencia/paginas/lei-orcamentaria-anual",
          locale: "es"
        },
        {
          title: "Leis orçamentárias",
          description: "Conheça o processo de planejamento das receitas e despesas consultando as leis que estabelecem objetivos, prioridades, metas e discriminam as receitas e despesas previstas.",
          content: "leis orcamentarias ppa ldo loa",
          link: "portal-da-transparencia/paginas/leis-orcamentarias",
          locale: "pt-BR"
        },
        {
          title: "Budget laws",
          description: "Learn the process of planning revenues and expenses by consulting the laws that set goals, priorities, targets and break down anticipated revenues and expenses.",
          content: "budget laws ppa ldo loa abl",
          link: "portal-da-transparencia/paginas/leis-orcamentarias",
          locale: "en"
        },
        {
          title: "Leis orçamentárias",
          description: "Conozca el proceso de planificación de los ingresos y gastos consultando las leyes que establecen objetivos, prioridades, metas y discriminan los ingresos y gastos previstos.",
          content: "leis orcamentarias ppa ldo loa",
          link: "portal-da-transparencia/paginas/leis-orcamentarias",
          locale: "es"
        },
        {
          title: "Licitações",
          description: "Consulte aqui as informações sobre os procedimentos licitatórios do Estado, aqui é possível verificar informações de editais, avisos, valores, vencedores e etc.",
          content: "licitacao licitacoes editais manual fornecedores inidoneos suspensos",
          link: "portal-da-transparencia/paginas/licitacoes",
          locale: "pt-BR"
        },
        {
          title: "Bids",
          description: "Check here the information about the bidding procedures of the State. Here you can also find information about notices, notifications, values, successful bidders, etc.",
          content: "bid bids manual disreputable suspended suppliers",
          link: "portal-da-transparencia/paginas/licitacoes",
          locale: "en"
        },
        {
          title: "Licitaciones",
          description: "Consulte aquí la información sobre los procedimientos licitatorios del Estado, aquí es posible verificar informaciones de llamadas públicas, avisos, valores, ganadores, etc.",
          content: "licitacion licitaciones manual suspendidos ineptos",
          link: "portal-da-transparencia/paginas/licitacoes",
          locale: "es"
        },
        {
          title: "MAPP - Monitoramento de Ações e Projetos Prioritários",
          description: "O Monitoramento de Ações e Projetos Prioritários – MAPP consiste numa ferramenta informatizada, onde o Governador do Estado, a partir de proposições feitas pelos Secretários de cada área, prioriza os projetos a serem executados.",
          content: "mapp monitoramento acoes projetos prioritarios",
          link: "portal-da-transparencia/paginas/mapp-monitoramento-de-acoes-e-projetos-prioritarios",
          locale: "pt-BR"
        },
        {
          title: "MPAP - Monitoring of Priority Actions and Projects",
          description: "The Monitoring of Priority Actions and Projects – MPAP – consists of an informatized tool, whereby the State Governor, starting from proposals made by Secretaries in different areas, prioritizes projects to be carried out.",
          content: "mapp mpap monitoring priority actions projects",
          link: "portal-da-transparencia/paginas/mapp-monitoramento-de-acoes-e-projetos-prioritarios",
          locale: "en"
        },
        {
          title: "MAPP - Monitoreo de Acciones y Proyectos Prioritarios",
          description: "El Monitoreo de Acciones y Proyectos Prioritarios - MAPP consiste en una herramienta informática, donde el Gobernador del Estado, a partir de proposiciones hechas por los Secretarios de cada área del gobierno prioriza los proyectos que serán ejecutados.",
          content: "mapp monitoreo acciones proyectos prioritarios",
          link: "portal-da-transparencia/paginas/mapp-monitoramento-de-acoes-e-projetos-prioritarios",
          locale: "es"
        },
        {
          title: "Modelo de Governança",
          description: "O modelo de governança contempla a gestão participativa, com destaque ao PPA Participativo, Ouvidoria e o Banco de idéias.",
          content: "modelo governanca ppa mapp",
          link: "portal-da-transparencia/paginas/modelo-de-governanca",
          locale: "pt-BR"
        },
        {
          title: "Government Model",
          description: "The governance model focuses on the participatory management, highlighting the inclusive MAP (Multiannual Plan), Ombudsman and the Bank of Ideas.",
          content: "government model map mpap",
          link: "portal-da-transparencia/paginas/modelo-de-governanca",
          locale: "en"
        },
        {
          title: "Modelo de Gobernanza",
          description: "El modelo de gobernanza contempla la gestión participativa, con destaque el PPA Participativo, la Atención Ciudadana y el Banco de ideas.",
          content: "modelo gobernanza ppa mapp",
          link: "portal-da-transparencia/paginas/modelo-de-governanca",
          locale: "es"
        },
        {
          title: "O estado do Ceará",
          description: "O Estado do Ceará está localizado na região Nordeste do Brasil e possui uma área total de 148.886,308 km². Faz divisa, ao Norte, com o oceano Atlântico; ao Sul, com o estado de Pernambuco; a Leste, com os estados do Rio Grande do Norte e Paraíba; e a Oeste, com o estado do Piauí. São 573 quilômetros de litoral...",
          content: "estado ceara imempi proade provin pcdm investimento",
          link: "portal-da-transparencia/paginas/o-estado-do-ceara",
          locale: "pt-BR"
        },
        {
          title: "The State of Ceará",
          description: "The State of Ceará is located in the Northeast region of Brazil and covers an área of 148,886.308 square kilometers. Its north borders the Atlantic Ocean; its South borders the state of Pernambuco; the Rio Grande do Norte and Paraíba states are East; and the Piauí is located West. Its coast is 573 kilometers long...",
          content: "state ceara imempi proade provin pcdm investment",
          link: "portal-da-transparencia/paginas/o-estado-do-ceara",
          locale: "en"
        },
        {
          title: "El Estado de Ceará",
          description: "El Estado de Ceará está ubicado en la región Nordeste de Brasil y posee un área total de 148.886,308 km². Hace frontera, al Norte, con el Océano Atlántico; al sur, con el estado de Pernambuco; al este, con los estados de Rio Grande do Norte y Paraíba; y al oeste, con el estado de Piauí. Son 573 kilómetros de costa...",
          content: "estado ceara imempi proade provin pcdm invertimento",
          link: "portal-da-transparencia/paginas/o-estado-do-ceara",
          locale: "es"
        },
        {
          title: "Operação de Crédito",
          description: "Corresponde à contratação de obrigação financeira por parte do Estado, que, somada às obrigações já existentes, formará o saldo da Dívida Consolidada Líquida. De acordo com Resolução do Senado, seu volume não poderá ultrapassar 16% da receita corrente líquida.",
          content: "operacao credito",
          link: "portal-da-transparencia/paginas/operacao-de-credito",
          locale: "pt-BR"
        },
        {
          title: "Credit operations",
          description: "It corresponds to the acquisition of financial obligations by the state, which, added to the existing ones, will form the total amount of the Consolidated Net Debt. According to the senate resolution, it can not be over 16% of the current net revenue.",
          content: "credit operations",
          link: "portal-da-transparencia/paginas/operacao-de-credito",
          locale: "en"
        },
        {
          title: "Operación de Crédito",
          description: "Corresponde a la contratación de obligación financiera por parte del Estado, que, sumada a las obligaciones ya existentes, formará el saldo de la Deuda Neta Consolidada. De acuerdo con Resolución del Senado, su volumen no podrá sobrepasar el 16% del ingreso corriente neto.",
          content: "operacion de credito",
          link: "portal-da-transparencia/paginas/operacao-de-credito",
          locale: "es"
        },
        {
          title: "Ouvidoria",
          description: "No contexto da gestão pública, a Ouvidoria é o canal de comunicação principal entre os cidadãos e as várias instituições governamentais.",
          content: "ouvidoria manifestacao atendimento contato",
          link: "portal-da-transparencia/paginas/ouvidoria",
          locale: "pt-BR"
        },
        {
          title: "Ombudsman",
          description: "In the context of public management, the Ombudsman is the main communication channel between citizens and the different governmental institutions.",
          content: "omsbudman manifestation contact",
          link: "portal-da-transparencia/paginas/ouvidoria",
          locale: "en"
        },
        {
          title: "Oidoría",
          description: "En el contexto de la gestión pública, la Oidoría es el canal de comunicación principal entre los ciudadanos y las diversas instituciones gubernamentales.",
          content: "oidoria manisfetacion contacto",
          link: "portal-da-transparencia/paginas/ouvidoria",
          locale: "es"
        },
        {
          title: "PIB",
          description: "Veja em relatórios abaixo o desempenho do Produto Interno Bruto (PIB) a partir de toda riqueza gerada nos setores econômicos do Estado do Ceará.",
          content: "pib produto interno bruto",
          link: "portal-da-transparencia/paginas/pib",
          locale: "pt-BR"
        },
        {
          title: "PIB GDP",
          description: "See on reports below, the performance of Ceara’s Gross Domestic Product, the result of all wealth generated in all the economy segments of the state.",
          content: "pib gdp gross domestic product",
          link: "portal-da-transparencia/paginas/pib",
          locale: "en"
        },
        {
          title: "PIB",
          description: "Observe en los informes a continuación el desempeño del Producto Interno Bruto (PIB) a partir de toda riqueza generada en los sectores económicos del Estado de Ceará.",
          content: "pib producto interno bruto",
          link: "portal-da-transparencia/paginas/pib",
          locale: "es"
        },
        {
          title: "PIB Trimestral",
          description: "Trata-se de um instrumento de acompanhamento do desempenho da economia de curto prazo, possibilitando um acompanhamento mais ágil do ambiente econômico.",
          content: "pib produto interno bruto trimestral",
          link: "portal-da-transparencia/paginas/pib-trimestral",
          locale: "pt-BR"
        },
        {
          title: "Tri-monthly GDP",
          description: "It is tool that keeps track of the short term economy performance, enabling a more agile economic environment follow up.",
          content: "pib gdp gross domestic product tri-monthly",
          link: "portal-da-transparencia/paginas/pib-trimestral",
          locale: "en"
        },
        {
          title: "PIB Trimestral",
          description: "Se trata de un instrumento de acompañamiento del desempeño de la economía a corto plazo, que posibilita un seguimiento más ágil del ambiente económico.",
          content: "pib producto interno bruto trimestral",
          link: "portal-da-transparencia/paginas/pib-trimestral",
          locale: "es"
        },
        {
          title: "PPA - Plano Plurianual",
          description: "Veja aqui a Lei que estabelece de forma regionalizada as diretrizes, objetivos e metas da administração pública estadual para as despesas públicas e indicações de receitas para um período de 4 anos.",
          content: "ppa plano plurianul",
          link: "portal-da-transparencia/paginas/ppa-plano-plurianual",
          locale: "pt-BR"
        },
        {
          title: "MAP – Multiannual Plan",
          description: "Find out that the Law establishes the guidelines, objectives and goals regionally for state public administration and recommendations of revenue for a 4-year period.",
          content: "ppa map multiannual plan",
          link: "portal-da-transparencia/paginas/ppa-plano-plurianual",
          locale: "en"
        },
        {
          title: "PPA - Plan Plurianual",
          description: "Acompañe aquí la ley que establece de forma regionalizada las directrices, objetivos y metas de la administración pública estadual para los gastos públicos e indicaciones de ingresos para un periodo de 4 años.",
          content: "ppa plan plurianual",
          link: "portal-da-transparencia/paginas/ppa-plano-plurianual",
          locale: "es"
        },
        {
          title: "Prioridades e Políticas de Governo",
          description: "A execução de políticas públicas estão apoiadas em sete grandes Eixos de Governo, denominados 7 Cearás...",
          content: "prioridades politicas governo",
          link: "portal-da-transparencia/paginas/prioridades-e-politicas-de-governo",
          locale: "pt-BR"
        },
        {
          title: "Government Policies and Priorities",
          description: "The execution of public policies are backed by seven large Government Axes, named “7 Cearás”...",
          content: "government policies priorities",
          link: "portal-da-transparencia/paginas/prioridades-e-politicas-de-governo",
          locale: "en"
        },
        {
          title: "Prioridades y Políticas de Gobierno",
          description: "La ejecución de políticas públicas está apoyada en siete grandes Ejes de Gobierno, denominados 7 Cearás...",
          content: "prioridades politicas gobierno",
          link: "portal-da-transparencia/paginas/prioridades-e-politicas-de-governo",
          locale: "es"
        },
        {
          title: "Radar",
          description: "Consulte, por meio de relatórios elaborados pelo Ipece, informações para a análise do desempenho do comércio, indústria e mercado de trabalho cearense.",
          content: "radar relatorio relatorios ipece analise",
          link: "portal-da-transparencia/paginas/radar",
          locale: "pt-BR"
        },
        {
          title: "Radar",
          description: "Check here, through reports written by the IPECE, data for the analysis of performance in commerce, industry and the cearense labor market.",
          content: "radar report reports opece analysis",
          link: "portal-da-transparencia/paginas/radar",
          locale: "en"
        },
        {
          title: "Radar",
          description: "Consulte, a través de informes elaborados por el Ipece, informaciones para el análisis del desempeño del comercio, industria y mercado de trabajo cearense.",
          content: "radar report reports analisis ipece",
          link: "portal-da-transparencia/paginas/radar",
          locale: "es"
        },
        {
          title: "Radar - Comércio",
          description: "O Radar do Comércio disponibiliza os principais indicadores que permitem uma análise global do desempenho do comércio cearense com periodicidade mensal e defasagem de dois meses.",
          content: "radar relatorio relatorios ipece analise comercio",
          link: "portal-da-transparencia/paginas/radar-comercio",
          locale: "pt-BR"
        },
        {
          title: "Radar – Commerce",
          description: "The commerce Radar shows the main indicators that allow a global analysis of the cearense commerce segment performance, on a monthly basis, with a two-month gap.",
          content: "radar report reports opece analysis commerce",
          link: "portal-da-transparencia/paginas/radar-comercio",
          locale: "en"
        },
        {
          title: "Radar - Comercio",
          description: "El Radar del Comercio ofrece los principales indicadores que permiten un análisis global del desempeño del comercio cearense con periodicidad mensual y desfase de dos meses.",
          content: "radar report reports analisis ipece comercio",
          link: "portal-da-transparencia/paginas/radar-comercio",
          locale: "es"
        },
        {
          title: "Radar - Comércio Exterior",
          description: "O Radar do Comércio Exterior publicado mensalmente pelo Instituto de Pesquisa e Estratégia Econômica do Ceará – Ipece tem por objetivo disponibilizar informações relativas à evolução das principais variáveis do comércio exterior cearense.",
          content: "radar relatorio relatorios ipece analise comercio exterior",
          link: "portal-da-transparencia/paginas/radar-comercio-exterior",
          locale: "pt-BR"
        },
        {
          title: "Radar – Foreign trade",
          description: "The foreign trade radar, published every three months by the Ceara Economic strategy and research institute - Ipece – aims at providing information regarding the cearense foreign trade main.",
          content: "radar report reports opece analysis foreign trade",
          link: "portal-da-transparencia/paginas/radar-comercio-exterior",
          locale: "en"
        },
        {
          title: "Radar - Comercio Exterior",
          description: "l Radar del Comercio Exterior publicado mensualmente por el Instituto de Investigación y Estrategia Económica de Ceará - Ipece tiene por objetivo disponibilizar informaciones relativas a la evolución de las principales variables del comercio exterior cearense.",
          content: "radar relatorio relatorios ipece analise comercio exterior",
          link: "portal-da-transparencia/paginas/radar-comercio-exterior",
          locale: "es"
        },
        {
          title: "Radar - Emprego",
          description: "O Radar do Emprego divulga mensalmente as informações sobre o mercado de trabalho cearense utilizando os dados do Cadastro Geral de Empregados e Desempregados (CAGED)/MTE, sintetizando os principais resultados para o Ceará e evidenciando comparações com outras unidades da federação.",
          content: "radar relatorio relatorios ipece analise emprego",
          link: "portal-da-transparencia/paginas/radar-emprego",
          locale: "pt-BR"
        },
        {
          title: "Radar - Employment",
          description: "The employment radar releases on a monthly basis, information concerning the labor market in the state, using data from the “general employed and unemployed database”, synthesizing the main results for Ceará, and emphasising comparisons to the other federation units.",
          content: "radar report reports opece analysis employment",
          link: "portal-da-transparencia/paginas/radar-emprego",
          locale: "en"
        },
        {
          title: "Radar - Empleo",
          description: "El Radar del Empleo divulga mensualmente las informaciones sobre el mercado de trabajo cearense con base en los datos del Registro General de Empleados y Desempleados (CAGED)/MTE, sintetiza los principales resultados para Ceará y da relieve a comparaciones con otras unidades de la federación.",
          content: "radar report reports analisis ipece empleo",
          link: "portal-da-transparencia/paginas/radar-emprego",
          locale: "es"
        },
        {
          title: "Radar - Indústria",
          description: "O Radar da Indústria a partir da apresentação de um conjunto selecionado de indicadores permite uma rápida avaliação do desempenho mensal da indústria cearense.",
          content: "radar relatorio relatorios ipece analise industria",
          link: "portal-da-transparencia/paginas/radar-industria",
          locale: "pt-BR"
        },
        {
          title: "Radar - Industry",
          description: "The Industry radar is based on a set of selected indicators, which enable a fast monthly performance evaluation of the Cearense Industry segment.",
          content: "radar report reports opece analysis industry",
          link: "portal-da-transparencia/paginas/radar-industria",
          locale: "en"
        },
        {
          title: "Radar - Industria",
          description: "El Radar de la Industria a partir de la presentación de un conjunto seleccionado de indicadores permite una rápida evaluación del desempeño mensual de la industria cearense.",
          content: "radar relatorio relatorios ipece analise industria",
          link: "portal-da-transparencia/paginas/radar-industria",
          locale: "es"
        },
        {
          title: "Radar - Inflação",
          description: "O Radar da Inflação, de caráter mensal, objetiva monitorar a inflação da Região Metropolitana de Fortaleza (RMF) a partir de um comparativo com a inflação nacional. O documento contém seis indicadores",
          content: "radar relatorio relatorios ipece analise inflacao",
          link: "portal-da-transparencia/paginas/radar-inflacao",
          locale: "pt-BR"
        },
        {
          title: "Radar - inflation",
          description: "The inflation radar, monthly published, aims at monitoring the inflation rates in the Fortaleza metropolitan área, in comparison to the national inflation. The document contains six indicators",
          content: "radar report reports opece analysis inflation",
          link: "portal-da-transparencia/paginas/radar-inflacao",
          locale: "en"
        },
        {
          title: "Radar - inflación",
          description: "El Radar de la Inflación, de carácter mensual, tiene como objetivo monitorear la inflación de la Región Metropolitana de Fortaleza (RMF) a partir de un comparativo con la inflación nacional. El documento contiene seis indicadores.",
          content: "radar report reports analisis ipece inflacion",
          link: "portal-da-transparencia/paginas/radar-inflacao",
          locale: "es"
        },
        {
          title: "Receita Corrente Líquida",
          description: "A Receita Corrente Líquida corresponde às diversas receitas recebidas pelo Estado do Ceará nos últimos 12 (doze) meses, inclusive os valores recebidos por transferências da União, diminuídas: das transferências obrigatórias para os Municípios; das contribuições para a aposentadoria dos Servidores Estaduais; e contribuição para o desenvolvimento do Ensino Básico.",
          content: "receita corrente liquida",
          link: "portal-da-transparencia/paginas/receita-corrente-liquida",
          locale: "pt-BR"
        },
        {
          title: "Current net revenue",
          description: "This corresponds to the várious revenues received by the ceara state in the last 12 months, including those received through transferences from the federal union, taking out: The mandatory transfer for cities, the pension of the state retired public servants, and the contribution for the development of basic education.",
          content: "current net revenue",
          link: "portal-da-transparencia/paginas/receita-corrente-liquida",
          locale: "en"
        },
        {
          title: "Ingreso Corriente Neto",
          description: "El Ingreso Corriente Neto corresponde a los diversos ingresos recibidos por el Estado de Ceará en los últimos 12 (doce) meses, inclusive los valores recibidos por transferencias de la Unión, disminuidas: de las transferencias obligatorias para los Municipios; de las contribuciones para la jubilación de los Servidores Estatales; y contribución al desarrollo de la Enseñanza Básica.",
          content: "ingreso corriente neto",
          link: "portal-da-transparencia/paginas/receita-corrente-liquida",
          locale: "es"
        },
        {
          title: "Receitas x Despesas",
          description: "Aqui você encontra informações orçamentárias e financeiras do Estado.",
          content: "receitas despesas orcamentarias financeiras",
          link: "portal-da-transparencia/paginas/receitas-x-despesas",
          locale: "pt-BR"
        },
        {
          title: "Revenues X Expenditures",
          description: "Here you can find budgetary and financial information related to the State.",
          content: "revenues expenditures budgetary financial",
          link: "portal-da-transparencia/paginas/receitas-x-despesas",
          locale: "en"
        },
        {
          title: "Recetas X Gastos",
          description: "Aquí usted encontrará información presupuestaria y financiera del Estado.",
          content: "recetas gastos presupuestaria finaciera",
          link: "portal-da-transparencia/paginas/receitas-x-despesas",
          locale: "es"
        },
        {
          title: "Rede de Ouvidorias",
          description: "A Rede de Ouvidorias é composta pelas Ouvidorias Setoriais dos órgãos e entidades do Poder Executivo Estadual, a quem cabe atuar na apuração e resposta das manifestações apresentadas pelo cidadão.",
          content: "rede ouvidoria ouvidorias",
          link: "portal-da-transparencia/paginas/rede-de-ouvidorias",
          locale: "pt-BR"
        },
        {
          title: "Ombudsman network",
          description: "The ombudsman network is composed by the State Executive Power organs and entities sectorial ombudsman, and they are in charge of dealing with the citizens complaints and manifestations.",
          content: "ombudsman network",
          link: "portal-da-transparencia/paginas/rede-de-ouvidorias",
          locale: "en"
        },
        {
          title: "Red de Oidorías",
          description: "La Red de Oidorías está compuesta por las Oidorías Sectoriales de los órganos y entidades del Poder Ejecutivo Estadual, a quienes corresponde actuar en el examen y respuesta de las manifestaciones presentadas por el ciudadano.",
          content: "red oidoria oidorias",
          link: "portal-da-transparencia/paginas/rede-de-ouvidorias",
          locale: "es"
        },
        {
          title: "Redes de Ouvidorias",
          description: "O modelo de gestão de ouvidorias em rede garante a uniformidade na gestão dos processos e de procedimentos, por meio de atuação integrada das ouvidorias e do compartilhamento de informações e de boas práticas, contribuindo com a implementação e aperfeiçoamento das políticas públicas e a avaliação dos serviços prestados.",
          content: "redes ouvidoria ouvidorias",
          link: "portal-da-transparencia/paginas/redes-de-ouvidorias",
          locale: "pt-BR"
        },
        {
          title: "Ombudsmen Network",
          description: "The model of ombudsman management in a network ensures the uniformity in the administration of processes and procedures by means of integrated action among the ombudsmen and the share of information and good practices, contributing to the implementation and perfecting of public policies and the assessment of services provided.",
          content: "ombudsman ombudsmen network",
          link: "portal-da-transparencia/paginas/redes-de-ouvidorias",
          locale: "en"
        },
        {
          title: "Red de Oidorías",
          description: "El modelo de gestión de auditores en red garantiza la uniformidad en la gestión de los procesos y de los procedimientos, a través de la actuación integrada de las audiencias y del intercambio de información y de buenas prácticas, contribuyendo con la implementación y perfeccionamiento de las políticas públicas y la evaluación de los servicios realizados.",
          content: "red oidoria oidorias",
          link: "portal-da-transparencia/paginas/redes-de-ouvidorias",
          locale: "es"
        },
        {
          title: "Relatório Controle Externo",
          description: "Consulte o relatório e parecer prévio emitidos pelo Tribunal de Contas do Estado do Ceará (TCE) sobre as contas do Governo.",
          content: "relatorio controle externo tce",
          link: "portal-da-transparencia/paginas/relatorio-controle-externo",
          locale: "pt-BR"
        },
        {
          title: "Report of External Control",
          description: "Find out more about the report and prior opinion issued by the Ceará State Court of Auditors on the Government’s Accounts.",
          content: "report external control tce",
          link: "portal-da-transparencia/paginas/relatorio-controle-externo",
          locale: "en"
        },
        {
          title: "Informe Control Externo",
          description: "Consulte el informe y el dictamen previo emitidos por el Tribunal de Cuentas del Estado de Ceará (TCE) sobre las cuentas del Gobierno.",
          content: "informe control externo tce",
          link: "portal-da-transparencia/paginas/relatorio-controle-externo",
          locale: "es"
        },
        {
          title: "Relatório Controle Interno",
          description: "A Controladoria e Ouvidoria Geral do Estado (CGE) elabora anualmente o Relatório do Controle Interno sobre as Contas Anuais do Governo, em atendimento à Lei Estadual n.º 12.509/1995, que estabelece que as Contas do Governo consistirão nos Balanços Gerais do Estado e no Relatório do órgão central do sistema de controle interno do Poder Executivo...",
          content: "relatorio controle interno 12.509/1995 4.320/1964",
          link: "portal-da-transparencia/paginas/relatorio-controle-interno",
          locale: "pt-BR"
        },
        {
          title: "Internal Control Report on the Government’s Annual Accounts",
          description: "The State Controllership and Ombudsman annually writes the Internal Control Report on the Government’s Annual Accounts, in accord with the State Law n.º 12509/1995, which demands that the Government’s Accounts will consist of the General State Balances and the Report of the system’s central body of internal control of the Executive Power...",
          content: "internal control report government annual accounts 12.509/1995 4.320/1964",
          link: "portal-da-transparencia/paginas/relatorio-controle-interno",
          locale: "en"
        },
        {
          title: "Informe de Control Interno sobre las Cuentas Anuales del Gobierno",
          description: "La Contraloría y Oidoría General del Estado (CGE) elabora anualmente el Informe del Control Interno sobre las Cuentas Anuales del Gobierno, en atención a la Ley Estatal nº 12.509 / 1995, que establece que las Cuentas del Gobierno consistirán en los Balances Generales del Estado y en el Informe del órgano central del sistema de control interno del Poder Ejecutivo...",
          content: "informe control interno cuentas anuales gobierno 12.509/1995 4.320/1964",
          link: "portal-da-transparencia/paginas/relatorio-controle-interno",
          locale: "es"
        },
        {
          title: "Relatório de Gestão Fiscal",
          description: "Consulte demonstrativos que expõe as despesas com pessoal, seguridades social e as dívidas contraídas pelo Estado.",
          content: "relatorio gestao fiscal",
          link: "portal-da-transparencia/paginas/fiscal-management-report",
          locale: "pt-BR"
        },
        {
          title: "Fiscal management report",
          description: "Check on reports, the statements that show the expenses on personnel, social security and the debts taken by the state.",
          content: "fiscal management report",
          link: "portal-da-transparencia/paginas/fiscal-management-report",
          locale: "en"
        },
        {
          title: "Informe de Gestión Fiscal",
          description: "Compruebe los informes, las instrucciones que muestran los gastos en personal, seguridad social y los debidos de la parte posterior.",
          content: "informe gestion fiscal",
          link: "portal-da-transparencia/paginas/fiscal-management-report",
          locale: "es"
        },
        {
          title: "Relatório Resumido da Execução Orçamentária",
          description: "Consulte demonstrativos que expõe as despesas com pessoal, seguridades social e as dívidas contraídas pelo Estado.",
          content: "relatorio resumido execucao orcamentaria",
          link: "portal-da-transparencia/paginas/relatorio-resumido-da-execucao-orcamentaria",
          locale: "pt-BR"
        },
        {
          title: "Budget execution summarized report",
          description: "Check on reports the statements that show the expenses on personnel, social security and the debts taken by the state.",
          content: "budget execution summarized report",
          link: "portal-da-transparencia/paginas/relatorio-resumido-da-execucao-orcamentaria",
          locale: "en"
        },
        {
          title: "Informe Resumido de Ejecución Presupuestaria",
          description: "En los informes se muestran los gastos de personal, seguridad social y deudas contraídas por el Estado.",
          content: "informe resumido ejecucion presupuestaria",
          link: "portal-da-transparencia/paginas/relatorio-resumido-da-execucao-orcamentaria",
          locale: "es"
        },
        {
          title: "Resultado Nominal",
          description: "Está relacionado ao aumento ou diminuição do endividamento. Corresponde a diferença entre o saldo da Dívida Fiscal Líquida ao final de um período e o saldo da Dívida Fiscal Líquida do período anterior.",
          content: "resultado nominal divida fiscal",
          link: "portal-da-transparencia/paginas/resultado-nominal",
          locale: "pt-BR"
        },
        {
          title: "Nominal Result",
          description: "It is related to the increase or decrease in debt. It corresponds to the difference between the balance of Liquid Tax Debt at the end of a period and the balance of Liquid Tax Debt of the previous period.",
          content: "nominal result legal forecast",
          link: "portal-da-transparencia/paginas/resultado-nominal",
          locale: "en"
        },
        {
          title: "Resultado Nominal",
          description: "Está relacionado al aumento o disminución del endeudamiento. Corresponde la diferencia entre el saldo de la deuda fiscal neta al final de un período y el saldo de la deuda fiscal neta del período anterior.",
          content: "resultado nominal pronostico legal",
          link: "portal-da-transparencia/paginas/resultado-nominal",
          locale: "es"
        },
        {
          title: "Resultado Primário",
          description: "O resultado primário representa a diferença entre as receitas e as despesas primárias (não financeiras). Sua apuração fornece uma melhor avaliação do impacto da política fiscal em execução pelo ente da Federação.",
          content: "resultado primario superavits deficits",
          link: "portal-da-transparencia/paginas/resultado-primario",
          locale: "pt-BR"
        },
        {
          title: "Primary Result",
          description: "The primary result represents the difference between revenues and primary expenses (not financial). Its calculation offers a better assessment of the impact of tax policies in execution by the entity of the Federation.",
          content: "primary result superavits deficits",
          link: "portal-da-transparencia/paginas/resultado-primario",
          locale: "en"
        },
        {
          title: "Resultado Primário",
          description: "El resultado primario representa la diferencia entre los ingresos y los gastos primarios (no financieros). Su escrutinio proporciona una mejor evaluación del impacto de la política fiscal en ejecución por el ente de la Federación.",
          content: "resultado primario superavits deficits",
          link: "portal-da-transparencia/paginas/resultado-primario",
          locale: "es"
        },
        {
          title: "Resultados",
          description: "Veja aqui os resultados obtidos. Para cada indicador consta um valor programado e um valor realizado por ano.Os indicadores são medidos pelas Secretarias de Estado e transmitidos ao Portal da Transparência pela Secretaria do Planejamento e Gestão.",
          content: "resultado resultados indicador indicadores",
          link: "portal-da-transparencia/paginas/resultados",
          locale: "pt-BR"
        },
        {
          title: "Results",
          description: "See here the results obtained. For each indicator there is a programmed value and one value per year.The indicators are measured by the State Secretariats and transmitted to the Transparency Portal by the Planning and Management Secretariat.",
          content: "result results indicator indicators",
          link: "portal-da-transparencia/paginas/resultados",
          locale: "en"
        },
        {
          title: "Resultados",
          description: "Vea aquí los resultados obtenidos. Para cada indicador consta un valor programado y un valor realizado por año. Los indicadores son medidos por las Secretarías de Estado y transmitidos al Portal de la Transparencia por la Secretaría de Planificación y Gestión.",
          content: "resultado resultados indicador indicadores",
          link: "portal-da-transparencia/paginas/resultados",
          locale: "es"
        },
        {
          title: "Rol de documentos classificados com grau de sigilo e o rol de documentos desclassificados dos órgãos e entidades do Poder Executivo Estadual",
          description: "Rol de documentos classificados com grau de sigilo e o rol de documentos desclassificados dos órgãos e entidades do Poder Executivo Estadual",
          content: "rol documentos classificados sigilo",
          link: "portal-da-transparencia/paginas/rol-de-documentos-classificados-com-grau-de-sigilo-e-o-rol-de-documentos-desclassificados-dos-orgaos-e-entidades-do-poder-executivo-estadual",
          locale: "pt-BR"
        },
        {
          title: "Saúde",
          description: "Acompanhe aqui os gastos com saúde e compare com o valor mínimo de aplicação.",
          content: "saude",
          link: "portal-da-transparencia/paginas/saude",
          locale: "pt-BR"
        },
        {
          title: "Health",
          description: "Follow here the expenses on health, and compare them to the minimum application value.",
          content: "health",
          link: "portal-da-transparencia/paginas/saude",
          locale: "en"
        },
        {
          title: "Salud",
          description: "Acompañe aquí los gastos de salud y compárelos al valor mínimo de aplicación.",
          content: "salud",
          link: "portal-da-transparencia/paginas/saude",
          locale: "es"
        },
        {
          title: "Serviços Públicos",
          description: "Consulte serviços públicos disponíveis no estado do Ceará.",
          content: "servico servicos publico publicos",
          link: "portal-da-transparencia/paginas/servicos-publicos",
          locale: "pt-BR"
        },
        {
          title: "Public Services",
          description: "Check public services available in the state of Ceará.",
          content: "public services",
          link: "portal-da-transparencia/paginas/servicos-publicos",
          locale: "en"
        },
        {
          title: "Servicios Públicos",
          description: "Consulte los servicios públicos disponibles en el estado de Ceará.",
          content: "servicio servicios publico publicos",
          link: "portal-da-transparencia/paginas/servicos-publicos",
          locale: "es"
        },
        {
          title: "Sobre o portal",
          description: "O Portal Ceará Transparente tem como objetivo possibilitar que o cidadão se torne um fiscal das ações públicas, aumentando a transparência da gestão e o combate à corrupção no Estado do Ceará, em consonância com a Lei Estadual n.º 13.875/2007 e o Decreto 30.939/2012.",
          content: "sobre portal 13.875/2007 30.939/2012 ceara transparente",
          link: "portal-da-transparencia/paginas/sobre-o-portal",
          locale: "pt-BR"
        },
        {
          title: "About the Portal",
          description: "The Transparency Portal has as an objective enabling the citizen to become a fiscal of public actions, expanding the transparency of the management and combating corruption in the State of Ceará, in accord with State Law n.º 13875/2007 and the Decree 30939/2012.",
          content: "about portal 13.875/2007 30.939/2012 ceara transparente",
          link: "portal-da-transparencia/paginas/sobre-o-portal",
          locale: "en"
        },
        {
          title: "Acerca del Portal",
          description: "El Portal de Transparencia tiene como objetivo posibilitar que el ciudadano se convierta en un fiscal de las acciones públicas, aumentando la transparencia de la gestión y el combate a la corrupción en el Estado de Ceará, en consonancia con la Ley Estadual nº 13.875 / 2007 y el Decreto 30.939 / 2012.",
          content: "acerca portal 13.875/2007 30.939/2012 ceara transparente",
          link: "portal-da-transparencia/paginas/sobre-o-portal",
          locale: "es"
        },
        {
          title: "Transferências Obrigatórias aos Municípios",
          description: "São os repasses obrigatórios que o governo estadual faz de uma parte dos impostos arrecadados por ele no município.",
          content: "transferencias obrigatorias municipios repaases",
          link: "portal-da-transparencia/paginas/cotransferencias-obrigatorias-aos-municipios",
          locale: "pt-BR"
        }
      ]

      search_contents.each do |params|
        I18n.locale = params[:locale]
        search_content = SearchContent.find_or_initialize_by(title: params[:title])
        search_content.assign_attributes(params)

        search_content.save
      end
    end
  end
end
