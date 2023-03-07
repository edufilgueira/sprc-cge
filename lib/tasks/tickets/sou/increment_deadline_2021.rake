namespace :tickets do
  namespace :sou do
    namespace :increment_deadline_2021 do
      desc "Alterando todos os prazos de manifestações de 2021"

      task update: :environment  do |t|
        $stdout = File.new("#{Rails.root}/log/increment_deadline_2021.out", 'w')
        $stdout.sync = true

        total = tickets.count

        tickets.find_each.with_index do |ticket, index|
          increment_deadline = calculate_increment_deadline ticket

          begin
            ApplicationRecord.transaction do
              ticket.answers.each do |answer|
                answer.sectoral_deadline += increment_deadline if answer.sectoral_deadline.present?
                answer.deadline += increment_deadline if answer.deadline.present?

                answer.save
              end

              log_deadline_ends_at = ticket.deadline_ends_at

              ticket.deadline += increment_deadline
              ticket.deadline_ends_at += increment_deadline

              ticket.save(validate: false)

              p "Ticket id: #{ticket.id} | Protocol: #{ticket.protocol} | deadline_ends_at_was: #{log_deadline_ends_at} | reopened: #{ticket.reopened_at || 'false'} | increment: #{increment_deadline}"
            end
          rescue
            p "#Error - Ticket id: #{ticket.id} | Protocol: #{ticket.protocol} | increment: #{increment_deadline}"
          end
          p "#{index+1} / #{total}"
        end
      end
    end
  end
end

def calculate_increment_deadline ticket
  initial_date =
    if ticket.reopened?
      ticket.reopened_at.to_date
    else
      ticket.confirmed_at.to_date
    end

  days_to_add = Ticket::SOU_DEADLINE - (ticket.deadline_ends_at - initial_date).to_i

  return 0 if days_to_add.negative?

  Holiday.next_weekday(days_to_add, ticket.deadline_ends_at)
end

def tickets
  date = Date.new(2021, 1, 1)
  Ticket.where(ticket_type: :sou, extended: false)
    .where.not(deadline: nil)
    .where('created_at >= ? OR reopened_at >= ?', date, date)
end