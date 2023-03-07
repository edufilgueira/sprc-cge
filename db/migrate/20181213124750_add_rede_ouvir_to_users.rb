class AddRedeOuvirToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :rede_ouvir, :boolean, default: false, index: true
  end
end
