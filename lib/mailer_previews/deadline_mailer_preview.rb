# Preview all emails at http://localhost:3000/rails/mailers/deadline_mailer
class DeadlineMailerPreview < ActionMailer::Preview

  def result
    DeadlineMailer.result
  end
end
