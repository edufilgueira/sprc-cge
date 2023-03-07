class DenunciationTrackingDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :denunciation_tracking, from: nil, to: false
  end
end
