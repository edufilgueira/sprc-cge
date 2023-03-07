namespace :tickets do
  namespace :decrement_deadline do
    desc "Adicionando todos os tickets com decrement_deadline para false"

    task update: :environment  do |t|
      total = Ticket.unscoped.where(decrement_deadline: nil).count
      p "Setando todos os tickets com decrement_deadline false"
      Ticket.unscoped.where(decrement_deadline: nil).in_batches(of: 10000).each_with_index do |tickets, batch_index|
        tickets.update_all(decrement_deadline: false)
        p "#{(batch_index + 1) * 10000} / #{total}"
      end

      p "Setando decrement_deadline true para os tickets"
      DefineDecrementDeadlineTickets.call
    end
  end
end