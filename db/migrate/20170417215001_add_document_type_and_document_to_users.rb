class AddDocumentTypeAndDocumentToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :document_type, :integer
    add_index :users, :document_type
    add_column :users, :document, :string
  end
end
