#
# Representa: NPF - Notas de Programação Financeira
#
#
class Integration::Expenses::Npf < Integration::Expenses::Base
  include ::Integration::Expenses::Npf::Search

  # Associations

  belongs_to :npf_ordinaria,
    -> (ned) { where('exercicio = ? AND unidade_gestora = ?', ned.exercicio, ned.unidade_gestora) },
    foreign_key: :numero_npf_ord,
    primary_key: :numero,
    class_name: 'Integration::Expenses::Npf'

  has_many :neds,
    -> (npf) { where('exercicio = ? AND unidade_gestora = ?', npf.exercicio, npf.unidade_gestora) },
    foreign_key: :numero_npf_ordinario,
    primary_key: :numero

  has_many :npfs,
    -> (npf) { where('exercicio = ? AND unidade_gestora = ?', npf.exercicio, npf.unidade_gestora) },
    foreign_key: :numero_npf_ord,
    primary_key: :numero


  has_one :convenant,
    foreign_key: :isn_sic,
    primary_key: :numeroconvenio,
    class_name: 'Integration::Contracts::Convenant'

  has_one :finance_group,
    foreign_key: :codigo_grupo_financeiro,
    primary_key: :grupo_fin,
    class_name: 'Integration::Supports::FinanceGroup'

  has_one :resource_source,
    foreign_key: :codigo_fonte,
    primary_key: :fonte_rec,
    class_name: 'Integration::Supports::ResourceSource'

  # Callbacks

  after_commit :broadcast_child_updated

  ## Instance methods

  # Chamado pelas NPF filhas quando são gravadas para que
  # as colunas calculadas (calculated_valor_suplementado, ...)
  # possam ser atualizadas.
  def child_updated
    update_calculated_columns
  end

  # Private

  private

  ### Callbacks

  # A NPF tem 3 tipos de natureza: 'ORDINARIA', 'ANULACAO' e 'SUPLEMENTACAO'.
  # Para 'ANULACAO' e 'SUPLEMENTACAO', temos a referência para a npf_ordinaria
  # e precisamos avisá-la que as colunas de calculated_valor_suplementado
  # e calculated_valor_anulado.

  def broadcast_child_updated
    npf_ordinaria.present? && npf_ordinaria.child_updated
  end

  def update_calculated_columns
    # calculated_valor_final (valor + suplementado - anulado)
    # calculated_valor_suplementado
    # calculated_valor_anulado

    self.calculated_valor_anulado = npfs.anulacoes.sum(:valor)
    self.calculated_valor_suplementado = npfs.suplementacoes.sum(:valor)
    self.calculated_valor_final = (valor + calculated_valor_suplementado - calculated_valor_anulado)

    save
  end
end
