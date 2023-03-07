class CreatePageAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :page_attachments do |t|
      t.references :page
      t.string :document_id
      t.string :document_filename
      t.string :title
      t.date :imported_at

      t.timestamps
    end
  end
end
