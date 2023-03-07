class RenameAttachmentsFileToDocument < ActiveRecord::Migration[5.0]
  def up
    rename_column :attachments, :file_id, :document_id
    rename_column :attachments, :file_filename, :document_filename
  end

  def down
    rename_column :attachments, :document_id, :file_id
    rename_column :attachments, :document_filename, :file_filename
  end
end
