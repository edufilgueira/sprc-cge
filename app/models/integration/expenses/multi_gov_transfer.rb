#
# Representa 'Transferências a Instituições Multigovernamentais'
#
#
class Integration::Expenses::MultiGovTransfer < Integration::Expenses::Ned

  # Scope

  default_scope do
    where(transfer_type: :transfer_multi_govs)
  end
end
