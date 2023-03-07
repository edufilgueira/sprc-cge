class AddColumnIsnOnPPAObjetives < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_objectives, :isn, :integer
  end
end
