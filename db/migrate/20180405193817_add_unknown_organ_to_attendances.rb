class AddUnknownOrganToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :unknown_organ, :boolean
  end
end
