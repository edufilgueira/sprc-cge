class CreateAttendances < ActiveRecord::Migration[5.0]
  def up
    create_table :attendances do |t|
      t.integer :protocol, index: true, unique: true
      t.references :ticket, foreign_key: true
      t.integer :service_type, index: true
      t.text :description
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE attendances ALTER COLUMN protocol SET DEFAULT nextval('protocol_seq');
    SQL
  end

  def down
    drop_table :attendances
  end
end
