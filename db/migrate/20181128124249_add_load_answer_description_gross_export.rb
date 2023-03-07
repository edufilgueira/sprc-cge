class AddLoadAnswerDescriptionGrossExport < ActiveRecord::Migration[5.0]
  def change
    add_column :gross_exports, :load_description, :boolean, default: false
    add_column :gross_exports, :load_answers, :boolean, default: false
  end
end
