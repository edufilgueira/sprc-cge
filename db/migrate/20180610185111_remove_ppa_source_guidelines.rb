class RemovePPASourceGuidelines < ActiveRecord::Migration[5.0]
  def change
    # movido para sprc-data @ PPA::Source::Guideline
    drop_table :ppa_source_guidelines
  end
end
