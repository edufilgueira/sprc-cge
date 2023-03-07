class ChangeTicketsExtendedSecondTimeToDefaultFalse < ActiveRecord::Migration[5.0]
	def change
    change_column_default :tickets, :extended_second_time, false
  end
end
