FactoryBot.define do
  factory :answer do
    answer_type :final
    answer_scope :cge
    status :cge_approved
    classification :sou_demand_well_founded
    version 0
    deadline 0
    sectoral_deadline 0
    ticket
    user
    description "MyText"

    trait :invalid do
      description nil
    end

    trait :child_ticket do
      association :ticket, factory: [:ticket, :with_parent]
    end

    trait :partial do
      answer_type :partial
    end

    trait :final do
      answer_type :final
    end

    trait :answer do
      final
      status :awaiting
    end

    trait :positioning do
      final
      answer_scope :department
    end

    trait :subnet_positioning do
      final
      answer_scope :subnet_department
    end

    trait :awaiting_positioning do
      positioning
      status :awaiting
    end

    trait :approved_positioning do
      positioning
      status :sectoral_approved
    end

    trait :rejected_positioning do
      positioning
      status :sectoral_rejected
    end

    trait :with_classification do
      classification :sou_demand_well_founded
    end

    trait :cge_approved do
      final
      status :cge_approved
    end

    trait :with_cge_approved_partial_answer do
      answer_type :partial
      status :cge_approved
    end

    trait :with_cge_approved_final_answer do
      final
      status :cge_approved
    end

    trait :cge_rejected do
      answer_type :partial
      status :cge_rejected
    end

    trait :user_evaluated do
      final
      status :user_evaluated
    end

    trait :sectoral_approved do
      final
      status :sectoral_approved
    end

    trait :sectoral_rejected do
      final
      status :sectoral_rejected
    end

    trait :awaiting_department do
      final
      status :awaiting
      answer_scope :department
    end

    trait :awaiting_sectoral do
      final
      status :awaiting
      answer_scope :sectoral
    end

    trait :awaiting_subnet do
      final
      status :awaiting
      answer_scope :subnet
    end

    trait :awaiting_subnet_department do
      final
      status :awaiting
      answer_scope :subnet_department
    end

    trait :awaiting do
      final
      status :awaiting
    end

    trait :subnet_rejected do
      final
      status :subnet_rejected
    end

    trait :subnet_approved do
      final
      status :subnet_approved
    end

    trait :sectoral_approved do
      final
      status :sectoral_approved
    end

    trait :call_center_approved do
      final
      status :call_center_approved
    end

    trait :with_certificate do
      certificate { Refile::FileDouble.new("test", "certificate.png", content_type: "image/png") }
      classification :sic_attended_rejected_partially
      sic
    end

    trait :sic do
      association :ticket, factory: [:ticket, :sic]
    end
  end
end
