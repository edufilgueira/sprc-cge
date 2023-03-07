class RemoveInvalidateStatusFromTicketLog < ActiveRecord::Migration[5.0]
  def up
    ticket_logs = TicketLog.invalidate

    ticket_logs.each do |ticket_log|
      next if ticket_log.data[:status].present?

      ticket_log.data[:status] = ticket_log.invalidate_status
      ticket_log.save
    end

    remove_column :ticket_logs, :invalidate_status, :integer
  end

  def down
    add_column :ticket_logs, :invalidate_status, :integer

    ticket_logs = TicketLog.invalidate

    ticket_logs.each do |ticket_log|
      next if ticket_log.invalidate_status.present?

      ticket_log.invalidate_status = ticket_log.data[:status]
      ticket_log.save
    end

  end
end
