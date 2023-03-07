# Transfer é um tipo de Account que possua natureza da receita com transfer_required
# transfer_voluntary.

class Integration::Revenues::Transfer < Integration::Revenues::Account

  # Scope

  default_scope do
    joins(:revenue_nature).where(%q{
      integration_supports_revenue_natures.transfer_voluntary = ? OR
      integration_supports_revenue_natures.transfer_required = ?
    }, true, true)
  end

end
