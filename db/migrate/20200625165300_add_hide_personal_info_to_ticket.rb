class AddHidePersonalInfoToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :hide_personal_info, :boolean
  end
end
