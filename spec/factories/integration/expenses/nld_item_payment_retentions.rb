FactoryBot.define do
  factory :integration_expenses_nld_item_payment_retention, class: 'Integration::Expenses::NldItemPaymentRetention' do
    codigo_retencao "MyString"
    credor "MyString"
    valor "9.99"

    association :nld, factory: :integration_expenses_nld

    trait :invalid do
      nld nil
    end
  end
end
