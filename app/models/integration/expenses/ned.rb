#
# Representa: NED - Notas de Empenho da Despesa
#
#
class Integration::Expenses::Ned < Integration::Expenses::Base
  include ::Integration::Expenses::Ned::Search

  CLASSIFICACAO_ORCAMENTARIA_RANGES = {
    before_2016: {
      unidade_orcamentaria: (0..7),
      funcao: (8..9),
      subfuncao: (10..12),
      programa_governo: (13..15),
      acao_governamental: (16..20),
      regiao_administrativa: (21..27),
      natureza_despesa: (28..35),
      fonte_recursos: (36..37),
      id_uso: (38..38),
      tipo_despesa: (39..39)
    },

    after_2016: {
      unidade_orcamentaria: (0..7),
      funcao: (8..9),
      subfuncao: (10..12),
      programa_governo: (13..15),
      acao_governamental: (16..20),
      regiao_administrativa: (21..22),
      natureza_despesa: (23..30),
      cod_destinacao: (31..31),
      fonte_recursos: (32..33),
      subfonte: (34..35),
      id_uso: (36..36),
      tipo_despesa: (37..37)
    }
  }

  enum transfer_type: [
    :transfer_none,
    :transfer_cities,
    :transfer_non_profits,
    :transfer_profits,
    :transfer_multi_govs,
    :transfer_consortiums
  ]

  # a. Transferência a município -  nas posições 3 e 4, onde o valor estejam preenchidos com '40' ou '41'.
  # b. Transferência a entidade sem fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '50'
  # c. Transferência a entidades com fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '60'
  # d. Transferências a Instituições Multigovernamentais- nas posições 3 e 4, onde o valor estejam preenchidos com '70'
  # e. Transferências a Consórcios Públicos - nas posições 3 e 4, onde o valor estejam preenchidos com '71'

  TRANSFER_TYPES = {
    transfer_cities: ['40', '41'],
    transfer_non_profits: ['50'],
    transfer_profits: ['60'],
    transfer_multi_govs: ['70'],
    transfer_consortiums: ['71']
  }

  # Associations

  belongs_to :ned_ordinaria,
    -> (ned) { where('integration_expenses_neds.exercicio = ? AND integration_expenses_neds.unidade_gestora = ?', ned.exercicio, ned.unidade_gestora) },
    foreign_key: :numero_ned_ordinaria,
    primary_key: :numero,
    class_name: 'Integration::Expenses::Ned'

  belongs_to :npf_ordinaria,
    -> (ned) { where('integration_expenses_npfs.exercicio = ? AND integration_expenses_npfs.unidade_gestora = ?', ned.exercicio, ned.unidade_gestora) },
    foreign_key: :numero_npf_ordinario,
    primary_key: :numero,
    class_name: 'Integration::Expenses::Npf'

  has_many :ned_items,
    foreign_key: 'integration_expenses_ned_id',
    inverse_of: :ned

  has_many :ned_planning_items,
    foreign_key: 'integration_expenses_ned_id',
    inverse_of: :ned

  has_many :ned_disbursement_forecasts,
    foreign_key: 'integration_expenses_ned_id',
    inverse_of: :ned

  has_many :nlds,
    foreign_key: :ned_composed_key,
    primary_key: :composed_key

  has_many :npds,
    through: :nlds

  has_many :neds,
    -> (ned) { where('integration_expenses_neds.exercicio = ? AND integration_expenses_neds.unidade_gestora = ?', ned.exercicio, ned.unidade_gestora) },
    foreign_key: :numero_ned_ordinaria,
    primary_key: :numero

  belongs_to :expense_nature_item,
    foreign_key: :item_despesa,
    primary_key: :codigo_item_natureza,
    class_name: 'Integration::Supports::ExpenseNatureItem'

  has_one :convenant,
    foreign_key: :isn_sic,
    primary_key: :numero_convenio,
    class_name: 'Integration::Contracts::Convenant'

  has_one :contract,
    foreign_key: :isn_sic,
    primary_key: :numero_contrato,
    class_name: 'Integration::Contracts::Contract'

  has_one :legal_device,
    foreign_key: :codigo,
    primary_key: :codigo_dispositivo_legal,
    class_name: 'Integration::Supports::LegalDevice'

  ## Associações relacionadas à classficação orçamentária

  has_one :budget_unit,
    foreign_key: :codigo_unidade_orcamentaria,
    primary_key: :classificacao_unidade_orcamentaria,
    class_name: 'Integration::Supports::BudgetUnit'

  has_one :function,
    foreign_key: :codigo_funcao,
    primary_key: :classificacao_funcao,
    class_name: 'Integration::Supports::Function'

  has_one :sub_function,
    foreign_key: :codigo_sub_funcao,
    primary_key: :classificacao_subfuncao,
    class_name: 'Integration::Supports::SubFunction'

  def government_program
    #
    # has_one :government_program,
    #   foreign_key: :codigo_programa,
    #   primary_key: :classificacao_programa_governo,
    #   class_name: 'Integration::Supports::GovernmentProgram'
    #
    #
    # Temos que ordenar pelo ano do programa de governo
    #
    @government_program = Integration::Supports::GovernmentProgram.where('codigo_programa = ? and ano_inicio <= ?', self.classificacao_programa_governo, self.exercicio).order('ano_inicio DESC').first
  end

  def government_program=(government_program)
    #
    # creates setter method for government_program
    #
    @government_program = government_program
  end

  has_one :government_action,
    foreign_key: :codigo_acao,
    primary_key: :classificacao_acao_governamental,
    class_name: 'Integration::Supports::GovernmentAction'

  has_one :administrative_region,
    foreign_key: :codigo_regiao_resumido,
    primary_key: :classificacao_regiao_administrativa,
    class_name: 'Integration::Supports::AdministrativeRegion'

  has_one :expense_nature,
    foreign_key: :codigo_natureza_despesa,
    primary_key: :classificacao_natureza_despesa,
    class_name: 'Integration::Supports::ExpenseNature'

  has_one :resource_source,
    foreign_key: :codigo_fonte,
    primary_key: :classificacao_fonte_recursos,
    class_name: 'Integration::Supports::ResourceSource'

  has_one :expense_type,
    foreign_key: :codigo,
    primary_key: :classificacao_tipo_despesa,
    class_name: 'Integration::Supports::ExpenseType'

  belongs_to :expense_element,
    primary_key: :codigo_elemento_despesa,
    foreign_key: :classificacao_elemento_despesa,
    class_name: 'Integration::Supports::ExpenseElement'


  # Delegations

  delegate :title, to: :budget_unit, prefix: true, allow_nil: true
  delegate :title, to: :function, prefix: true, allow_nil: true
  delegate :title, to: :sub_function, prefix: true, allow_nil: true
  delegate :title, to: :government_program, prefix: true, allow_nil: true
  delegate :title, to: :government_action, prefix: true, allow_nil: true
  delegate :title, to: :administrative_region, prefix: true, allow_nil: true
  delegate :title, to: :expense_nature, prefix: true, allow_nil: true
  delegate :title, to: :expense_nature_item, prefix: true, allow_nil: true
  delegate :title, to: :resource_source, prefix: true, allow_nil: true
  delegate :title, to: :expense_type, prefix: true, allow_nil: true
  delegate :title, to: :expense_nature_item, prefix: true, allow_nil: true
  delegate :title, to: :expense_element, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :numero_npf_ordinario,
    presence: true

  # Callbacks

  after_commit :broadcast_child_updated

  after_validation :set_composed_key, :set_transfer_type, :calculate_columns

  before_save :set_date_of_issue, :update_classification_data

  # Public

  ## Scopes

  def self.sum_dailies(month_year, registration)
    cpf_cnpj_credor = registration.dsc_cpf
    codigo_orgao = registration.organ.codigo_orgao

    dailies.from_month_year(month_year).from_cpf_cnpj_credor(cpf_cnpj_credor).from_organ(codigo_orgao).sum(:valor_pago)
  end

  def self.from_month_year(month_year)
    issued_on_month(Date.parse(month_year))
  end

  def self.from_year(year)
    where(exercicio: year)
  end

  def self.from_cpf_cnpj_credor(cpf_cnpj_credor)
    where("cpf_cnpj_credor = ?", cpf_cnpj_credor)
  end

  def self.dailies
    where(%q{
      (exercicio < 2016 AND substring(classificacao_orcamentaria_completo from 29 for 6) in ('339014','339015','449014','449015')) OR
      (exercicio >= 2016 AND substring(classificacao_orcamentaria_completo from 24 for 6) in ('339014','339015','449014','449015'))
    })
  end

  def self.with_numero(numero)
    return all unless numero.present?

    search = '%' + numero.tr(' ', '%') + '%'
    where('integration_expenses_neds.numero LIKE :search', search: search )
  end

  ## Class methods

  #
  # Usado por controllers que possuem o filtro de Credor.
  #
  def self.creditors_name_column
    'integration_expenses_neds.razao_social_credor'
  end

  ## Instance methods

  # Chamado pelas NED filhas quando são gravadas para que
  # as colunas calculadas (calculated_valor_suplementado, ...)
  # possam ser atualizadas.
  def child_updated
    update_calculated_columns
  end

  def items_description
    ned_items.pluck(:especificacao).join(' / ')
  end

  def daily?
    dailies = ['339014','339015','449014','449015']

    if exercicio < 2016
      dailies.include?(classificacao_orcamentaria_completo[28..33])
    else
      dailies.include?(classificacao_orcamentaria_completo[23..28])
    end
  end

  # Private

  private

  ### Callbacks

  # A NED tem 3 tipos de natureza: 'Ordinária', 'Anulação' e 'Suplementação'.
  # Para 'Anulação' e 'Suplementação', temos a referência para a ned_ordinaria
  # e precisamos avisá-la que as colunas de calculated_valor_suplementado
  # e calculated_valor_anulado.

  def broadcast_child_updated
    ned_ordinaria.present? && ned_ordinaria.child_updated
  end

  def update_calculated_columns
    # Método chamado por uma ned 'filha' para que os valores sejam calculados.
    calculate_columns

    save
  end

  def calculate_columns
    # calculated_valor_liquidado_exercicio
    # calculated_valor_final (valor + suplementado - anulado)
    # calculated_valor_pago_final (valor_pago + suplementado.valor_pago - anulado.valor_pago
    # calculated_valor_suplementado
    # calculated_valor_pago_suplementado
    # calculated_valor_anulado
    # calculated_valor_pago_anulado


    self.calculated_valor_anulado = neds.anulacoes.sum(:valor)
    self.calculated_valor_pago_anulado = neds.anulacoes.sum(:valor_pago)
    self.calculated_valor_suplementado = neds.suplementacoes.sum(:valor)
    self.calculated_valor_pago_suplementado = neds.suplementacoes.sum(:valor_pago)

    valor_pago_final = (valor_pago + calculated_valor_pago_suplementado - calculated_valor_pago_anulado)

    self.calculated_valor_liquidado_exercicio = (nlds_from_same_exercicio(:ordinarias).sum(:valor) + nlds_from_same_exercicio(:suplementacoes).sum(:valor) - nlds_from_same_exercicio(:anulacoes).sum(:valor))
    self.calculated_valor_liquidado_apos_exercicio = (nlds_from_another_exercicio(:ordinarias).sum(:valor) + nlds_from_another_exercicio(:suplementacoes).sum(:valor) - nlds_from_another_exercicio(:anulacoes).sum(:valor))

    # Valor pago no exercicio é o valor_pago_final
    # self.calculated_valor_pago_exercicio = valor_pago_final
    #
    # # XXX Revisar e recalcular todos: Medida paleativa para cálculo do valor pago para atender um demanda urgente
    self.calculated_valor_pago_exercicio = npds_from_same_exercicio(:ordinarias).sum(:valor) + npds_from_same_exercicio(:suplementacoes).sum(:valor) - npds_from_same_exercicio(:anulacoes).sum(:valor)

    self.calculated_valor_pago_apos_exercicio = (npds_from_another_exercicio(:ordinarias).sum(:valor) + npds_from_another_exercicio(:suplementacoes).sum(:valor) - npds_from_another_exercicio(:anulacoes).sum(:valor))

    # self.calculated_valor_pago_final = valor_pago_final + self.calculated_valor_pago_apos_exercicio
    #
    # XXX Revisar e recalcular todos: Medida paleativa para cálculo do valor pago para atender um demanda urgente
    self.calculated_valor_pago_final = npds.ordinarias.sum(:valor) + npds.suplementacoes.sum(:valor) - npds.anulacoes.sum(:valor)

    self.calculated_valor_final = (valor + calculated_valor_suplementado - calculated_valor_anulado)
  end

  # Atualiza os campos de acordo com a classificação orçamentária completa.
  #
  def update_classification_data
    assign_attributes(classificacao_orcamentaria_fields)
  end

  def classificacao_orcamentaria_fields
    # Até 2015:
    #
    # unidade_orcamentaria
    # funcao
    # subfuncao
    # programa_governo
    # acao_governamental
    # regiao_administrativa
    # natureza_despesa
    # fonte_recursos
    # id_uso
    # tipo_despesa
    #
    # > 40100001 28 846 002 01613 2200000 33904700 00 0 2 0
    # (40100001288460020161322000003390470000020)

    # Depois de 2015:
    #
    # unidade_orcamentaria
    # funcao
    # subfuncao
    # programa_governo
    # acao_governamental
    # regiao_administrativa
    # natureza_despesa
    # cod_destinacao
    # fonte_recursos
    # subfonte
    # id_uso
    # tipo_despesa
    #
    # > 40100001 28 846 002 01613 2200000 33904700 00 0 2 0
    # (40100001288460020161322000003390470000020)

    str = classificacao_orcamentaria_completo

    ranges = (exercicio < 2016 ?
      CLASSIFICACAO_ORCAMENTARIA_RANGES[:before_2016] :
      CLASSIFICACAO_ORCAMENTARIA_RANGES[:after_2016])

    attrs = {}

    ranges.each do |column_name, range|
      attrs["classificacao_#{column_name}"] = str[range]
    end

    # Define o elemento de despesa, que deve ser posições 5 e 6 de item_despesa

    if item_despesa.present?
      attrs["classificacao_elemento_despesa"] = item_despesa[4..5] # 4..5 pois zero-based
    end

    attrs
  end

  def set_transfer_type
    # a. Transferência a município -  nas posições 3 e 4, onde o valor estejam preenchidos com '40' ou '41'.
    # b. Transferência a entidade sem fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '50'
    # c. Transferência a entidades com fins lucrativos - nas posições 3 e 4, onde o valor estejam preenchidos com '60'
    # d. Transferências a Instituições Multigovernamentais- nas posições 3 e 4, onde o valor estejam preenchidos com '70'
    # e. Transferências a Consórcios Públicos - nas posições 3 e 4, onde o valor estejam preenchidos com '71'

    self.transfer_type = nil

    if item_despesa.present?
      transfer_type_value = item_despesa[2..3]

      TRANSFER_TYPES.each do |transfer_type_id, transfer_type_values|
        if transfer_type_values.include?(transfer_type_value)
          self.transfer_type = transfer_type_id
          break
        end
      end

      self.transfer_type = :transfer_none if self.transfer_type.nil?
    end
  end

  def set_composed_key
    self.composed_key = "#{exercicio}#{unidade_gestora}#{numero}"
  end

  # Métodos para cálcular valores fora do exercício.

  def npds_from_another_exercicio(natureza)
    npds.send(natureza).where("integration_expenses_npds.exercicio != ?", exercicio)
  end

  #
  # Métodos para cálcular valores dentro do exercício.
  #
  def npds_from_same_exercicio(natureza)
    npds.send(natureza).where("integration_expenses_npds.exercicio = ?", exercicio)
  end

  #
  # Notas de liquidação do mesmo ano da nota de empenho
  #
  def nlds_from_same_exercicio(natureza)
    nlds.send(natureza).where('integration_expenses_nlds.exercicio_restos_a_pagar::int = integration_expenses_nlds.exercicio')
  end

  def nlds_from_another_exercicio(natureza)
    nlds.send(natureza).where('integration_expenses_nlds.exercicio_restos_a_pagar::int != integration_expenses_nlds.exercicio')
  end
end
