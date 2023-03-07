class RemoveKindFromOpenDatum < ActiveRecord::Migration[5.0]
  def change
    remove_column :open_data, :kind, :integer
  end
end
