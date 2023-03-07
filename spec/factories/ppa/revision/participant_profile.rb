FactoryBot.define do
  factory :ppa_revision_participant_profile, class: 'PPA::Revision::ParticipantProfile' do
    association :user, factory: :user

    age :smaller_18
    genre :men_cis
    breed :white
    ethnic_group :indigenous
    educational_level :specialization
    family_income :less_than_1100
    representative :civil_society
    representative_description 'CGE'
    collegiate 'Colegiado'
  end
end