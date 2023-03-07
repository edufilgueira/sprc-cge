class RemoveTokenExtension < ActiveRecord::Migration[5.0]
  def change
    remove_column :extensions, :token, :string
  end
end
