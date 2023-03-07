FactoryBot.define do
  factory :evaluation do
    question_01_a 1
    question_01_b 1
    question_01_c 1
    question_01_d 1
    question_02 1
    question_03 1
    question_04 'Ok'
    question_05 'yes'
    average ''
    answer
    sou

    trait :invalid do
      question_01_a nil
    end

    trait :note_5 do
      question_01_a 5
      question_01_b 5
      question_01_c 5
      question_01_d 5
      question_02 5
      question_03 5
    end

    trait :note_3 do
      question_01_a 3
      question_01_b 3
      question_01_c 3
      question_01_d 3
      question_02 3
      question_03 3
    end

    trait :sou do
      evaluation_type :sou
    end

    trait :sic do
      evaluation_type :sic
      association :answer, factory: [:answer, :sic]
    end
  end
end
