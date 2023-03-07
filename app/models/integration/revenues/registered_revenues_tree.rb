#
# Representação em árvores de receitas lançadas
#
#

class Integration::Revenues::RegisteredRevenuesTree < Integration::Revenues::RevenuesTree

  NODES_TYPES = {
    month: Integration::Revenues::RegisteredRevenuesTreeNodes::Month,
    revenue: Integration::Revenues::RegisteredRevenuesTreeNodes::Revenue
  }

end
