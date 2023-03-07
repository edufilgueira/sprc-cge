class AddOrganToServer < ActiveRecord::Migration[5.0]
  def change
    add_reference :integration_servers_servers, :organ, foreign_key: true
  end
end
