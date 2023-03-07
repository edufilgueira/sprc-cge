#
# Tabela Execício
#
# Natureza da Receita
#

class Integration::Supports::RevenueNature < ApplicationDataRecord
  include Integration::Supports::RevenueNature::TransferCodes

  EMPTY_PARENT_CODE = '000000000'

  enum revenue_nature_type: [
    :consolidado,
    :categoria_economica,
    :origem,
    :subfonte,
    :rubrica,
    :alinea,
    :subalinea
  ]

  REVENUE_NATURE_TYPE_CODES = {
    consolidado: [/^[1-9]00000000$/], # Ex: 100000000, 800000000, 900000000,
    categoria_economica: [/^[1-9][1-9]0000000$/, /^[1-9]000000000$/], # Ex: 110000000, 810000000
    origem: [/^[1-9][1-9][1-9]000000$/, /^[1-9][1-9]00000000$/], # Ex: 111000000
    subfonte: [/^[1-9][1-9][1-9][1-9]00000$/, /^[1-9][1-9][1-9]0000000$/], # Ex: 111100000
    rubrica: [/^[1-9][1-9][1-9][1-9][1-9]0000$/], # Ex: 111120000,
    alinea: [/^[1-9][1-9][1-9][0-9][0-9][0-9][0-9]00$/], # Ex: 111120400,
    subalinea: [/^[1-9][1-9][1-9][0-9][0-9][0-9][0-9][0-9][0-9]$/] # Ex: 916001301, 111130260
  }

  has_one :consolidado, class_name: 'Integration::Supports::RevenueNature',
    primary_key: :codigo_consolidado,
    foreign_key: :codigo

  has_one :categoria_economica, class_name: 'Integration::Supports::RevenueNature',
    primary_key: :codigo_categoria_economica,
    foreign_key: :codigo

  has_one :origem, class_name: 'Integration::Supports::RevenueNature',
    primary_key: :codigo_origem,
    foreign_key: :codigo

  has_one :subfonte, class_name: 'Integration::Supports::RevenueNature',
    primary_key: :codigo_subfonte,
    foreign_key: :codigo

  has_one :rubrica, class_name: 'Integration::Supports::RevenueNature',
    primary_key: :codigo_rubrica,
    foreign_key: :codigo

  has_one :alinea, class_name: 'Integration::Supports::RevenueNature',
    primary_key: :codigo_alinea,
    foreign_key: :codigo

  has_one :subalinea, class_name: 'Integration::Supports::RevenueNature',
    primary_key: :codigo_subalinea,
    foreign_key: :codigo

  # Validations

  ## Presence

  validates :codigo,
    :descricao,
    :year,
    presence: true

  # Callbacks

  after_validation :set_revenue_nature_type,
    :set_codigos,
    :set_transfers,
    :set_full_title,
    :set_unique_ids

  # Public

  scope :revenues_by_type, -> (type, id) { where("#{type} = ?", id) }

  ## Instance methods

  ### Helpers

  def title
    descricao.present? ? descricao.strip : ''
  end

  def name
    title
  end

  def parent
    return @parent if @parent.present?

    parent_codigo = codigo.dup

    while (parent_codigo.present? && parent_codigo != EMPTY_PARENT_CODE)
      last_non_zero_index = parent_codigo.rindex(/[1-9]/)

      return nil if last_non_zero_index.nil?

      parent_codigo[last_non_zero_index] = '0'
      @parent = Integration::Supports::RevenueNature.find_by(codigo: parent_codigo)

      return @parent if @parent.present?
    end

    return nil
  end

  def set_revenue_nature_type

    self.revenue_nature_type = nil

    REVENUE_NATURE_TYPE_CODES.each do |revenue_nature_type, expression_array|
      expression_array.each do |expression|

        if codigo =~ expression
          self.revenue_nature_type = revenue_nature_type
          return
        end
      end
    end
  end

  def set_codigos

    if codigo.present? and codigo.size == 9
      set_codigo_for_nature_type(:subalinea, codigo[0..8])
      set_codigo_for_nature_type(:alinea, codigo[0..6] + '00')
      set_codigo_for_nature_type(:rubrica, codigo[0..4] + '0000')
      set_codigo_for_nature_type(:subfonte, codigo[0..3] + '00000')
      set_codigo_for_nature_type(:origem, codigo[0..2] + '000000')
      set_codigo_for_nature_type(:categoria_economica, codigo[0..1] + '0000000')
      set_codigo_for_nature_type(:consolidado, codigo[0] + '00000000')

      if codigo_rubrica == codigo_subfonte
        self.codigo_rubrica = codigo_alinea
      end

    elsif codigo.present? and codigo.size == 10
      set_codigo_for_nature_type(:subfonte, codigo[0..2] + '0000000')
      set_codigo_for_nature_type(:origem, codigo[0..1] + '00000000')
      set_codigo_for_nature_type(:categoria_economica, codigo[0] + '000000000')
    end
  end

  #
  # Seta o código das naturezas de receitas que foram 'acima' desta.
  # Ex: se esta for 'origem', deve setar 'origem, categoria_econimica e consolidado'
  #
  def set_codigo_for_nature_type(nature_type, value)

    current_revenue_nature_type_index = Integration::Supports::RevenueNature.revenue_nature_types[revenue_nature_type]

    if current_revenue_nature_type_index.present?

      revenue_nature_type_to_change = Integration::Supports::RevenueNature.revenue_nature_types[nature_type.to_s]

      revenue_nature_type_value = (current_revenue_nature_type_index >= revenue_nature_type_to_change ? value : nil)

      self.send("codigo_#{nature_type}=", revenue_nature_type_value)

    elsif value.size == 10
      self.send("codigo_#{nature_type}=", value)
    end
  end

  # Receitas consideradas 'Transferências Obrigatórias' ou 'Transferências Voluntárias'
  def set_transfers
    self.transfer_required = (codigo.present? && TRANSFER_CODES[:required].include?(codigo))
    self.transfer_voluntary = (codigo.present? && TRANSFER_CODES[:voluntary].include?(codigo))
  end

  def set_full_title
    if parent.present?
      self.full_title = "#{parent.full_title} > #{title}"
    else
      self.full_title = title
    end
  end

  def set_unique_ids
    #
    # Algumas naturezas de receitas tem o mesmo nome, e o mesmo 'caminho', fazendo
    # com que apareçam duplicadas tanto no filtro, quanto na árvore. Temos que
    # identificá-los unicamente, usando uma coluna auxiliar que cria um 'sha256' baseado
    # no fulltitle.
    #

    if codigo.present? && revenue_nature_type.present?
      set_unique_for_nature_type(:subalinea)
      set_unique_for_nature_type(:alinea)
      set_unique_for_nature_type(:rubrica)
      set_unique_for_nature_type(:subfonte)
      set_unique_for_nature_type(:origem)
      set_unique_for_nature_type(:categoria_economica)
      set_unique_for_nature_type(:consolidado)

      unique = Digest::SHA256.hexdigest(full_title)

      # Seta o código e o componente relacionado a essa receita
      self.send("unique_id_#{revenue_nature_type}=", unique)
      self.unique_id = unique
    else # 10 caracrteres 2019
      set_unique_for_nature_type(:subfonte)
      set_unique_for_nature_type(:origem)
      set_unique_for_nature_type(:categoria_economica)
    end
  end

  #
  # Seta o unique id para determinado componente da natureza de receita
  #
  def set_unique_for_nature_type(nature_type)
    component = self.send(nature_type)

    if component.present?
      self.send("unique_id_#{nature_type}=", Digest::SHA256.hexdigest(component.full_title))
    end
  end
end
