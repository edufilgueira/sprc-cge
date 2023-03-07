#
# Representa a estrutura do WS de listagem de diretrizes do PPA
#
class PPA::Source::Guideline < ApplicationDataRecord

  # Os valores de `descricao_referencia` encontrados na importação inicial:
  # - "Sem Período Concluído para o Ano"
  # - "Jan-Dez"
  # Então provavelmente serão, baseando-nos na fonte: (1:Jan-Mar/2:Jan-Jun/3:Jan-Set/4:Jan:Dez)
  # - "Sem Período Concluído para o Ano"
  # - "Jan-Mar"
  # - "Jan-Jun"
  # - "Jan-Set"
  # - "Jan-Dez"
  #
  # Ainda, se vier com "Sem Período Concluído para o Ano", os atributos de "valor" virão todos zerados!
  #
  REFERENCIA_BLANK_VALUES = ["Sem Período Concluído para o Ano", '', nil].freeze

  # Validations

  ## Presence

  validates_presence_of :codigo_regiao,
                        :codigo_ppa_objetivo_estrategico,
                        :codigo_ppa_estrategia,
                        :codigo_eixo,
                        :codigo_tema,
                        :ano
                        # podem não existir:
                        # --
                        # :codigo_ppa_iniciativa
                        # :codigo_produto


  ## Uniqueness

  validates :ano, uniqueness: {
    case_sensitive: false,
    scope: %i[
      codigo_regiao
      codigo_eixo
      codigo_tema
      codigo_ppa_objetivo_estrategico
      codigo_ppa_estrategia
      codigo_programa
      codigo_ppa_iniciativa
      codigo_acao
      codigo_produto
      descricao_referencia
    ]
  }

  scope :with_period,    -> { where.not descricao_referencia: REFERENCIA_BLANK_VALUES }
  scope :without_period, -> { where     descricao_referencia: REFERENCIA_BLANK_VALUES }

  class << self
    #
    # XXX Essa é a definição atual do webservice consumiro pelo PPA::Source::Guideline::Importer
    # @see https://github.com/caiena/sprc/issues/641
    # Resumindo:
    # - o parâmetro ano usado para consumo do webservice é persistido em Guideline#ano
    # - se Guideline#ano == 2017, então os dados do Guideline são relativos ao biênio [2016, 2017]
    # - se Guideline#ano == 2018, então os dados do Guideline são relativos ao biênio [2018, 2019]
    #
    def biennium_for(ano)
      case ano
      when 2017 then PPA::Biennium.new [2016, 2017]
      when 2018 then PPA::Biennium.new [2018, 2019]
      end
    end
  end


  def biennium
    @biennium ||= self.class.biennium_for ano
  end

end
