FactoryBot.define do
  factory :transparency_follower, class: 'Transparency::Follower' do
    email "email@example.com"
    resourceable { create(:integration_constructions_dae) }
    transparency_link "http://localhost:3000/portal-da-transparencia/nome-da-consulta/id"
    unsubscribed_at nil

    trait :invalid do
      email ''
    end
  end
end
