FactoryBot.define do
  factory :stats_server_salary, class: 'Stats::ServerSalary' do
    month { Date.today.month }
    year { Date.today.year }
    data {}
  end
end
