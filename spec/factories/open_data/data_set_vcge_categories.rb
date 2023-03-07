FactoryBot.define do
  factory :data_set_vcge_category, class: 'OpenData::DataSetVcgeCategory'  do

    association :data_set
    association :vcge_category

    trait :invalid do
      data_set nil
      vcge_category nil
    end
  end
end
