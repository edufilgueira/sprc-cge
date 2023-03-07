# Rake para importar os estados
namespace :states do
  desc 'Cria ou atualiza os Estados do Brasil'
  task create_or_update: :environment do

    states = [
      { code: 11, acronym: 'RO', name: 'Rondônia' },
      { code: 12, acronym: 'AC', name: 'Acre' },
      { code: 13, acronym: 'AM', name: 'Amazonas' },
      { code: 14, acronym: 'RR', name: 'Roraima' },
      { code: 15, acronym: 'PA', name: 'Pará' },
      { code: 16, acronym: 'AP', name: 'Amapá' },
      { code: 17, acronym: 'TO', name: 'Tocantins' },
      { code: 21, acronym: 'MA', name: 'Maranhão' },
      { code: 22, acronym: 'PI', name: 'Piauí' },
      { code: 23, acronym: 'CE', name: 'Ceará' },
      { code: 24, acronym: 'RN', name: 'Rio Grande do Norte' },
      { code: 25, acronym: 'PB', name: 'Paraíba' },
      { code: 26, acronym: 'PE', name: 'Pernambuco' },
      { code: 27, acronym: 'AL', name: 'Alagoas' },
      { code: 28, acronym: 'SE', name: 'Sergipe' },
      { code: 29, acronym: 'BA', name: 'Bahia' },
      { code: 31, acronym: 'MG', name: 'Minas Gerais' },
      { code: 32, acronym: 'ES', name: 'Espírito Santo' },
      { code: 33, acronym: 'RJ', name: 'Rio de Janeiro' },
      { code: 35, acronym: 'SP', name: 'São Paulo' },
      { code: 41, acronym: 'PR', name: 'Paraná' },
      { code: 42, acronym: 'SC', name: 'Santa Catarina' },
      { code: 43, acronym: 'RS', name: 'Rio Grande do Sul' },
      { code: 50, acronym: 'MS', name: 'Mato Grosso do Sul' },
      { code: 51, acronym: 'MT', name: 'Mato Grosso' },
      { code: 52, acronym: 'GO', name: 'Goiás' },
      { code: 53, acronym: 'DF', name: 'Distrito Federal' }
    ]


    states.each do |state_attributes|
      state = State.find_or_initialize_by(code: state_attributes[:code])
      state.acronym = state_attributes[:acronym]
      state.name = state_attributes[:name]

      state.save
    end
  end
end
