class AddSolicitationToExtensions < ActiveRecord::Migration[5.0]
  def change
    add_column :extensions, :solicitation, :integer
  end
end
