FactoryBot.define do
  factory :ticket_log do
    ticket
    association :responsible, factory: :user
    action :answer
    association :resource, factory: :answer

    trait :invalid do
      ticket nil
    end

    trait :comment do
      association :resource, factory: :comment
      action :comment
    end

    trait :answer do
      action :answer
    end

    trait :change_denunciation_type do
      action :change_denunciation_type
    end

    trait :with_partial_answer do
      action :answer
      association :resource, factory: [:answer, :with_cge_approved_partial_answer]
    end

    trait :with_final_answer do
      action :answer
      resource { create(:answer, :with_cge_approved_final_answer, ticket: ticket) }
    end

    trait :with_awaiting_sectoral do
      action :answer
      association :resource, factory: [:answer, :awaiting_sectoral]
    end

    trait :confirm do
      action :confirm
    end

    trait :forward do
      action :forward
      association :resource, factory: [:department]
    end

    trait :reopened do
      association :ticket, factory: [:ticket, :confirmed]
      action :reopen
      description 'reopen'
      data { { count: 1 } }
    end

    trait :appealed do
      association :ticket, factory: [:ticket, :sic, :confirmed]
      action :appeal
      description 'appeal'
    end
  end
end
