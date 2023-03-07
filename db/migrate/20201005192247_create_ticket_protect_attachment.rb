class CreateTicketProtectAttachment < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_protect_attachments do |t|
      t.references :resource, polymorphic: true, index: { name: 'index_ticket_protect_attachments_on_resource_type_and_id' }
      t.references :attachment, foreign_key: true

      t.timestamps
    end
  end
end
