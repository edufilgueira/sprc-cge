FactoryBot.define do
  factory :executive_ombudsman do
    title "Agência de Defesa Agropecuária do Estado do Ceará – ADAGRI"
    contact_name "Luciana Freire Castelo Branco"
    phone "(85) 3433-4893"
    email "luciana.castelobranco@adagri.ce.gov.br"
    address "Av. Bezerra de Menezes, nº 1820, São Gerardo – Fortaleza/CE"
    operating_hours "8h às 12h e das 13h às 17h"
    kind 0

    trait :arce do
      title "Agência Reguladora de Serviços Públicos Delegados do Estado do Ceará - ARCE/CE"
      contact_name "Daniela Carvalho Cambraia Dantas"
      phone "(85) 3194-5688"
      email "ouvidor@arce.ce.gov.br"
      address "Av. General Afonso Albuquerque Lima, S/N - Cambeba, CEP: 60.822-325"
      operating_hours "8h às 12h e das 13h às 17h"
      kind 0
    end
  end
end
