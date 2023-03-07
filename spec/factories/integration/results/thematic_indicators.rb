FactoryBot.define do
  factory :integration_results_thematic_indicator, class: 'Integration::Results::ThematicIndicator' do
    eixo {{:codigo_eixo=>"1", :descricao_eixo=>"CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS" }}
    tema {{ :codigo_tema=>"1.01", :descricao_tema=>"GESTÃO FISCAL" }}
    resultado "Equilíbrio Fiscal e Orçamentário garantido"
    indicador "Capacidade de investimento do Tesouro"
    unidade "R$ milhão"
    sigla_orgao "SEFAZ"
    orgao "SECRETARIA DA FAZENDA"
    valores_realizados {{:valor_realizado=>[{:ano=>"2012", :valor=>"1857.10"}, {:ano=>"2013", :valor=>"1191.73"}, {:ano=>"2014", :valor=>"622.19"}, {:ano=>"2015", :valor=>"629.36"}, {:ano=>"2016", :valor=>"1634.60"}] }}
    valores_programados {{ :valor_programado=>[{:ano=>"2016", :valor=>"547.50"}, {:ano=>"2017", :valor=>"621.60"}, {:ano=>"2018", :valor=>"860.10"}, {:ano=>"2019", :valor=>"715.20"}] }}

    organ { create(:integration_supports_organ, sigla: 'SEPLAG', orgao_sfp: false) }
    axis { create(:integration_supports_axis, codigo_eixo: '1') }
    theme { create(:integration_supports_theme, codigo_tema: '1.01') }

    trait :invalid do
      indicador nil
    end
  end
end
