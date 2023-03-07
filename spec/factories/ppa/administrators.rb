FactoryBot.define do
  factory :ppa_administrator, aliases: [:ppa_admin], class: 'PPA::Administrator' do
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "secret-#{rand(5000)}" }
    sequence(:name) { |n| "User #{n}" }
    cpf { CPF.generate(true) }

    trait :confirmed do
      confirmed_at { Time.current }
    end

    trait :unconfirmed do
      confirmed_at nil
    end


    trait :invalid do
      cpf ''
    end

    # default traits
    confirmed
  end
end
