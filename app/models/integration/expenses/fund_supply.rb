#
# Representa 'Suprimento de Fundo'
#
#
class Integration::Expenses::FundSupply < Integration::Expenses::Ned

  # Scope

  # "33903000096" "Materiais de Consumo - Suprimento de Fundos"
  # "33903900096" "Outros serviços de terc pessoa jurídica-suprimento de fundos"

  default_scope do
    where('integration_expenses_neds.item_despesa = ? OR integration_expenses_neds.item_despesa = ?', '33903000096', '33903900096')
  end
end
