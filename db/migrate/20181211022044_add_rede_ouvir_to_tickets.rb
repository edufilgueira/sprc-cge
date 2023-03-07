class AddRedeOuvirToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :rede_ouvir, :boolean, default: false
  end
end
