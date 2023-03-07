#
# Representação dos nós de secretarias na árvore de receitas.
#
class Integration::Revenues::RegisteredRevenuesTreeNodes::Revenue < Integration::Revenues::RegisteredRevenuesTreeNodes::Base

  def nodes
    result = []

    conta_contabils_with_revenues.each do |conta_contabil_info|
      conta_contabil = conta_contabil_info[0]
      conta_contabil_title = conta_contabil_info[1]

      result << {
        resource: conta_contabil,
        id: conta_contabil,
        type: :revenue,
        title: conta_contabil_title
      }.merge(nodes_data(conta_contabil))
    end

    result.sort_by{|node| ACCOUNTS.values.flatten.index(node[:id])}
  end

  private

  ## Meses

  def nodes_data(conta_contabil)
    revenues = revenues_from_conta_contabil(conta_contabil)
    cumulated_revenues_from_conta_contabil = cumulated_revenues_from_conta_contabil(conta_contabil)

    result = {
      valor_lancado: valor_lancado(revenues),
      valor_acumulado: valor_lancado(cumulated_revenues_from_conta_contabil)
    }

    result
  end

  def conta_contabils_with_revenues
    initial_scope.where('integration_revenues_revenues.conta_contabil IN (?)', ACCOUNTS.values.flatten).pluck('DISTINCT integration_revenues_revenues.conta_contabil, integration_revenues_revenues.titulo')
  end

  def revenues_from_conta_contabil(conta_contabil)
    from_conta_contabil(conta_contabil).where('integration_revenues_revenues.month = ?', month)
  end

  def cumulated_revenues_from_conta_contabil(conta_contabil)
    from_conta_contabil(conta_contabil).where('integration_revenues_revenues.month <= ?', month)
  end

  def from_conta_contabil(conta_contabil)
    initial_scope.where('integration_revenues_revenues.conta_contabil = ?', conta_contabil)
  end

  def month
    @month ||= parent_node_path.split('/').last
  end
end
