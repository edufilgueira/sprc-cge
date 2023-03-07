class AddTitleToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :title, :string
  end
end
