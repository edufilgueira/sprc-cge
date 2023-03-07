class RemoveIndexPPAAxesOnCodeToPPAAxes < ActiveRecord::Migration[5.0]
  def change
    remove_index "ppa_axes", name: "index_ppa_axes_on_code"
  end
end
