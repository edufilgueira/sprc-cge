#
# Representa 'Transferência a Município'
#
#
class Integration::Expenses::CityTransfer < Integration::Expenses::Ned

  # Scope

  default_scope do
    where(transfer_type: :transfer_cities)
  end
end
