FactoryBot.define do
  factory :integration_supports_sub_function, class: 'Integration::Supports::SubFunction' do
    sequence(:codigo_sub_funcao) { |n| "#{n}" }
    sequence(:titulo) { |n| "SubFunção #{n}" }

    trait :invalid do
      codigo_sub_funcao nil
      titulo nil
    end
  end
end
