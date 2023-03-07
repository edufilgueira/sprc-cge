class Transparency::FollowerMailer < ApplicationMailer

  def citizen_following(content, emails)
    @to = emails
    @subject = content[:subject]
    @body = content[:body]

    mail(to: @to, subject: @subject)
  end
end
