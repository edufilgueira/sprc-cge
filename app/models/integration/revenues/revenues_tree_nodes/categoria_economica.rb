#
# Representação dos nós na árvore de receitas para a visão 'categoria_economica'.
#
class Integration::Revenues::RevenuesTreeNodes::CategoriaEconomica < Integration::Revenues::RevenuesTreeNodes::RevenueNature

  private

  def revenue_nature_type
    :categoria_economica
  end
end
