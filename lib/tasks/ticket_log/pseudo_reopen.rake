# rake ticket_log:pseudo_reopen:create
namespace :ticket_log do
  namespace :pseudo_reopen do
    desc "Adicionando ticket_log com action :pseudo_reopen para todos os tickets com pseudo reabertura"

    task create: :environment  do |t|
      total = Ticket.where.not(parent_id: nil).where('reopened > 0').count
      pseudo_count = 0

      Ticket.where.not(parent_id: nil).where('reopened > 0').find_each.with_index do |ticket, index|
        ticket_parent = ticket.parent
        ticket_parent_log_first_reopen = ticket_parent.ticket_logs.where(action: :reopen).order(:created_at).first

        if (ticket_parent_log_first_reopen.created_at < ticket.created_at) && ticket.ticket_logs.pseudo_reopen.blank?
          pseudo_count += 1

          ticket.ticket_logs.create(
            action: :pseudo_reopen,
            responsible: ticket.created_by || ticket_parent_log_first_reopen.responsible,
            description: ticket.justification,
            data: { count: ticket.reopened },
            created_at: ticket.created_at,
            updated_at: ticket.created_at
          )
        end

        puts "Percorrido: #{index}/#{total}. Pseudo reaberturas encontradas: #{pseudo_count}"
      end
    end
  end
end