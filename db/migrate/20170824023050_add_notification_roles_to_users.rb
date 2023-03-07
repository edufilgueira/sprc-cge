class AddNotificationRolesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notification_roles, :string, default: { ticket: 'email', comment: 'system' }.to_yaml
  end
end
