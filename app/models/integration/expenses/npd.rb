#
# Representa: NPD - Notas de Pagamento da Despesa
#
#
class Integration::Expenses::Npd < Integration::Expenses::Base
  include ::Integration::Expenses::Npd::Search

  # Associations

  belongs_to :npd_ordinaria,
    -> (npd) { where('integration_expenses_npds.exercicio = ? AND integration_expenses_npds.unidade_gestora = ?', npd.exercicio, npd.unidade_gestora) },
    foreign_key: :numero_npd_ordinaria,
    primary_key: :numero,
    class_name: 'Integration::Expenses::Npd'

  belongs_to :nld,
    foreign_key: :nld_composed_key,
    primary_key: :composed_key

  has_one :payment_retention_type,
    foreign_key: :codigo_retencao,
    primary_key: :codigo_retencao,
    class_name: 'Integration::Supports::PaymentRetentionType'

  has_one :revenue_nature,
    foreign_key: :codigo_natureza_receita,
    primary_key: :codigo,
    class_name: 'Integration::Supports::RevenueNature'

  has_many :npds,
    -> (npd) { where('integration_expenses_npds.exercicio = ? AND integration_expenses_npds.unidade_gestora = ?', npd.exercicio, npd.unidade_gestora) },
    foreign_key: :numero_npd_ordinaria,
    primary_key: :numero

  # Validations

  ## Presence

  validates :numero_nld_ordinaria,
    presence: true

  # Callbacks

  after_validation :set_nld_composed_key, :set_daily, :set_calculated_valor_final

  after_commit :broadcast_change_to_ned

  after_commit :update_calculated_valor_final_from_ordinaria


  # Scopes

  ## Instance methods

  ### Helpers

  def valor_final
    valor + npds.suplementacoes.sum(:valor) - npds.anulacoes.sum(:valor)
  end

  def ned
    @ned ||= ( (nld.present? && nld.ned) || nil )
  end

  # Privates

  private

  def set_nld_composed_key
    self.nld_composed_key = "#{exercicio}#{unidade_gestora}#{numero_nld_ordinaria}"
  end

  def set_daily
    if ned.present?
      self.daily = ned.daily?
    end
  end

  def broadcast_change_to_ned
    ned&.child_updated
  end

  def set_calculated_valor_final
    self.calculated_valor_final = valor_final
  end

  def update_calculated_valor_final_from_ordinaria
    # save dispara o callback set_calculated_valor_final
    if (anulacao? || suplementacao?) && npd_ordinaria.present?
      npd_ordinaria.save
    end
  end
end
