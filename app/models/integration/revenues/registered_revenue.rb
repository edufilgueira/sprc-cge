# RegisteredRevenue é um tipo de Revenue mas para 'Receitas Lançadas'

class Integration::Revenues::RegisteredRevenue < Integration::Revenues::Revenue

  # Scope

  default_scope do
    where(account_type: :receitas_lancadas)
  end
end
