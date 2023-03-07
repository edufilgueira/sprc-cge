FactoryBot.define do
  factory :integration_utils_data_change, class: 'Integration::Utils::DataChange' do
    data_changes {{ 'attribute'=>['mudou deste valor', 'para este valor'] }}
    changeable_id 1
    changeable_type 'Integration::NomeDoModel'

    trait :invalid do
      changeable_id nil
    end
  end
end
