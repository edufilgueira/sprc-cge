FactoryBot.define do
  factory :integration_results_strategic_indicator, class: 'Integration::Results::StrategicIndicator' do
    eixo { {:codigo_eixo=>"1", :descricao_eixo=>"CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS"} }
    resultado "Serviços públicos estaduais planejados e geridos de forma eficiente e efetiva, atendendo as necessidades dos cidadãos, com transparência e equilíbrio fiscal"
    indicador "Investimento/Receita Corrente Líquida (%) "
    unidade "percentual"
    sigla_orgao "SEPLAG         "
    orgao "SECRETARIA DO PLANEJAMENTO E GESTÃO"
    valores_realizados { {:valor_realizado=>[{:ano=>"2012", :valor=>"17"}, {:ano=>"2013", :valor=>"16.70"}, {:ano=>"2014", :valor=>"24.10"}]} }
    valores_atuais nil

    organ { create(:integration_supports_organ, sigla: 'SEPLAG', orgao_sfp: false) }
    axis { create(:integration_supports_axis, codigo_eixo: '1') }

    trait :invalid do
      indicador nil
    end
  end
end
