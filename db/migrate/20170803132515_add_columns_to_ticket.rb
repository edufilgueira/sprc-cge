class AddColumnsToTicket < ActiveRecord::Migration[5.0]
  def change
    add_reference :tickets, :denunciation_organ, foreign_key: { to_table: :organs }
    add_column :tickets, :denunciation_type, :integer
    add_column :tickets, :denunciation_description, :text
    add_column :tickets, :denunciation_date, :string
    add_column :tickets, :denunciation_place, :string
    add_column :tickets, :denunciation_assurance, :integer
    add_column :tickets, :denunciation_witness, :text
    add_column :tickets, :denunciation_evidence, :text
  end
end
