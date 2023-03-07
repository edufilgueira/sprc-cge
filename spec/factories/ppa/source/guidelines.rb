# XXX factory copiada de sprc-data
FactoryBot.define do
  factory :ppa_source_guideline, class: 'PPA::Source::Guideline' do
    # XXX São os valores posssíveis, dadas as limitações do webservice da SEPLAG
    # veja https://github.com/caiena/sprc/issues/644
    ano { [2017, 2018].sample } # Date.today.year

    sequence(:codigo_regiao) { |n| n.to_s.rjust(2, '0') } # e.g. '01'
    sequence(:codigo_eixo) { |n| n.to_s } # e.g. '1'
    sequence(:codigo_tema) { |n| "#{codigo_eixo}.#{n}" } # '1.02'
    sequence(:codigo_ppa_objetivo_estrategico) { |n| "#{codigo_eixo}.#{n}" } #e.g. '01.01' # QUESTION codigo_eixo rjust?
    sequence(:codigo_ppa_estrategia) { |n| "#{codigo_eixo}.#{codigo_ppa_objetivo_estrategico}.#{n}"} # e.g. '03.06.15'
    sequence(:codigo_programa) { |n| n.to_s.rjust(3, '0') } # e.g. '015'
    sequence(:codigo_ppa_iniciativa) { |n| n.to_s } # e.g. '065.1.06' # QUESTION tem alguma lógica?
    sequence(:codigo_produto) { |n| n.to_s } # e.g. '425'
    sequence(:codigo_acao) { |n| n.to_s } # e.g. '18501'

    descricao_regiao 'GRANDE FORTALEZA'
    descricao_eixo 'CEARÁ DA GESTÃO DEMOCRÁTICA POR RESULTADOS'
    descricao_tema 'PLANEJAMENTO E GESTÃO'
    descricao_objetivo_estrategico 'Reduzir a pobreza e as desigualdades sociais e regionais.'
    descricao_estrategia 'Integrar as políticas intersetoriais de assistência social, habitação, segurança alimentar e nutricional, educação, saúde, esporte e lazer e desenvolvimento territorial.'
    descricao_programa 'GOVERNANÇA DO PACTO POR UM CEARÁ PACÍFICO'
    descricao_ppa_iniciativa 'Gestão das ações desenvolvidas com foco no combate à pobreza e inclusão social.'
    descricao_produto 'PLANO ELABORADO'
    descricao_acao '-'

    descricao_portal '-'
    descricao_referencia 'Sem Período Concluído para o Ano'

    ordem_prioridade '0'
    prioridade_regional '-'

    valor_lei_ano1 '0'
    valor_lei_ano2 '0'
    valor_lei_ano3 '0'
    valor_lei_ano4 '0'
    valor_lei_creditos_ano1 '0'
    valor_lei_creditos_ano2 '0'
    valor_lei_creditos_ano3 '0'
    valor_lei_creditos_ano4 '0'
    valor_empenhado_ano1 '0'
    valor_empenhado_ano2 '0'
    valor_empenhado_ano3 '0'
    valor_empenhado_ano4 '0'
    valor_pago_ano1 '0'
    valor_pago_ano2 '0'
    valor_pago_ano3 '0'
    valor_pago_ano4 '0'

    valor_programado1619_ar '0'
    valor_programado1619_dr '0'
    valor_programado_ano1 '0'
    valor_programado_ano2 '0'
    valor_programado_ano3 '0'
    valor_programado_ano4 '0'
    valor_realizado1619_ar '0'
    valor_realizado1619_dr '0'
    valor_realizado_ano1 '0'
    valor_realizado_ano2 '0'
    valor_realizado_ano3 '0'
    valor_realizado_ano4 '0'

    trait :invalid do
      codigo_eixo nil
    end

  end
end
