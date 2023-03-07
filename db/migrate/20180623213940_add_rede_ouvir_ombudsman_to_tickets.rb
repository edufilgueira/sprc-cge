class AddRedeOuvirOmbudsmanToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :rede_ouvir_ombudsman_id, :integer, index: true
  end
end
