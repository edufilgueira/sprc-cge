# rake ticket_log:organ_defined_after_reopening:create
namespace :ticket_log do
  namespace :organ_defined_after_reopening do
    desc "Adicionando ticket_log com action :organ_defined_after_reopen para todos os tickets que tiveram uma reabertura e so entao associaram a um orgao"

    task create: :environment do |t|
      def first_share_from_ticket(ticket)
        ticket.ticket_logs.where(action: :share).order(:created_at).first
      end

      # Pega a ultima reabertura para saber a versao do data count
      def last_reopen_ticket_log_without_organ(ticket)
        return [] unless ticket.reopened?

        first_share = first_share_from_ticket(ticket)

        ticket.ticket_logs.where(
          ticket_logs: { action: :reopen }
        ).where(
          'ticket_logs.created_at < ?', first_share.created_at
        ).order(:created_at).last
      end

      ticket_parent_ids = Ticket.joins(:ticket_logs).where(
        ticket_logs: { action: :pseudo_reopen }
      ).pluck(:parent_id).uniq.compact
      ticket_parent_ids_count = ticket_parent_ids.count
      reopened_tickets_without_organ_count = 0

      ticket_parent_ids.each_with_index do |ticket_parent_id, index|
        ticket = Ticket.find(ticket_parent_id)

        last_reopen_ticket_log_without_organ = last_reopen_ticket_log_without_organ(ticket)

        puts "Percorrido: #{index}/#{ticket_parent_ids_count}"

        next if last_reopen_ticket_log_without_organ.blank?

        first_share = first_share_from_ticket(ticket)

        ticket.ticket_logs.create(
          action: :organ_defined_after_reopening,
          responsible: ticket.created_by,
          description: ticket.justification,
          data: { count: last_reopen_ticket_log_without_organ.data[:count] },
          created_at: first_share.created_at,
          updated_at: first_share.created_at
        )

        reopened_tickets_without_organ_count += 1

        puts "Tickets encontrados: #{reopened_tickets_without_organ_count}"
      end
    end
  end
end