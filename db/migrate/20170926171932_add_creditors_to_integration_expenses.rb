class AddCreditorsToIntegrationExpenses < ActiveRecord::Migration[5.0]
  def change
    add_reference(:integration_expenses_npfs, :creditor, foreign_key: { to_table: :integration_supports_creditors })
    add_reference(:integration_expenses_neds, :creditor, foreign_key: { to_table: :integration_supports_creditors })
    add_reference(:integration_expenses_nlds, :creditor, foreign_key: { to_table: :integration_supports_creditors })
    add_reference(:integration_expenses_npds, :creditor, foreign_key: { to_table: :integration_supports_creditors })
  end
end
