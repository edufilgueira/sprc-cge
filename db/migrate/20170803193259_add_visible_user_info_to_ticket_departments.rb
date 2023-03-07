class AddVisibleUserInfoToTicketDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_departments, :visible_user_info, :boolean, default: true
  end
end
