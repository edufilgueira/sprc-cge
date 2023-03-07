class CreateTickets < ActiveRecord::Migration[5.0]
  def up
    create_table :tickets do |t|
      t.string :description, null: false
      t.integer :answer_type, null: false
      t.string :email
      t.string :name
      t.integer :protocol, index: true, unique: true
      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    execute <<-SQL
      CREATE SEQUENCE protocol_seq start 1000;
      ALTER SEQUENCE protocol_seq OWNED BY tickets.protocol;
      ALTER TABLE tickets ALTER COLUMN protocol SET DEFAULT nextval('protocol_seq');
    SQL
  end

  def down
    drop_table :tickets
  end

end
