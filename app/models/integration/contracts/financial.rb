class Integration::Contracts::Financial < Integration::BaseDataChange
  include Integration::Contracts::SubResource
  include ::Sortable

  # Associations

  has_one :ned,
    -> (financial) { where('unidade_gestora::int = ? AND exercicio = ?', financial.cod_gestor, financial.ano_documento) },
    foreign_key: :numero,
    primary_key: :num_documento,
    class_name: 'Integration::Expenses::Ned'

  has_one :npf,
    -> (financial) { where('unidade_gestora::int = ? AND exercicio = ?', financial.cod_gestor, financial.ano_documento) },
    foreign_key: :numero,
    primary_key: :num_pagamento,
    class_name: 'Integration::Expenses::Npf'

  # Validations

  ## Presence

  validates :cod_entidade,
    :cod_fonte,
    :cod_gestor,
    :data_documento,
    :data_pagamento,
    :data_processamento,
    :flg_sic,
    :isn_sic,
    :valor_documento,
    :valor_pagamento,
    presence: true


  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_contracts_financials.data_documento'
  end

  def self.default_sort_direction
    :desc
  end

  def self.document_sum
    sum(:valor_documento)
  end

  def self.payment_sum
    sum(:valor_pagamento)
  end


  ## Instance methods

  ### Helpers

  def title
    num_documento
  end

end
