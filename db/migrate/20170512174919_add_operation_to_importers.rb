class AddOperationToImporters < ActiveRecord::Migration[5.0]
  def change
    add_column :importers, :operation, :string
  end
end
