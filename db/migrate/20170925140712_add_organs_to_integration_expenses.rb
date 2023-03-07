class AddOrgansToIntegrationExpenses < ActiveRecord::Migration[5.0]
  def change
    add_reference(:integration_expenses_npfs, :management_unit, foreign_key: { to_table: :integration_supports_organs })
    add_reference(:integration_expenses_npfs, :executing_unit, foreign_key: { to_table: :integration_supports_organs })

    add_reference(:integration_expenses_neds, :management_unit, foreign_key: { to_table: :integration_supports_organs })
    add_reference(:integration_expenses_neds, :executing_unit, foreign_key: { to_table: :integration_supports_organs })

    add_reference(:integration_expenses_nlds, :management_unit, foreign_key: { to_table: :integration_supports_organs })
    add_reference(:integration_expenses_nlds, :executing_unit, foreign_key: { to_table: :integration_supports_organs })

    add_reference(:integration_expenses_npds, :management_unit, foreign_key: { to_table: :integration_supports_organs })
    add_reference(:integration_expenses_npds, :executing_unit, foreign_key: { to_table: :integration_supports_organs })
  end
end
