#
# Representação em árvores de receitas
#
# De acordo com a documentação enviada, a soma deve ser feita da seguinte
# forma:
# natureza_conta = 'DÉBITO    ' e codigo = '9' faça (valor_credito - valor_debito) * -1
# natureza_conta = 'DÉBITO    ' e codigo = '8' faça (valor_credito - valor_debito) * -1
# natureza_conta = 'DÉBITO    ' e codigo = '1' faça  valor_debito - valor_credito
# natureza_conta = 'CRÉDITO   ' e codigo = '9' faça (valor_debito - valor_credito) * -1
# natureza_conta = 'CRÉDITO   ' e codigo = '8' faça (valor_debito - valor_credito) * -1
# natureza_conta = 'CRÉDITO   ' e codigo = '1' faça valor_credito - valor_debito
#
# OBS: Não temos essa coluna 'código'.
#
# 5211 – Previsão de Receita
# 52121 – Previsão de Receita Adicional
# 52129 – Anulação de Previsão de Receita
# 6212 – Receita Corrente
# 6213 – Deduções da Receita
#
# Valor Previsto = 5211
# Valor Atualizado = (5211 + 52121) – 52129
# Valor Arrecadado = 6212 - 6213
#

class Integration::Revenues::RevenuesTree

  DEFAULT_NODES_TYPES = {
    secretary: Integration::Revenues::RevenuesTreeNodes::Secretary,
    organ: Integration::Revenues::RevenuesTreeNodes::Organ,
    consolidado: Integration::Revenues::RevenuesTreeNodes::Consolidado,
    categoria_economica: Integration::Revenues::RevenuesTreeNodes::CategoriaEconomica,
    origem: Integration::Revenues::RevenuesTreeNodes::Origem,
    subfonte: Integration::Revenues::RevenuesTreeNodes::Subfonte,
    rubrica: Integration::Revenues::RevenuesTreeNodes::Rubrica,
    alinea: Integration::Revenues::RevenuesTreeNodes::Alinea,
    subalinea: Integration::Revenues::RevenuesTreeNodes::Subalinea
  }

  NODES_2019 = {
    secretary: Integration::Revenues::RevenuesTreeNodes::Secretary,
    organ: Integration::Revenues::RevenuesTreeNodes::Organ,
    categoria_economica: Integration::Revenues::RevenuesTreeNodes::CategoriaEconomica,
    origem: Integration::Revenues::RevenuesTreeNodes::Origem,
    subfonte: Integration::Revenues::RevenuesTreeNodes::Subfonte,
  }

  NODES_TYPES = {
    2013 => DEFAULT_NODES_TYPES,
    2014 => DEFAULT_NODES_TYPES,
    2015 => DEFAULT_NODES_TYPES,
    2016 => DEFAULT_NODES_TYPES,
    2017 => DEFAULT_NODES_TYPES,
    2018 => DEFAULT_NODES_TYPES,
    2019 => NODES_2019,
    2020 => NODES_2019,
  }

  attr_reader :initial_scope, :parent_node_path

  def initialize(initial_scope, parent_node_path = nil)
    @initial_scope = initial_scope
    @parent_node_path = parent_node_path
  end

  def nodes(nodes_type, year=2018)
    nodes_class =
      if self.class::NODES_TYPES.keys.include? nodes_type
        # Caso NODES_TYPES seja herdado de outra classe como a registered_revenues_tree
        self.class::NODES_TYPES.with_indifferent_access[nodes_type]
      elsif self.class::NODES_TYPES[year].present?
        # Para atender o ano dinamicamente seria necessário passar o parametro
        # do ano. Para não trazer impacto ao sistema esta sendo usado a
        # classificação que vigorou até 2018 também na competência de 2019
        # Nao sei pq está fixo 2018. Na receita do executivo ele descobre sozinho qual o ano

        self.class::NODES_TYPES[year].with_indifferent_access[nodes_type]
      end

    return [] if nodes_class.blank?

    nodes_class.new(initial_scope, parent_node_path).nodes
  end
end
