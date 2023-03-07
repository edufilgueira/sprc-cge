FactoryBot.define do
  factory :integration_expenses_nld_item_payment_planning, class: 'Integration::Expenses::NldItemPaymentPlanning' do
    codigo_isn ""
    valor_liquidado "9.99"

    association :nld, factory: :integration_expenses_nld

    trait :invalid do
      nld nil
    end
  end
end
