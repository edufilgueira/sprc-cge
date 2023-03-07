# Preview all emails at http://localhost:3000/rails/mailers/ticket_mailer
class TicketMailerPreview < ActionMailer::Preview

  def daily_recap
    TicketMailer.daily_recap(User.limit(5), summary)
  end

  def sectoral_daily_recap
    TicketMailer.sectoral_daily_recap(User.limit(5), chief_summary)
  end

  private

  def summary
    {
      sou: {
        not_expired: 5,
        expired_can_extend: 3,
        expired: 1
      },
      sic: {
        not_expired: 5,
        expired_can_extend: 3,
        expired: 1
      }
    }
  end

  def chief_summary
    {
      range: {
        starts_at: '01/01/2018',
        ends_at: '15/10/2018'
      },
      organ: Organ.first.title,
      sou: chief_summary_ticket,
      sic: chief_summary_ticket
    }
  end

  def chief_summary_ticket
    {
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
  end

end
