class AddAuthorToImporter < ActiveRecord::Migration[5.0]
  def change
    add_column :importers, :author, :string
  end
end
