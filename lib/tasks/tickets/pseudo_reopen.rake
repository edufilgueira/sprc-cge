namespace :tickets do
  namespace :pseudo_reopen do
    desc "Define valores para a coluna de ticket pseudo reopen."

		task update: :environment  do |t|
			p "Adicionando nos tickets pseudo reabertura como true"
			Ticket.joins(:ticket_logs).where(ticket_logs: { action: :pseudo_reopen }).update_all(pseudo_reopen: true)

			p "Adicionando nos tickets que nao possuem pseudo reabertura como false"
			total = Ticket.where(pseudo_reopen: nil).count
			Ticket.where(pseudo_reopen: nil).in_batches(of: 10000).each_with_index do |relation, batch_index|
				relation.update_all(pseudo_reopen: false)
				p "#{(batch_index+1) * 10000} / #{total}"
			end

    end
  end
end