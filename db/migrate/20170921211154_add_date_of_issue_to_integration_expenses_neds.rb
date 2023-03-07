class AddDateOfIssueToIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_neds, :date_of_issue, :date
  end
end
