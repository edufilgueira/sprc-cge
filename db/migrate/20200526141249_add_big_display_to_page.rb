class AddBigDisplayToPage < ActiveRecord::Migration[5.0]
  def change
  	add_column :pages, :big_display, :boolean, default: false
  end
end
