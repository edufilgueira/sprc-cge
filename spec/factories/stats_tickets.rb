FactoryBot.define do
  factory :stats_ticket, class: 'Stats::Ticket' do
    ticket_type :sou
    month_start 1
    month_end 1
    year 1990
    data {}
    status 1

    trait :sectoral do
      organ
    end
  end
end
