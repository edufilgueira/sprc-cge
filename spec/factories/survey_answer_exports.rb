FactoryBot.define do
  factory :survey_answer_export do
    name "Nome da exportação com mais de trinta caracteres"
    start_at Date.yesterday.to_datetime
    ends_at DateTime.now
    log "logging"
    status nil
    worksheet_format :xlsx
    user

    trait :invalid do
      name ''
    end
  end
end
