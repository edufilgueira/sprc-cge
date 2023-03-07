FactoryBot.define do
  factory :vcge_category, class: 'OpenData::VcgeCategory'  do

    sequence(:title) {|n| "Título da categoria VCGE #{n}"}
    sequence(:href) {|n| "#transporte-ferroviario-#{n}"}
    sequence(:vcge_id) {|n| "transporte-ferroviario-#{n}"}
    sequence(:name) {|n| "transporte-ferroviario-#{n}"}

    trait :invalid do
      vcge_id nil
    end
  end
end
