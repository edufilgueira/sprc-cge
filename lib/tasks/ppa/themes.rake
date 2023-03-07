namespace :themes do
  task update_codes: :environment do
    plan = PPA::Plan.find_by_start_year('2020')

    for theme in plan.themes

      code_1part = theme.code.split('.')[0].to_i
      code_2part = theme.code.split('.')[1].to_i

      if code_2part.digits.count == 1
        theme.update(code: "#{code_1part}.#{code_2part}")
        if theme.errors.present?
          raise "#{theme.errors.inspect}"
        end
        puts "Tema Code: #{theme.code} - #{theme.name}"
      end
    end

  end

  # task create_or_update: :environment do

  #   themes_data = [
  #     {
  #       code: '1.01',
  #       name: 'GESTÃO FISCAL'
  #     },
  #     {
  #       code: '1.02',
  #       name: 'PLANEJAMENTO E GESTÃO'
  #     },
  #     {
  #       code: '1.03',
  #       name: 'TRANSPARÊNCIA, CONTROLE E PARTICIPAÇÃO SOCIAL'
  #     },
  #     {
  #       code: '1.04',
  #       name: 'ADMINISTRAÇÃO GERAL'
  #     },
  #     {
  #       code: '2.01',
  #       name: 'ASSISTÊNCIA SOCIAL'
  #     },
  #     {
  #       code: '2.02',
  #       name: 'HABITAÇÃO'
  #     },
  #     {
  #       code: '2.03',
  #       name: 'INCLUSÃO SOCIAL E DIREITOS HUMANOS'
  #     },
  #     {
  #       code: '2.04',
  #       name: 'SEGURANÇA ALIMENTAR E NUTRICIONAL'
  #     },
  #     {
  #       code: '3.01',
  #       name: 'AGRICULTURA FAMILIAR E AGRONEGÓCIO'
  #     },
  #     {
  #       code: '3.02',
  #       name: 'INDÚSTRIA'
  #     },
  #     {
  #       code: '3.03',
  #       name: 'SERVIÇOS'
  #     },
  #     {
  #       code: '3.04',
  #       name: 'INFRAESTRUTURA E MOBILIDADE'
  #     },
  #     {
  #       code: '3.05',
  #       name: 'TURISMO'
  #     },
  #     {
  #       code: '3.06',
  #       name: 'TRABALHO E RENDA'
  #     },
  #     {
  #       code: '3.07',
  #       name: 'EMPREENDEDORISMO'
  #     },
  #     {
  #       code: '3.08',
  #       name: 'PESCA E AQUICULTURA'
  #     },
  #     {
  #       code: '3.09',
  #       name: 'REQUALIFICAÇÃO URBANA'
  #     },
  #     {
  #       code: '4.01',
  #       name: 'RECURSOS HÍDRICOS'
  #     },
  #     {
  #       code: '4.02',
  #       name: 'MEIO AMBIENTE'
  #     },
  #     {
  #       code: '4.03',
  #       name: 'ENERGIAS'
  #     },
  #     {
  #       code: '5.01',
  #       name: 'EDUCAÇÃO BÁSICA'
  #     },
  #     {
  #       code: '5.02',
  #       name: 'EDUCAÇÃO PROFISSIONAL'
  #     },
  #     {
  #       code: '5.03',
  #       name: 'EDUCAÇÃO SUPERIOR'
  #     },
  #     {
  #       code: '5.04',
  #       name: 'CIÊNCIA, TECNOLOGIA E INOVAÇÃO'
  #     },
  #     {
  #       code: '5.05',
  #       name: 'CULTURA'
  #     },
  #     {
  #       code: '6.01',
  #       name: 'SAÚDE'
  #     },
  #     {
  #       code: '6.02',
  #       name: 'ESPORTE E LAZER'
  #     },
  #     {
  #       code: '6.03',
  #       name: 'SANEAMENTO BÁSICO'
  #     },
  #     {
  #       code: '7.01',
  #       name: 'SEGURANÇA PÚBLICA'
  #     },
  #     {
  #       code: '7.02',
  #       name: 'JUSTIÇA E CIDADANIA'
  #     },
  #     {
  #       code: '7.03',
  #       name: 'POLÍTICA SOBRE DROGAS'
  #     }
  #   ]

  #   themes_data.each do |theme_data|
  #     theme = Theme.find_or_initialize_by(name: theme_data[:name])
  #     theme.update_attributes!(theme_data)
  #   end
  # end
end
