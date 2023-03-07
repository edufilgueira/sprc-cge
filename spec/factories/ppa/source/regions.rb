# XXX factory copiada de sprc-data
FactoryBot.define do
  factory :ppa_source_region, class: 'PPA::Source::Region' do
    sequence(:codigo_regiao) { |n| n.to_s.rjust(2, '0') } # e.g. '01'
    sequence(:descricao_regiao) { |n| "REGIAO #{n}" } # e.g. 'CARIRI'

    trait :invalid do
      codigo_regiao nil
    end
  end
end
