class ChangeTicketsUnknownClassificationToDefaultFalse < ActiveRecord::Migration[5.0]
  def change
    change_column_default :tickets, :unknown_classification, false
  end
end
