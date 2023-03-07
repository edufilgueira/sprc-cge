#
# Representa 'Transferência a Organizaçao sem fins lucrativos'
#
#
class Integration::Expenses::NonProfitTransfer < Integration::Expenses::Ned

  # Scope

  default_scope do
    where(transfer_type: :transfer_non_profits)
  end
end
