class AddLegacyFieldsToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :isn_manifestacao, :integer
    add_column :tickets, :isn_manifestacao_entidade, :integer
  end
end
