class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.string :cron_syntax_frequency
      t.references :scheduleable, polymorphic: true

      t.timestamps
    end
  end
end
