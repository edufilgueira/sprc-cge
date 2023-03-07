class ChangeDenunciationClassificationTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    remove_column :tickets, :denunciation_classification, :integer
    add_column :tickets, :denunciation_against_operator, :boolean
  end
end
