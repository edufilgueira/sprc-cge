class AddWebserviceToImporter < ActiveRecord::Migration[5.0]
  def change
    add_column :importers, :webservice, :string
  end
end
