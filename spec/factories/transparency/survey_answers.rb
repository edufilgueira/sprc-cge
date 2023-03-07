FactoryBot.define do
  factory :transparency_survey_answer, class: 'Transparency::SurveyAnswer' do
    date Date.today
    transparency_page 'expenses/budget_balances'
    answer 0
    email 'reclamao@example.com'
    message 'mensagem...'
    controller 'test'
    action 'index'
    url 'http://...'

    trait :invalid do
      date nil
    end
  end
end
