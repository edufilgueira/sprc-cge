class Integration::Contracts::Convenant < Integration::Contracts::Contract
  include ::Integration::Contracts::Contract::Search

  # Consts
  NOTIFICABLE_CHANGED_ATTRIBUTES = [
    :descricao_situacao,
    :data_termino,
    :valor_original_contrapartida,
    :infringement_status

    # Notas de Empenho    - callback em Integration::Contracts::Financial
    # Notas de Pagamentos - callback em Integration::Contracts::Financial
    # Aditivo             - callback em Integration::Contracts::Additive
    # Ajuste              - callback em Integration::Contracts::Adjustment
    # OBTs:               - callback em Integration::Contracts::TransferBankOrder
  ]

  # Enums

  enum infringement_status: [:adimplente, :inadimplente]

  def self.default_scope
    from_type(:convenio)
  end
end
