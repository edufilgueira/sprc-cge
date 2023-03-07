#
# Representa 'Transferência a Organizaçao com fins lucrativos'
#
#
class Integration::Expenses::ProfitTransfer < Integration::Expenses::Ned

  # Scope

  default_scope do
    where(transfer_type: :transfer_profits)
  end
end
