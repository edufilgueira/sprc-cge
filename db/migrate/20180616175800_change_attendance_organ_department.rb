class ChangeAttendanceOrganDepartment < ActiveRecord::Migration[5.0]
  def change
    rename_column :attendance_organ_departments, :department_id, :subnet_id
    rename_column :attendance_organ_departments, :unknown_department, :unknown_subnet
    rename_table :attendance_organ_departments, :attendance_organ_subnets
  end
end
