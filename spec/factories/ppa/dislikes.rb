FactoryBot.define do
  factory :ppa_dislike, parent: :ppa_interaction, class: 'PPA::Dislike' do
    interactable { build(:ppa_strategy) }
  end
end
