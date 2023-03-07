class RemoveStartAtAndEndAtFromPPAProducts < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_products, :start_at, :datetime
    remove_column :ppa_products, :end_at,   :datetime
  end
end
