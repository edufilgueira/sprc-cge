class AddColumnIsnOnPPAAxes < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_axes, :isn, :integer
  end
end
