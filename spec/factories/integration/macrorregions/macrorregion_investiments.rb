FactoryBot.define do
  factory :integration_macroregions_macroregion_investiment, class: 'Integration::Macroregions::MacroregionInvestiment' do
    ano_exercicio '2017'
    codigo_poder '2'
    descricao_poder 'JUDICIÁRIO'
    sequence(:codigo_regiao) { |n| "#{n}" }
    descricao_regiao 'ESTADO DO CEARÁ'
    valor_lei '14509318'
    valor_lei_creditos '14509318'
    valor_empenhado '12579469.76'
    valor_pago '7022290.67'
    perc_empenho '0.86'
    perc_pago '0.48'

    trait :invalid do
      codigo_regiao nil
    end
  end
end
