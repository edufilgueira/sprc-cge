class AddDenunciationTrackingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :denunciation_tracking, :boolean, default: false
  end
end
