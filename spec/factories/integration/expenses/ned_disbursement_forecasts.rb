FactoryBot.define do
  factory :integration_expenses_ned_disbursement_forecast, class: 'Integration::Expenses::NedDisbursementForecast' do
    data "21/09/2017"
    valor "38.55"
    association :ned, factory: :integration_expenses_ned

    trait :invalid do
      ned nil
    end
  end
end
