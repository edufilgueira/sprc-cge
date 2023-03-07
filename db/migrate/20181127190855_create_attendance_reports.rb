class CreateAttendanceReports < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_reports do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :user
      t.text :filters
      t.integer :status
      t.integer :processed
      t.integer :total_to_process

      t.timestamps
    end
  end
end
