#
# Representa 'Transferências a Consórcios Públicos'
#
#
class Integration::Expenses::ConsortiumTransfer < Integration::Expenses::Ned

  # Scope

  default_scope do
    where(transfer_type: :transfer_consortiums)
  end
end
