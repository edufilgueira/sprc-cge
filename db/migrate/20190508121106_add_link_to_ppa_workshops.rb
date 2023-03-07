class AddLinkToPPAWorkshops < ActiveRecord::Migration[5.0]
  def change
  	add_column :ppa_workshops, :link, :string
  end
end
