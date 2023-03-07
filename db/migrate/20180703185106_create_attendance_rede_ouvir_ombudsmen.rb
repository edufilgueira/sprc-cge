class CreateAttendanceRedeOuvirOmbudsmen < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_rede_ouvir_ombudsmen do |t|
      t.references :attendance, foreign_key: true
      t.references :rede_ouvir_ombudsman, foreign_key: true, index: { name: 'attendace_ombudsman_id_idx' }

      t.timestamps
    end
  end
end
