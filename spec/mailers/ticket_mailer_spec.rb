require 'rails_helper'

describe TicketMailer, type: :mailer do
  describe '#daily_recap' do
    let(:users) { create_list(:user, 2, :operator) }
    let(:summary) do
      {
        sou: {
          not_expired: 2,
          expired: 1,
          expired_can_extend: 3
        },
        sic: {
          not_expired: 2,
          expired: 1,
          expired_can_extend: 3
        }
      }
    end

    let(:mail) { TicketMailer.daily_recap(users, summary) }

    it 'renders the subject' do
      expected = I18n.t('ticket_mailer.daily_recap.subject')
      expect(mail.subject).to eql(expected)
    end

    it 'renders the receiver email' do
      expect(mail.bcc).to eql(users.pluck(:email))
    end
  end

  describe '#sectoral_daily_recap' do
    let(:users) { create_list(:user, 2, :operator) }

    let(:summary) do
      {
        range: {
          starts_at: '01/01/2018',
          ends_at: '15/10/2018'
        },
        organ: 'Organ title',
        sou: {
          total: 2,
          replied: 1,
          confirmed: {
            not_expired: 3,
            expired_can_extend: 3,
            not_expired_extended: 3,
            expired: 3
          },
          solvability: 3,
          answer_time_average: 3,
          answer_satisfaction_rate: 3
        },
        sic: {
          total: 2,
          replied: 1,
          confirmed: {
            not_expired: 3,
            expired_can_extend: 3,
            not_expired_extended: 3,
            expired: 3
          },
          solvability: 3,
          answer_time_average: 3,
          answer_satisfaction_rate: 3
        }
      }
    end

    let(:mail) { TicketMailer.sectoral_daily_recap(users, summary) }

    it 'renders the subject' do
      expected = I18n.t('ticket_mailer.sectoral_daily_recap.subject')
      expect(mail.subject).to eql(expected)
    end

    it 'renders the receiver email' do
      expect(mail.bcc).to eql(users.pluck(:email))
    end
  end

  describe '#email_reply' do
    it 'send to citizen' do
      ticket = create(:ticket)
      answers = [create(:answer, ticket: ticket)]

      mail = TicketMailer.email_reply(ticket, answers)

      subject_expected = I18n.t('ticket_mailer.email_reply.subject.sou')

      expect(mail.to).to eq([ticket.email])
      expect(mail.subject).to eql(subject_expected)
    end
  end

  describe '#subscription_confirmation' do
    it 'send to citizen' do
      ticket = create(:ticket, :public_ticket)
      email = 'email@example.com'
      ticket_subscription = create(:ticket_subscription, ticket: ticket, user: nil, email: email, token: 'token')

      mail = TicketMailer.subscription_confirmation(ticket_subscription.id)

      subject_expected = I18n.t("ticket_mailer.subscription_confirmation.subject.#{ticket.ticket_type}" , protocol: ticket.protocol)

      expect(mail.to).to eq([email])
      expect(mail.subject).to eql(subject_expected)
    end
  end

  describe '#ticket_subscriber_notification' do
    it 'send to citizen' do
      ticket = create(:ticket, :public_ticket)
      email = 'email@example.com'
      ticket_subscription = create(:ticket_subscription, :confirmed, ticket: ticket, email: email)
      ticket_log = create(:ticket_log, ticket: ticket)

      mail = TicketMailer.ticket_subscriber_notification(ticket_subscription.id, ticket_log.action)

      subject_expected = I18n.t("shared.notifications.public_ticket.#{ticket_log.action}.#{ticket.ticket_type}.subject" , protocol: ticket.protocol)

      expect(mail.to).to eq([email])
      expect(mail.subject).to eql(subject_expected)
    end
  end
end
