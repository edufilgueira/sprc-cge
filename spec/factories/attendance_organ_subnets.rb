FactoryBot.define do
  factory :attendance_organ_subnet do
    attendance
    subnet
    organ {
      subnet.organ
    }
    unknown_subnet false

    trait :invalid do
      attendance nil
      organ nil
    end
  end
end
