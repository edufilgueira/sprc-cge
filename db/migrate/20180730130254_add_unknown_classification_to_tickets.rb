class AddUnknownClassificationToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :unknown_classification, :boolean, default: true
  end
end
