class AddSectoralDenunciationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sectoral_denunciation, :boolean, default: true
  end
end
