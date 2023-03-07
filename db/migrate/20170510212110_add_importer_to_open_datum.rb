class AddImporterToOpenDatum < ActiveRecord::Migration[5.0]
  def change
    add_reference :open_data, :importer, foreign_key: true
  end
end
