class AddAnswerToAttendance < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :answer, :text
    add_column :attendances, :answered, :boolean, default: false
  end
end
