class AddAnswerWhatsapp < ActiveRecord::Migration[5.0]
  def change
  	add_column :tickets, :answer_whatsapp, :string
  end
end
