class CreateServiceTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :service_types do |t|
      t.string :name
      t.references :organ, foreign_key: true

      t.timestamps
    end
  end
end
