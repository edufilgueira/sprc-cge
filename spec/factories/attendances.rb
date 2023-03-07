FactoryBot.define do
  factory :attendance do
    service_type :sic_forward
    description "MyText"
    unknown_organ true
    created_by_id { create(:user, :operator_call_center).id }

    after(:build) do | attendance, _ |
      attendance.occurrences.build(description: I18n.t('occurrences.default_occurrence'))
    end

    trait :invalid do
      service_type nil
    end

    trait :with_ticket do
      ticket
    end

    trait :with_ticket_sic do
      association :ticket, factory: [:ticket, :confirmed, :sic]
    end

    trait :with_confirmed_ticket do
      association :ticket, factory: [:ticket, :confirmed]
    end

    trait :with_organs do
      unknown_organ false
      before(:create) do |attendance|
        attendance.attendance_organ_subnets << build(:attendance_organ_subnet, attendance: attendance)
      end
    end

    trait :sou_forward do
      service_type :sou_forward
      with_ticket
    end

    trait :no_characteristic do
      service_type :no_characteristic
      answer 'Answer'
    end

    trait :sic_forward do
      service_type :sic_forward
      with_ticket_sic
    end

    trait :sic_completed do
      service_type :sic_completed
      with_organs
      with_ticket_sic
      answer 'Answer'
      association :ticket, factory: [:ticket, :replied, :sic, :immediate_answer]
    end

    trait :sou_search do
      service_type :sou_search
    end

    trait :sic_search do
      service_type :sic_search
    end

    trait :prank_call do
      service_type :prank_call
    end

    trait :immediate_hang_up do
      service_type :immediate_hang_up
    end

    trait :hang_up do
      service_type :hang_up
    end

    trait :missing_data do
      service_type :missing_data
    end

    trait :no_communication do
      service_type :no_communication
    end

    trait :noise do
      service_type :noise
    end

    trait :technical_problems do
      service_type :technical_problems
    end

    trait :incorrect_click do
      service_type :incorrect_click
    end

    trait :transferred_call do
      service_type :transferred_call
    end
  end
end
