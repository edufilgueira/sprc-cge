class Integration::Contracts::Adjustment < Integration::BaseDataChange
  include ::Sortable
  include Integration::Contracts::SubResource

  # Validations

  ## Presence

  validates  :data_ajuste,
    :data_inclusao,
    :data_inicio,
    :flg_acrescimo_reducao,
    :flg_controle_transmissao,
    :flg_receita_despesa,
    :flg_tipo_ajuste,
    :isn_contrato_ajuste,
    :isn_contrato_tipo_ajuste,
    :ins_edital,
    :isn_sic,
    :isn_situacao,
    :isn_usuario_alteracao,
    :isn_usuario_aprovacao,
    :isn_usuario_auditoria,
    :isn_usuario_exclusao,
    :valor_ajuste_destino,
    :valor_ajuste_origem,
    :valor_inicio_destino,
    :valor_inicio_origem,
    :valor_termino_origem,
    :valor_termino_destino,
    presence: true


  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_contracts_adjustments.data_ajuste'
  end

  def self.total_adjustments
    sum(:valor_ajuste_destino) + sum(:valor_ajuste_origem)
  end

  ## Instance methods

  ### Helpers

  def title
    isn_contrato_ajuste.to_s
  end

  def total_adjustment
    valor_ajuste_destino + valor_ajuste_origem
  end

  def data_termino_valid?
    data_termino.present? and data_termino.year > 1900
  end

  def data_ajuste_or_data_inclusao   
    (data_ajuste.present? and data_ajuste.year > 1900) ? data_ajuste.to_date  : data_inclusao.to_date
  end 

  def data_ajuste_valid?
    (data_ajuste.present? and data_ajuste.year > 1900) or (data_inclusao.present?)
  end
end