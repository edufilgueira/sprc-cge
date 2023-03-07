FactoryBot.define do
  factory :ppa_vote, parent: :ppa_interaction, class: 'PPA::Vote' do
    interactable { build(:ppa_strategy) }
  end
end
