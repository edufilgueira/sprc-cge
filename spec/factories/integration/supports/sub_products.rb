FactoryBot.define do
  factory :integration_supports_sub_product, class: 'Integration::Supports::SubProduct' do

    sequence(:codigo) { |n| "#{n}" }
    sequence(:codigo_produto) { |n| "#{n}" }

    sequence(:titulo) { |n| "Produto #{n}" }

    trait :invalid do
      codigo nil
      codigo_produto nil
      titulo nil
    end
  end
end
