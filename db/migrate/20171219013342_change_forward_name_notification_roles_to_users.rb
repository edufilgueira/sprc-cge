class ChangeForwardNameNotificationRolesToUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :notification_roles
    add_column :users, :notification_roles, :string, default: {
        new_ticket: 'email',
        deadline: 'email',
        transfer: 'email',
        appeal: 'email',
        reopen: 'email',
        extension: 'email',
        answer: 'email',
        share: 'email',
        referral: 'email',
        invalidate: 'email',
        user_comment: 'system',
        internal_comment: 'system'
      }.to_yaml
  end

  def down
    remove_column :users, :notification_roles
    add_column :users, :notification_roles, :string, default: {
        new_ticket: 'email',
        deadline: 'email',
        transfer: 'email',
        appeal: 'email',
        reopen: 'email',
        extension: 'email',
        answer: 'email',
        share: 'email',
        forward: 'email',
        invalidate: 'email',
        user_comment: 'system',
        internal_comment: 'system'
      }.to_yaml
  end
end
