FactoryBot.define do
  factory :integration_supports_organ, class: 'Integration::Supports::Organ' do
    sequence(:codigo_orgao) { |c| "#{c}" }
    sequence(:descricao_orgao) { |c| "SUPERINDENT DO DESENV #{c}" }
    sequence(:sigla) { |c| "SIGLA_#{c}" }
    sequence(:codigo_entidade) { |c| "00#{c}00" }
    sequence(:descricao_entidade) { |c| "SECRETARIA #{c}" }
    descricao_administracao "INDIRETA"
    poder "EXECUTIVO"
    sequence(:codigo_folha_pagamento) { |c| "#{c}" }
    orgao_sfp true

    trait :invalid do
      codigo_orgao nil
    end

    trait :secretary do
      sequence(:codigo_orgao) { |c| "#{c}0001" }

      sequence(:descricao_orgao) { |c| "SECRETARIA #{c}" }
      sequence(:descricao_entidade) { |c| "SECRETARIA #{c}" }

      poder 'EXECUTIVO'
      orgao_sfp false
    end
  end
end
