class AddImportedAtToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :imported_at, :date
  end
end
