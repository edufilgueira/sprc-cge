class Integration::Contracts::Additive < Integration::BaseDataChange
  include ::Sortable
  include Integration::Contracts::SubResource

  KIND = {
    extension: 49,
    addition: 50,
    reduction: 51,
    extension_addition: 52,
    extension_reduction: 53,
    no_type: 54,
    no_value: 55
  }

  # Validations

  ## Presence

  validates :data_aditivo,
    :data_inicio,
    :data_publicacao,
    :data_termino,
    :flg_tipo_aditivo,
    :isn_contrato_aditivo,
    :isn_ig,
    :isn_sic,
    :valor_acrescimo,
    :valor_reducao,
    :data_publicacao_portal,
    presence: true


  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_contracts_additives.isn_contrato_aditivo'
  end

  def self.default_sort_direction
    :desc
  end

  def self.credit
    where(flg_tipo_aditivo: [KIND[:addition], KIND[:extension_addition]])
  end

  def self.credit_sum
    credit.sum(:valor_acrescimo)
  end

  def self.reduction
    where(flg_tipo_aditivo: [KIND[:reduction], KIND[:extension_reduction]])
  end

  def self.reduction_sum
    reduction.sum(:valor_reducao)
  end

  def self.total_addition
    credit_sum - reduction_sum
  end

  ## Instance methods

  ### Helpers

  def title
    isn_contrato_aditivo.to_s
  end

  def data_termino_valid?
    data_termino.present? and data_termino.year > 1900
  end

  def data_aditivo_valid?
    data_aditivo.present? and data_aditivo.year > 1900
  end
end
