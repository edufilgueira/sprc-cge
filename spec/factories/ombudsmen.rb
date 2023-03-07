FactoryBot.define do
  factory :ombudsman do
    title "Agência de Defesa Agropecuária do Estado do Ceará – ADAGRI"
    contact_name "Luciana Freire Castelo Branco"
    phone "(85) 3433-4893"
    email "luciana.castelobranco@adagri.ce.gov.br"
    address "Av. Bezerra de Menezes, nº 1820, São Gerardo – Fortaleza/CE"
    operating_hours "8h às 12h e das 13h às 17h"
    kind :executive

    trait :invalid do
      title ''
    end
  end
end
