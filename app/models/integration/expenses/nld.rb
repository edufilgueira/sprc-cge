#
# Representa: NLD - Notas de Liquidação da Despesa
#
#
class Integration::Expenses::Nld < Integration::Expenses::Base
  include ::Integration::Expenses::Nld::Search

  # Associations

  belongs_to :nld_ordinaria,
    -> (nld) { where('integration_expenses_nlds.exercicio = ? AND integration_expenses_nlds.unidade_gestora = ?', nld.exercicio, nld.unidade_gestora) },
    foreign_key: :numero_nld_ordinaria,
    primary_key: :numero,
    class_name: 'Integration::Expenses::Nld'

  belongs_to :ned,
    foreign_key: :ned_composed_key,
    primary_key: :composed_key

  has_many :nld_item_payment_plannings, foreign_key: 'integration_expenses_nld_id', inverse_of: :nld

  has_many :nld_item_payment_retentions, foreign_key: 'integration_expenses_nld_id', inverse_of: :nld

  has_many :npds,
    foreign_key: :nld_composed_key,
    primary_key: :composed_key

  has_many :nlds,
    -> (nld) { where('integration_expenses_nlds.exercicio = ? AND integration_expenses_nlds.unidade_gestora = ?', nld.exercicio, nld.unidade_gestora) },
    foreign_key: :numero_nld_ordinaria,
    primary_key: :numero


  # Callbacks

  after_validation :set_composed_key, :set_ned_composed_key

  after_commit :broadcast_change_to_ned

  # Private

  private

  def set_composed_key
    self.composed_key =  "#{exercicio}#{unidade_gestora}#{numero}"
  end

  def set_ned_composed_key
    self.ned_composed_key =  "#{exercicio_restos_a_pagar}#{unidade_gestora}#{numero_nota_empenho_despesa}"
  end

  def broadcast_change_to_ned
    ned&.child_updated
  end
end
