FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "Usuário teste #{n}"}
    sequence(:social_name) {|n| "Social name teste #{n}"}
    gender :not_informed_gender
    education_level :high_school
    user_type 'user'
    birthday Date.new
    server false
    sequence(:email) {|n| "user-#{n}@example.com"}
    person_type 'individual'
    city
    document_type :other
    document '1234'
    password 'ABCabc123!@#'
    password_confirmation 'ABCabc123!@#'


    after(:build) do |user|
      user.email_confirmation = user.email
    end


    trait :admin do
      user_type 'admin'
    end

    trait :operator do
      user_type 'operator'
      operator_type :cge
      denunciation_tracking false
    end

    trait :operator_cge_denunciation_tracking do
      user_type 'operator'
      operator_type :cge
      denunciation_tracking true
    end

    trait :user do
      user_type 'user'
    end

    # aliasing trait
    # XXX: apenas 'user' como estava estoura 'undefined method `user=' for ...'
    trait :citizen do
      user_type 'user'
    end

    trait :user_facebook do
      user_type               :user
      document_type           nil
      document                nil
      provider                'facebook'
      facebook_profile_link   "https://facebook.com/profile_user"
    end

    trait :invalid do
      email nil
      password nil
      user_type nil
    end

    trait :cpf do
      document { CPF.generate(true) }
      document_type :cpf
    end

    trait :operator_cge do
      user_type :operator
      operator_type :cge
      organ nil
      department nil
      denunciation_tracking false
    end

    trait :operator_sectoral do
      user_type :operator
      operator_type :sou_sectoral
      organ
      department nil
    end

    trait :operator_sou_sectoral do
      operator_sectoral
    end

    trait :rede_ouvir do
      operator_sou_sectoral
      association :organ, factory: [:rede_ouvir_organ]
    end

    trait :operator_sic_sectoral do
      operator_sectoral_sic
    end

    trait :operator_sectoral_sic do
      operator_sectoral
      operator_type :sic_sectoral
    end

    trait :operator_security_organ_sou do
      operator_type :security_organ
    end

    trait :operator_internal do
      user_type :operator
      operator_type :internal
      department { build(:department, organ: organ) }
      organ
      sub_department nil
    end

    trait :operator_call_center do
      user_type :operator
      operator_type :call_center
      organ nil
      department nil
    end

    trait :operator_call_center_supervisor do
      user_type :operator
      operator_type :call_center_supervisor
      organ nil
      department nil
    end

    trait :legal do
      person_type :legal
      document { CNPJ.generate(true) }
    end

    trait :individual do
      person_type :individual
      document { CPF.generate(true) }
    end

    trait :blocked_notifications do
      notification_roles {
      {
        new_ticket: 'none',
        deadline: 'none',
        transfer: 'none',
        appeal: 'none',
        reopen: 'none',
        extension: 'none',
        answer: 'none',
        share: 'none',
        forward: 'none',
        invalidate: 'none',
        user_comment: 'none',
        internal_comment: 'none'
      }
    }
    end

    trait :operator_chief do
      user_type :operator
      operator_type :chief
      association :organ, factory: [:executive_organ]
      department nil
    end

    trait :operator_subnet do
      user_type :operator
      operator_type :subnet_sectoral
      association :organ, factory: [:executive_organ, :with_subnet]
      subnet { build(:subnet, organ: organ) }
    end

    trait :operator_subnet_sectoral do
      operator_subnet
    end

    trait :operator_subnet_chief do
      user_type :operator
      operator_type :subnet_chief
      association :organ, factory: [:executive_organ, :with_subnet]
      subnet { build(:subnet, organ: organ) }
    end

    trait :operator_subnet_internal do
      user_type :operator
      operator_type :internal
      internal_subnet true
      association :organ, factory: [:executive_organ, :with_subnet]
      subnet { build(:subnet, organ: organ) }
      department { build(:department, subnet: subnet) }
    end

    trait :operator_coordination do
      user_type :operator
      operator_type :coordination
      association :organ, factory: [:executive_organ, :couvi]
      denunciation_tracking true
      department nil
    end

    trait :operator_security_organ do
      user_type :operator
      operator_type :security_organ
      department { build(:department, organ: organ) }
      organ
      sub_department nil
    end

    # devise confirmable traits
    trait :confirmed do
      confirmed_at { Time.current }
    end

    trait :unconfirmed do
      confirmed_at nil
    end

    # default traits
    confirmed

  end
end
