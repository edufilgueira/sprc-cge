class AddPPAPlanToPPAAxes < ActiveRecord::Migration[5.0]
  def change
  	add_column :ppa_axes, :plan_id, :integer
  	add_foreign_key :ppa_axes, :ppa_plans, column: :plan_id
   
    
  end
end
