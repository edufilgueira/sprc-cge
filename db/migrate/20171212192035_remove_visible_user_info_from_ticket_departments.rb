class RemoveVisibleUserInfoFromTicketDepartments < ActiveRecord::Migration[5.0]
  def change
    remove_column :ticket_departments, :visible_user_info
  end
end
