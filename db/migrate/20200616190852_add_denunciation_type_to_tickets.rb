class AddDenunciationTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :denunciation_type, :integer
  end
end
