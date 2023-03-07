class RemoveCommitteeTypeToCommittees < ActiveRecord::Migration[5.0]
  def up
    remove_column :committees, :committee_type
  end

  def down
    add_column :committees, :committee_type, :integer
  end
end
