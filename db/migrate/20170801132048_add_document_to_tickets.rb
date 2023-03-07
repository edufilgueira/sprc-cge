class AddDocumentToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :document_type, :integer
    add_column :tickets, :document, :string
  end
end
