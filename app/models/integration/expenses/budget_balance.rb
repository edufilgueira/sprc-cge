
# Representa: BudgetBalance - Saldo Orçamentário
#
#
class Integration::Expenses::BudgetBalance < ApplicationDataRecord
  include ::Sortable
  include Integration::SecretaryAndOrganWithDataTermino
  include Integration::Expenses::BudgetBalance::Search

  # Associations

  # Temos que dar essa volta no belongs_to pois o órgão tem 'data_termino'.
  # Ou seja, para a associação, primeiro temos que tentar encontrar um órgão
  # com a data_termino <= à data deste registro. Caso não encontre, tenta
  # encontrar um com data_termino 'nil'.
  #
  # Ex:
  # SECRETARIA DA SEGURANÇA PÚBLICA E DEFESA SOCIAL: data_termino: 06/12/2017
  # Como a despesa só tem mês/ano, vamos considerar a data_termino do órgão como sendo o final do mês.

  belongs_to :organ,
    foreign_key: 'integration_supports_organ_id',
    class_name: 'Integration::Supports::Organ'

  belongs_to :secretary,
    foreign_key: 'integration_supports_secretary_id',
    class_name: 'Integration::Supports::Organ'

  belongs_to :management_unit,
    foreign_key: :cod_unid_gestora,
    primary_key: :codigo,
    class_name: 'Integration::Supports::ManagementUnit'

  belongs_to :budget_unit,
    foreign_key: :cod_unid_orcam,
    primary_key: :codigo_unidade_orcamentaria,
    class_name: 'Integration::Supports::BudgetUnit'

  belongs_to :function,
    foreign_key: :cod_funcao,
    primary_key: :codigo_funcao,
    class_name: 'Integration::Supports::Function'

  belongs_to :sub_function,
      foreign_key: :cod_subfuncao,
      primary_key: :codigo_sub_funcao,
      class_name: 'Integration::Supports::SubFunction'

  belongs_to :government_program,
      foreign_key: :integration_supports_government_program_id,
      class_name: 'Integration::Supports::GovernmentProgram'

  belongs_to :government_action,
      foreign_key: :cod_acao,
      primary_key: :codigo_acao,
      class_name: 'Integration::Supports::GovernmentAction'

  belongs_to :economic_category,
      foreign_key: :cod_categoria_economica,
      primary_key: :codigo_categoria_economica,
      class_name: 'Integration::Supports::EconomicCategory'

  belongs_to :application_modality,
      foreign_key: :cod_modalidade_aplicacao,
      primary_key: :codigo_modalidade,
      class_name: 'Integration::Supports::ApplicationModality'

  belongs_to :expense_element,
      foreign_key: :cod_elemento_despesa,
      primary_key: :codigo_elemento_despesa,
      class_name: 'Integration::Supports::ExpenseElement'

  belongs_to :administrative_region,
      foreign_key: :cod_localizacao_gasto,
      primary_key: :codigo_regiao_resumido,
      class_name: 'Integration::Supports::AdministrativeRegion'

  belongs_to :expense_nature,
      foreign_key: :cod_natureza_desp,
      primary_key: :codigo_natureza_despesa,
      class_name: 'Integration::Supports::ExpenseNature'

  belongs_to :qualified_resource_source,
      foreign_key: :cod_fonte,
      primary_key: :codigo,
      class_name: 'Integration::Supports::QualifiedResourceSource'

  belongs_to :finance_group,
      foreign_key: :cod_grupo_fin,
      primary_key: :codigo_grupo_financeiro,
      class_name: 'Integration::Supports::FinanceGroup'

  # Validations

  ## Presence

  validates :ano_mes_competencia,
    :cod_unid_gestora,
    :cod_unid_orcam,
    :classif_orcam_completa,
    presence: true

  # Delegations

   # Delegations

  delegate :title, to: :secretary, prefix: true, allow_nil: true
  delegate :title, to: :organ, prefix: true, allow_nil: true
  delegate :title, to: :function, prefix: true, allow_nil: true
  delegate :title, to: :sub_function, prefix: true, allow_nil: true
  delegate :title, to: :government_program, prefix: true, allow_nil: true
  delegate :title, to: :government_action, prefix: true, allow_nil: true
  delegate :title, to: :administrative_region, prefix: true, allow_nil: true
  delegate :title, to: :expense_nature, prefix: true, allow_nil: true
  delegate :title, to: :qualified_resource_source, prefix: true, allow_nil: true
  delegate :title, to: :finance_group, prefix: true, allow_nil: true
  delegate :title, to: :economic_category, prefix: true, allow_nil: true
  delegate :title, to: :application_modality, prefix: true, allow_nil: true
  delegate :title, to: :expense_element, prefix: true, allow_nil: true

  # Callbacks

  after_validation :set_calculated_columns,
    :set_month_year,
    :set_organ,
    :set_government_program,
    :set_codigos

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_expenses_budget_balances.calculated_valor_pago'
  end

  def self.default_sort_direction
    :desc
  end

  def self.from_month(year, month)
    from_year(year: year).where(month: month)
  end

  def self.from_year(year)
    where(year: year)
  end

  # Private

  private

  def set_calculated_columns
    self.calculated_valor_orcamento_inicial = safe_number(valor_inicial)
    self.calculated_valor_orcamento_atualizado = (safe_number(valor_inicial) + safe_number(valor_suplementado) + safe_number(valor_transferido_recebido) - safe_number(valor_transferido_concedido) - safe_number(valor_anulado))
    self.calculated_valor_empenhado = (safe_number(valor_empenhado) - safe_number(valor_empenhado_anulado))
    self.calculated_valor_liquidado = (safe_number(valor_liquidado) - safe_number(valor_liquidado_anulado))
    self.calculated_valor_pago = (safe_number(valor_pago) - safe_number(valor_pago_anulado)) + (safe_number(valor_liquidado_retido) - safe_number(valor_liquidado_retido_anulado))
  end

  def safe_number(value)
    value || 0
  end

  def set_month_year
    if ano_mes_competencia.present? && month.blank? && year.blank?
      self.month, self.year = ano_mes_competencia.split('-')
    end
  end

  def set_organ
    if cod_unid_gestora.present?
      self.organ = organ_with_data_termino(cod_unid_gestora)
      self.secretary = secretary_from_organ(self.organ)
    end
  end

  def set_government_program
    if cod_programa.present? && year.present?
      self.government_program =
        Integration::Supports::GovernmentProgram.where(codigo_programa: cod_programa).where('ano_inicio <= ?', year).order('ano_inicio DESC').first
    end
  end

  def set_codigos
    if (cod_natureza_desp.present?)
      self.cod_categoria_economica = cod_natureza_desp[0]
      self.cod_modalidade_aplicacao = cod_natureza_desp[2..3]
      self.cod_elemento_despesa = cod_natureza_desp[4..5]
    end
  end
end
