namespace :ppa do
  namespace :axes do
    desc 'Creates Axis for 2020-2023'
    task create_axes: :environment do
      AXES = [
        {'1': 'CEARÁ ACOLHEDOR'},
        {'2': 'CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS'},
        {'3': 'CEARÁ DE OPORTUNIDADES'},
        {'4': 'CEARÁ DO CONHECIMENTO'},
        {'5': 'CEARÁ PACÍFICO'},
        {'6': 'CEARÁ SAUDÁVEL'},
        {'7': 'CEARÁ SUSTENTÁVEL'}
      ]

      plan = PPA::Plan.where(start_year: '2020', end_year: '2023')

      if !plan.empty?
        AXES.each do |axis|
          PPA::Axis.create(code: axis.keys[0], name: axis.values[0], plan_id: plan.first.id)
          puts "Inserido Eixo: #{axis.values[0]} - Código: #{axis.keys[0]}"
        end
      else
        puts 'Plano 2020-2023 Não cadastrado'
      end
    end #/ task create_axes
  end #/ namespace :axes

  namespace :themes do
    desc 'Creates Themes for 2020-2023'
    task create_themes: :environment do
      
      THEMES = [
        { code_axis: '1',
          code_theme: '1.01',
          description_theme: 'ASSISTÊNCIA SOCIAL',
          detailded_theme_description: 'Aborda os serviços, programas, projetos e benefícios relativos à assistência social com foco na prevenção de situações de risco, no fortalecimento de vínculos familiares e no atendimento às pessoas que já se encontram em situações de risco e/ou tiveram seus direitos violados ou vínculos familiares e/ou comunitários rompidos.'
        },
        { code_axis: '1',
          code_theme: '1.02',
          description_theme: 'HABITAÇÃO',
          detailded_theme_description: 'Trata as questões relativas ao enfrentamento do déficit habitacional e à inadequação domiciliar no Estado, com o objetivo de proporcionar moradia digna à população de baixa renda.'
        },
        { code_axis: '1',
          code_theme: '1.03',
          description_theme: 'INCLUSÃO SOCIAL E DIREITOS HUMANOS',
          detailded_theme_description: 'Fundamenta-se na dignidade da pessoa humana como direito constitucional, respeitando a diversidade e priorizando os segmentos vulneráveis e suas potencialidades.'
        },
        { code_axis: '1',
          code_theme: '1.04',
          description_theme: 'SEGURANÇA ALIMENTAR E NUTRICIONAL',
          detailded_theme_description: 'Abrange a garantia de acesso regular e permanente a alimentos de qualidade e em quantidade adequada com o objetivo para promoção de uma alimentação saudável, respeitando a diversidade cultural e os hábitos sustentáveis.'
        },
        { code_axis: '2',
          code_theme: '2.01',
          description_theme: 'GESTÃO E DESENVOLVIMENTO DE PESSOAS',
          detailded_theme_description: 'Abrange as ações de qualificação, valorização, dimensionamento e alocação efetiva e equitativa dos agentes públicos estaduais.'
        },
        { code_axis: '2',
          code_theme: '2.02',
          description_theme: 'GESTÃO FISCAL',
          detailded_theme_description: 'Aborda questões relativas ao desenvolvimento da agropecuária mediante o apoio à agricultura familiar e incremento do agronegócio, com foco no combate à pobreza rural, no apoio à transição agroecológica e na convivência com o semiárido.'
        },
        { code_axis: '2',
          code_theme: '2.03',
          description_theme: 'PLANEJAMENTO E MODERNIZAÇÃO DA GESTÃO',
          detailded_theme_description: 'Busca um planejamento e gestão pública estaduais inovadores, eficientes e efetivos para o atendimento das necessidades e demandas sociais das regiões do estado.'
        },
        { code_axis: '2',
          code_theme: '2.04',
          description_theme: 'TRANSPARÊNCIA, ÉTICA E CONTROLE',
          detailded_theme_description: 'Refere-se à promoção da transparência, ética e controle no âmbito das políticas públicas de forma ampla e efetiva.'
        },
        { code_axis: '3',
          code_theme: '3.01',
          description_theme: 'AGRICULTURA FAMILIAR E AGRONEGÓCIO',
          detailded_theme_description: 'Aborda questões relativas ao desenvolvimento da agropecuária mediante o apoio à agricultura familiar e incremento do agronegócio, com foco no combate à pobreza rural, no apoio à transição agroecológica e na convivência com o semiárido.'
        },
        { code_axis: '3',
          code_theme: '3.02',
          description_theme: 'COMÉRCIO E SERVIÇOS',
          detailded_theme_description: 'Destina-se ao desenvolvimento de atividades capazes de ampliar a competitividade do setor terciário, buscando torná-lo inovador, de alto valor agregado e regionalizado.'
        },
        { code_axis: '3',
          code_theme: '3.03',
          description_theme: 'INDÚSTRIA',
          detailded_theme_description: 'Contempla aspectos relativos à diversificação, qualificação da mão de obra industrial e incremento da inovação e da produtividade do setor para gerar uma nova dinâmica e desenvolvimento tecnológico à indústria cearense.'
        },
        { code_axis: '3',
          code_theme: '3.04',
          description_theme: 'INFRAESTRUTURA E MOBILIDADE',
          detailded_theme_description: 'Compreende a execução, conservação e fiscalização de obras públicas e modais de transporte de pessoas e cargas, além de requalificação urbana, visando a promoção do desenvolvimento sustentável.'
        },
        { code_axis: '3',
          code_theme: '3.05',
          description_theme: 'PESCA E AQUICULTURA',
          detailded_theme_description: 'Aborda o estímulo à produção do pescado e promoção do desenvolvimento da aquicultura cearense como uma importante alternativa econômica para pequenos, médios e grandes produtores do setor pesqueiro e aquícola.'
        },
        { code_axis: '3',
          code_theme: '3.06',
          description_theme: 'TRABALHO E EMPREENDEDORISMO',
          detailded_theme_description: 'Envolve ações que dão suporte aos empreendedores, especialmente microempreendedores individuais e microempresas, além de projetos de qualificação profissional, oportunizando a interiorização das ações e o atendimento às demandas dos setores produtivos.'
        },
        { code_axis: '3',
          code_theme: '3.07',
          description_theme: 'TURISMO',
          detailded_theme_description: 'Contempla ações relativas à reestruturação econômica, marketing promocional, implantação de infraestrutura urbana e turística, qualificação de mão de obra e captação de negócios e investimentos turísticos para o Ceará.',
        },
        { code_axis: '4',
          code_theme: '4.01',
          description_theme: 'CIÊNCIA, TECNOLOGIA E INOVAÇÃO',
          detailded_theme_description: 'Abrange medidas de incentivo à inovação e à pesquisa científica e tecnológica no ambiente produtivo, com vistas à capacitação e ao alcance da autonomia tecnológica para o desenvolvimento do Ceará.'
        },
        { code_axis: '4',
          code_theme: '4.02',
          description_theme: 'CULTURA E ARTE',
          detailded_theme_description: 'Contempla aspectos como identidade, diversidade, transversalidade, expressão, sentimento de pertença e de reconhecimento da população, promovendo o desenvolvimento inovador, criativo e humano com grande potencial gerador de ocupações e emprego.'
        },
        { code_axis: '4',
          code_theme: '4.03',
          description_theme: 'EDUCAÇÃO BÁSICA',
          detailded_theme_description: 'Formação que abrange a educação infantil, o ensino fundamental e o ensino médio com o objetivo de assegurar ao educando a formação comum indispensável para o exercício da cidadania e fornecer-lhe meios para progredir na vida estudantil e no trabalho.',
        },
        { code_axis: '4',
          code_theme: '4.04',
          description_theme: 'EDUCAÇÃO PROFISSIONAL',
          detailded_theme_description: 'Modalidade de ensino que atua no desenvolvimento de habilidades e capacitação de adolescentes, jovens e adultos para o mundo do trabalho, sendo dividida em: integrada ao ensino médio, concomitante e subsequente.'
        },
        { code_axis: '4',
          code_theme: '4.05',
          description_theme: 'EDUCAÇÃO SUPERIOR',
          detailded_theme_description: 'Compreende estudos de graduação e de pós-graduação, bem como estudos e formação de natureza vocacional, formação intelectual e técnica e geração de conhecimento, constituindo-se numa base imprescindível para o desenvolvimento econômico e social do Estado.'
        },
        { code_axis: '5',
          code_theme: '5.01',
          description_theme: 'JUSTIÇA',
          detailded_theme_description: 'Abrange ações conjuntas de defesa, restauração e transformação social, com base em cumprimento de princípios constitucionais, assegurando o respeito à liberdade, individualidade e igualdade a todos os cidadãos.'
        },
        { code_axis: '5',
          code_theme: '5.02',
          description_theme: 'SEGURANÇA PÚBLICA',
          detailded_theme_description: 'Fundamenta-se na busca por uma cultura de paz, focada numa convivência mais pacífica e articulada entre cidadãos, com redução da criminalidade e ampliação da garantia de proteção à vida e ao patrimônio.'
        },
        { code_axis: '6',
          code_theme: '6.01',
          description_theme: 'ESPORTE E LAZER',
          detailded_theme_description: 'Aborda as políticas sociais e intersetoriais no contexto esportivo, com perspectiva de melhoria das condições de saúde e qualidade de vida da população por meio de uma visão integrada e capaz de promover mudanças estruturais no cotidiano da sociedade.'
        },
        { code_axis: '6',
          code_theme: '6.02',
          description_theme: 'SANEAMENTO BÁSICO',
          detailded_theme_description: 'Aborda as questões relativas ao abastecimento da água, esgotamento sanitário e drenagem urbana, as quais têm reflexo direto nas condições de saúde da população e no desenvolvimento social.'
        },
        { code_axis: '6',
          code_theme: '6.03',
          description_theme: 'SAÚDE',
          detailded_theme_description: 'Abrange as ações setoriais e intersetoriais focadas no bem-estar físico, mental e social da população, com destaque para os serviços de saúde ofertados ao público, especialmente aos mais carentes.'
        },
        { code_axis: '7',
          code_theme: '7.01',
          description_theme: 'ENERGIAS',
          detailded_theme_description: 'Prioriza as energias renováveis como alternativas de fontes energéticas, tanto pela sua disponibilidade garantida, como pelo seu menor impacto ambiental, contribuindo para a expansão do desenvolvimento econômico do Estado.'
        },
        { code_axis: '7',
          code_theme: '7.02',
          description_theme: 'MEIO AMBIENTE',
          detailded_theme_description: 'Aborda questões relativas à conservação, recuperação, proteção da cobertura vegetal e dos solos, disciplina na disposição dos resíduos sólidos e revitalização de áreas urbanas degradadas, assegurando a sustentabilidade no uso dos recursos naturais.'
        },
        { code_axis: '7',
          code_theme: '7.03',
          description_theme: 'RECURSOS HÍDRICOS',
          detailded_theme_description: 'Contempla as questões relativas a oferta e distribuição de água no território cearense, assim como a gestão democrática dos recursos hídricos disponíveis.'
        }
      ]

      plan = PPA::Plan.where(start_year: '2020', end_year: '2023').first

      THEMES.each do |theme|

        axes = plan.axes.where(code: theme[:code_axis])
        axis = nil
        if !axes.empty?
          axis = axes.first
        else
          raise "Não foi localizado o eixo #{theme[:code_axis]}, no tema #{theme[:code_theme]}, para o plano #{plan.id}"
        end

        ActiveRecord::Base.transaction do

          result = PPA::Theme.create(
            axis_id: axis.id, 
            code: theme[:code_theme], 
            name: theme[:description_theme], 
            description: theme[:detailded_theme_description]
          )

          if result.errors.empty?
            puts "Tema salvo com sucesso: #{theme[:description_theme]} | Código: #{theme[:code_theme]}"
          else
            raise "### Tema #{theme[:description_theme]} | Código: #{theme[:code_theme]} | ERROR: #{result.errors.messages}"
          end
        end
      end #/ THEMES.each
    end #/ task create_themes
  end #/ namespace :themes

end #/ namespace :ppa