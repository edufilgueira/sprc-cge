class AddDenunciationClassificationToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :denunciation_classification, :integer
  end
end
