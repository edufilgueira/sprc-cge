class ChangeColumnRatedDefaultValue < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :sou_evaluation_sample_details, :rated, false
  end
end
