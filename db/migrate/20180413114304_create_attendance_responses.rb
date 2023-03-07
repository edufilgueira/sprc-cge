class CreateAttendanceResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_responses do |t|
      t.text :description, null: false
      t.integer :response_type, null: false
      t.references :ticket

      t.timestamps
    end
  end
end
