class RemoveDenunciationTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    remove_column :tickets, :denunciation_type, :integer
  end
end
