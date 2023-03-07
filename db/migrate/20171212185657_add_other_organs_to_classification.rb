class AddOtherOrgansToClassification < ActiveRecord::Migration[5.0]
  def change
    add_column :classifications, :other_organs, :boolean, default: false
  end
end
