class AddColumnFacebookProfileLinkToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_profile_link, :string
  end
end
