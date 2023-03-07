class AddUserToTicketProtectAttachments < ActiveRecord::Migration[5.0]
  def change
    add_reference :ticket_protect_attachments, :user, foreign_key: true
  end
end
