FactoryBot.define do
  factory :ticket_department_sub_department do
    ticket_department
    sub_department { create(:sub_department, department: ticket_department.department) }

    trait :invalid do
      ticket_department nil
      sub_department nil
    end
  end
end
