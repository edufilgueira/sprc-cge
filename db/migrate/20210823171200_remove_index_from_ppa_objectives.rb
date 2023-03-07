class RemoveIndexFromPPAObjectives < ActiveRecord::Migration[5.0]
  def change
    remove_index :ppa_objectives, name: "index_ppa_objectives_on_code"
  end
end
