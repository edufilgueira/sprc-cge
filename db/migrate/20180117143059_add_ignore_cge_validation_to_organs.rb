class AddIgnoreCgeValidationToOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :organs, :ignore_cge_validation, :boolean
  end
end
