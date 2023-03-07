class AddShowSurveyToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :show_survey, :boolean
  end
end
