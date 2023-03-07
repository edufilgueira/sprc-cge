class Transparency::RevenuesExpensesController < TransparencyController
  include Transparency::BaseController
  include Transparency::RevenuesExpenses::Breadcrumbs

  def stats
    stats ||= create_or_update_stat
  end

  def stats_from_year
    stats
  end

  def last_stats
    stats
  end

  private


  def stats_yearly?
    true
  end

  def revenues_stats
    @revenues_stats ||= Stats::Revenues::Account.where(year: stats_year).last_stat
  end

  def expenses_stats
    @expenses_stats ||= Stats::Expenses::BudgetBalance.where(year: stats_year).last_stat
  end

  def create_or_update_stat
    return if revenues_stats.blank? || expenses_stats.blank?

    stat = Stats::RevenueExpense.find_or_initialize_by(year: stats_year, month: month)
    stat.data = build_revenues_expenses_data

    stat.save

    stat
  end

  def month
    expenses_stats.month_end || expenses_stats.month
  end

  def build_revenues_expenses_data
    {
      revenues_expenses: {
        "Receitas - Valor arrecadado"=>
        {
          total: revenues_stats.data[:total][:valor_arrecadado]
        },

       "Despesas - Valor empenhado"=>
        {
          total: expenses_stats.data[:total][:calculated_valor_empenhado]
        }
      }
    }
  end

  def transparency_id
    'revenues_expenses'
  end

  def stats_klass
    Stats::RevenueExpense
  end
end
