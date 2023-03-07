class Integration::Eparcerias::TransferBankOrder < Integration::BaseDataChange
  include Integration::Contracts::SubResource

  # Validations

  ## Presence

  validates :isn_sic,
    :numero_ordem_bancaria,
    :tipo_ordem_bancaria,
    :nome_benceficiario,
    :valor_ordem_bancaria,
    :data_pagamento,
    presence: true


  def self.sorted
    order(data_pagamento: :desc)
  end

end

