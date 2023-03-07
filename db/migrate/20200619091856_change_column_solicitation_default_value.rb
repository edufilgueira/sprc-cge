class ChangeColumnSolicitationDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :extensions, :solicitation, 1
  end
end
