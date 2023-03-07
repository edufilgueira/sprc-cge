FactoryBot.define do
  factory :integration_expenses_ned_item, class: 'Integration::Expenses::NedItem' do
    sequencial "1"
    especificacao "VR DESP REF DIÁRIAS CONF PORTARIA Nº 549/2017 DECRETO Nº 30.719 PF 2200018042016M"
    unidade "1"
    quantidade "1.00"
    valor_unitario "38.55"
    association :ned, factory: :integration_expenses_ned

    trait :invalid do
      ned nil
    end
  end
end
