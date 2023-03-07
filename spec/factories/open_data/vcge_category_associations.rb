FactoryBot.define do
  factory :vcge_category_association, class: 'OpenData::VcgeCategoryAssociation'  do

    association :parent, factory: :vcge_category
    association :child, factory: :vcge_category

    trait :invalid do
      parent nil
      child nil
    end
  end
end
