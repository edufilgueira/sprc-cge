class CreateRedeOuvirOmbudsmen < ActiveRecord::Migration[5.0]
  def change
    create_table :rede_ouvir_ombudsmen do |t|
      t.string :name
      t.string :acronym
      t.datetime :disabled_at

      t.timestamps
    end
  end
end
