FactoryBot.define do
  factory :ppa_interaction, class: 'PPA::Interaction' do
    user

    trait :invalid do
      user nil
    end
  end
end
