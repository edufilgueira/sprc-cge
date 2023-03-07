#
# Serviço de notificação para manifestante responder a pesquisa de satisfação
#
class Notifier::SatisfactionSurvey < BaseNotifier
  include ActionView::Helpers::TextHelper

  attr_reader :satisfacton_survey

  def self.call(answer_id)
    new(answer_id).call
  end

  def initialize(answer_id)
    @answer = ::Answer.find(answer_id)
    @ticket = @answer.ticket
  end


  # private

  private

  def recipients
    users_ticket_owner
  end

  def ticket_type
    ticket.ticket_type
  end

  # titulo situado dentro do corpo do e-mail
  def subject(user)
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.satisfaction_survey.subject.#{ticket_type}")
  end

  def body(user)
    locals = {
      answer_description: truncate(@answer.description, length: 27000, escape: false),
      protocol: protocol_for_user(user),
      url: ticket_url(user) + '?satisfaction_survey=true',
      ticket_type: ticket_type,
      user: user,
      ticket: @ticket
    }

    body = ActionView::Base.new('app/views').render(partial: 'ticket_mailer/satisfaction_survey', format: :html, locals: locals)
    CGI.unescapeHTML(body.gsub("\n", ''))
  end
end
