class RemoveAuthorFromComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :author
  end
end
