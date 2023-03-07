#
# Representação dos nós de meses da árvore de receitas lançadas.
#
class Integration::Revenues::RegisteredRevenuesTreeNodes::Month < Integration::Revenues::RegisteredRevenuesTreeNodes::Base

  def nodes
    result = []
    months_with_revenues.each do |month|
      result << {
        resource: month,
        id: month,
        type: :month,
        title: I18n.t("date.month_names")[month]
      }.merge(nodes_data(month))
    end

    result
  end

  private

  ## Meses

  def nodes_data(month)
    month_revenues = revenues_from_month(month)
    cumulated_month_revenues = cumulated_revenues_from_month(month)

    result = {
      valor_lancado: valor_lancado(month_revenues),
      valor_acumulado: valor_lancado(cumulated_month_revenues)
    }

    result
  end

  def months_with_revenues
    initial_scope.pluck('DISTINCT integration_revenues_revenues.month')
  end

  def revenues_from_month(month)
    initial_scope.where('integration_revenues_revenues.month = ?', month)
  end

  def cumulated_revenues_from_month(month)
    initial_scope.where('integration_revenues_revenues.month <= ?', month)
  end
end
