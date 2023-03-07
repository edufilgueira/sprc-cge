class RemoveIndexFromPPAStrategy < ActiveRecord::Migration[5.0]
  def change
    remove_index :ppa_strategies, name: "index_ppa_strategies_on_code"
  end
end
