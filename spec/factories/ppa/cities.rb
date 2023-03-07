FactoryBot.define do
  factory :ppa_city, parent: :city, class: 'PPA::City' do
    association :state, factory: [:state, :ceara] # ceará!
  end
end
