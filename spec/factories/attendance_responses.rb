FactoryBot.define do
  factory :attendance_response do
    description 'Attendance response'
    response_type :failure
    ticket

    trait :invalid do
      description nil
    end
  end
end
