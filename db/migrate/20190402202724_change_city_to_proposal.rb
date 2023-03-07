class ChangeCityToProposal < ActiveRecord::Migration[5.0]
  def change
  	change_column :ppa_proposals, :city_id, :integer, :null => true
  end
end
