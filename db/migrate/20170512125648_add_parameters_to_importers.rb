class AddParametersToImporters < ActiveRecord::Migration[5.0]
  def change
    add_column :importers, :parameters, :string
  end
end
