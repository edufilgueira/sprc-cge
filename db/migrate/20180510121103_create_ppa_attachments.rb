class CreatePPAAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_attachments do |t|
      t.string  :type,                    null: false
      t.string  :uploadable_type,         null: false
      t.integer :uploadable_id,           null: false
      t.string  :attachment_id,           null: false
      t.string  :attachment_filename,     null: false
      t.string  :attachment_content_type, null: false

      t.timestamps
    end
  end
end
