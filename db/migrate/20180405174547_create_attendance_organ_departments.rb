class CreateAttendanceOrganDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_organ_departments do |t|
      t.references :attendance, null: false
      t.references :organ
      t.references :department
      t.boolean :unknown_department

      t.timestamps
    end
  end
end
