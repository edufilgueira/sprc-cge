FactoryBot.define do
  factory :attendance_report do
    association :user, factory: [:user, :operator_call_center_supervisor]
    title "Attendance Report"
    status :preparing
    starts_at Date.today.beginning_of_day
    ends_at Date.today.end_of_day

    trait :invalid do
      title nil
    end
  end
end
