FactoryBot.define do

  factory :authentication_token do
    body "authentication_token_body"
    user nil
    last_used_at "2017-04-03 11:23:12"
    ip_address "127.0.0.1"
    user_agent "Mozilla Firefox"
  end

end
