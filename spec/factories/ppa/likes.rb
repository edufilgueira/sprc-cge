FactoryBot.define do
  factory :ppa_like, parent: :ppa_interaction, class: 'PPA::Like' do
    interactable { build(:ppa_strategy) }
  end
end
