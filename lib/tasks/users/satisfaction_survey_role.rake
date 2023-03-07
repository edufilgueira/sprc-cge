namespace :satisfaction_survey_role do
  task add: :environment do

    scope = User.where(user_type: :user)
    total = scope.count
    p "0/#{total}"

    scope.find_each.with_index do |user, index|
      user.notification_roles[:satisfaction_survey] = 'email'
      user.save(validate: false)
      p "#{index}/#{total}"
    end
  end
end
