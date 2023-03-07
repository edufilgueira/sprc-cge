#
# Representação dos nós na árvore de receitas para a visão 'consolidado'.
#
# Consolidado representa as seguintes naturezas de receitas:
#
# 100000000, 800000000, 900000000,
#
class Integration::Revenues::RevenuesTreeNodes::Consolidado < Integration::Revenues::RevenuesTreeNodes::RevenueNature

  private

  def revenue_nature_type
    :consolidado
  end
end
