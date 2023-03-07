module IntegrationExpensesHelper

  def integration_expenses_cod_grupo_desp_for_select

    items = expense_group_items.map do |item|
      [Integration::Expenses::BudgetBalance.human_attribute_name("cod_grupo_desp.#{item}"), item]
    end.sort

    [[I18n.t('messages.filters.select.all.male'), ' ']] + items
  end

  private

  def expense_group_items
    #
    # Itens fixos gerados por um Integration::Expenses::BudgetBalance.pluck(:cod_grupo_desp).uniq
    #
    ['PES', 'MAN', 'PRI', 'FIN', 'TRA', 'SDD']
  end
end
