FactoryBot.define do
  factory :integration_city_undertakings_city_undertaking, class: 'Integration::CityUndertakings::CityUndertaking' do
    municipio "CANINDÉ          "
    tipo_despesa "CONVENIO"
    sic "616997"
    mapp "APOIO AOS APL 2009      "
    valor_programado1 0
    valor_programado2 0
    valor_programado3 0
    valor_programado4 75000
    valor_programado5 0
    valor_programado6 0
    valor_programado7 105000
    valor_programado8 0
    valor_executado1 0
    valor_executado2 0
    valor_executado3 0
    valor_executado4 85000
    valor_executado5 0
    valor_executado6 0
    valor_executado7 105000
    valor_executado8 0

    expense 0
    organ { create(:integration_supports_organ, orgao_sfp: false) }
    creditor { create(:integration_supports_creditor) }
    undertaking { create(:integration_supports_undertaking) }

    trait :invalid do
      organ nil
      creditor nil
      undertaking nil
      municipio nil
      mapp nil
      sic nil
    end
  end
end
