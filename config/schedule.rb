require File.expand_path('../environment', __FILE__)

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "#{path}/log/cron.log"

# Rotinas diárias
every :day, :at => '06:20am' do
  runner "EvaluateTicketDeadlineWorker.perform_async"
  #runner "SectoralDailyRecap.delay.call"
end

every :day, :at => '07:30am' do
  runner "UpdateStatsTicketWorker.perform_async('sic')"
  runner "UpdateStatsTicketWorker.perform_async('sou')"
  runner "UpdateStatsEvaluationWorker.perform_async"
end

every :day, :at => '10:00am' do
  runner "MailTicketDeadlineWorker.perform_async"
end

# every :day, :at => '04:30pm' do
#   runner "UpdateStatsTicketWorker.perform_async('sic')"
#   runner "UpdateStatsTicketWorker.perform_async('sou')"
#   runner "UpdateStatsEvaluationWorker.perform_async"
# end

every :day, :at => '18:00pm' do
  runner "Transparency::SpreadsheetCleaner.delay.call"
end

every :day, :at => '08:00am' do
  # Nofifica cidadão que segue alguma consulta de transparência quando há alterações de dados
  runner "Transparency::NotifyFollowersWorker.perform_async"
end

every :day, :at => '11:00pm' do
  # Nofifica cidadão sobre a pesquisa de satisfação pendente
  runner "EmailSatisfactionSurveyService.delay.call"
end

# Rotinas mensais
every :month, at: '01:00am' do
  runner "PartialAnswerNotificationService.delay.call"
end
