class TicketMailer < ApplicationMailer
  layout 'daily_recap'

  def daily_recap(users, summary)
    @summary = summary
    mail(bcc: users.pluck(:email))
  end

  def sectoral_daily_recap(users, summary)
    @summary = summary
    mail(bcc: users.pluck(:email))
  end

  #
  # Envia respostas finais ao cidadão
  #
  def email_reply(ticket, replies)
    @replies = replies
    @ticket = ticket
    subject = I18n.t("ticket_mailer.email_reply.subject.#{@ticket.ticket_type}")

    mail(to: ticket.email, subject: subject)
  end

  #
  # Envia email de confirmação para seguir um ticket publico
  #
  def subscription_confirmation(ticket_subscription_id)
    ticket_subscription = TicketSubscription.find(ticket_subscription_id)
    @ticket = ticket_subscription.ticket

    @url = confirmation_transparency_public_ticket_subscriptions_url(public_ticket_id: @ticket, token: ticket_subscription.token)

    subject = I18n.t("ticket_mailer.subscription_confirmation.subject.#{@ticket.ticket_type}" , protocol: @ticket.protocol)
    mail(to: ticket_subscription.email, subject: subject)
  end

  #
  # Envia email de notificação para os emails que seguem tickets publicos
  #
  def ticket_subscriber_notification(ticket_subscription_id, action)
    ticket_subscription = TicketSubscription.find(ticket_subscription_id)
    @ticket = ticket_subscription.ticket
    @action = action
    @url_unfollow = unsubscribe_transparency_public_ticket_subscriptions_url(public_ticket_id: @ticket, token: ticket_subscription.token)
    @url_public_ticket = transparency_public_ticket_url(@ticket)

    subject = I18n.t("shared.notifications.public_ticket.#{action}.#{@ticket.ticket_type}.subject" , protocol: @ticket.protocol)
    mail(to: ticket_subscription.email, subject: subject)
  end

end
