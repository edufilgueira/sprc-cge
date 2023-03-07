class AddTypePlan < ActiveRecord::Migration[5.0]
  def change
  	add_column :ppa_plans, :status, :integer
  end
end