module SiteMapHelper

  def site_map_transparency_default
    [
      { title: I18n.t("home.site_map.transparency.default.access"), link: transparency_root_path },
      { title: I18n.t("home.site_map.transparency.default.what_is"), link: transparency_root_path(anchor: 'o-que-e') },
      { title: I18n.t("home.site_map.transparency.default.map"), link: transparency_root_path(anchor: 'mapas-iterativos') },
      { title: I18n.t("home.site_map.transparency.default.news"), link: transparency_root_path(anchor: 'noticias') },
      { title: I18n.t("home.site_map.transparency.default.society_mobile_apps"), link: transparency_society_mobile_apps_path },
      { title: I18n.t("home.site_map.transparency.default.whats_new"), link: transparency_page_path('novidades-no-portal') }
    ]
  end

  def site_map_transparency_news_sections
    [
      { title: I18n.t("home.site_map.transparency.news_sections.cge"), link: "http://www.cge.ce.gov.br/category/noticias/lista-de-noticias/" },
      { title: I18n.t("home.site_map.transparency.news_sections.gov"), link: "http://www.ceara.gov.br/home-2-2-3/todas-as-noticias/" }
    ]
  end

  def site_map_transparency_revenues
    [
      { title: I18n.t("home.site_map.transparency.revenues.accounts"), link: transparency_revenues_accounts_path },
      { title: I18n.t("home.site_map.transparency.revenues.registered"), link: transparency_revenues_registered_revenues_path },
      { title: I18n.t("home.site_map.transparency.revenues.transfers"), link: transparency_revenues_transfers_path },
      { title: I18n.t("home.site_map.transparency.revenues.expenses"), link: transparency_revenues_expenses_path }
    ]
  end

  def site_map_transparency_expenses
    [
      { title: I18n.t("home.site_map.transparency.expenses.budget_balances"), link: transparency_expenses_budget_balances_path },
      { title: I18n.t("home.site_map.transparency.expenses.neds"), link: transparency_expenses_neds_path },
      { title: I18n.t("home.site_map.transparency.expenses.dailies"), link: transparency_expenses_dailies_path },
      { title: I18n.t("home.site_map.transparency.expenses.fund_supplies"), link: transparency_expenses_fund_supplies_path },
      { title: I18n.t("home.site_map.transparency.expenses.server_salaries"), link: transparency_server_salaries_path },
      { title: I18n.t("home.site_map.transparency.expenses.corporate_card"), link: transparency_page_path('cartao-corporativo') },
      { title: I18n.t("home.site_map.transparency.expenses.city_undertakings"), link: transparency_city_undertakings_path },
      { title: I18n.t("home.site_map.transparency.expenses.macroregion_investiments"), link: transparency_macroregion_investiments_path },
      { title: I18n.t("home.site_map.transparency.expenses.contracts"), link: transparency_contracts_contracts_path },
      { title: I18n.t("home.site_map.transparency.expenses.management_contracts"), link: transparency_contracts_management_contracts_path },
      { title: I18n.t("home.site_map.transparency.expenses.convenants"), link: transparency_contracts_convenants_path },
      { title: I18n.t("home.site_map.transparency.expenses.purchases_finalized"), link: transparency_purchases_path },
      { title: I18n.t("home.site_map.transparency.expenses.purchases"), link: transparency_page_path('licitacoes') },
      { title: I18n.t("home.site_map.transparency.expenses.constructions_daes"), link: transparency_constructions_daes_path },
      { title: I18n.t("home.site_map.transparency.expenses.constructions_ders"), link: transparency_constructions_ders_path },
      { title: I18n.t("home.site_map.transparency.expenses.non_profit_transfers"), link: transparency_expenses_non_profit_transfers_path },
      { title: I18n.t("home.site_map.transparency.expenses.profit_transfers"), link: transparency_expenses_profit_transfers_path },
      { title: I18n.t("home.site_map.transparency.expenses.multi_gov_transfers"), link: transparency_expenses_multi_gov_transfers_path },
      { title: I18n.t("home.site_map.transparency.expenses.consortium_transfers"), link: transparency_expenses_consortium_transfers_path },
      { title: I18n.t("home.site_map.transparency.expenses.city_transfers"), link: transparency_expenses_city_transfers_path },
      { title: I18n.t("home.site_map.transparency.expenses.required_city_transfers"), link: transparency_page_path('cotransferencias-obrigatorias-aos-municipios') }
    ]
  end

  def site_map_transparency_management
    [
      { title: I18n.t("home.site_map.transparency.management.revenue_liquid"), link: transparency_page_path('receita-corrente-liquida') },
        { title: I18n.t("home.site_map.transparency.management.report_fiscal_management"), link: transparency_page_path('fiscal-management-report') },
        { title: I18n.t("home.site_map.transparency.management.report_summary_budget_execution"), link: transparency_page_path('relatorio-resumido-da-execucao-orcamentaria') },
        { title: I18n.t("home.site_map.transparency.management.budget_laws"), link: transparency_page_path('leis-orcamentarias') },
        { title: I18n.t("home.site_map.transparency.management.report_internal_control"), link: transparency_page_path('relatorio-controle-interno') },
        { title: I18n.t("home.site_map.transparency.management.report_external_control"), link: transparency_page_path('relatorio-controle-externo') },
        { title: I18n.t("home.site_map.transparency.management.general_balance_state"), link: transparency_page_path('balanco-geral-do-estado') },
        { title: I18n.t("home.site_map.transparency.management.real_estate"), link: transparency_real_states_path },
        { title: I18n.t("home.site_map.transparency.management.official_state_newspaper"), link: "http://pesquisa.doe.seplag.ce.gov.br/doepesquisa/sead.do?page=ultimasEdicoes&cmd=11&action=Ultimas" },
        { title: I18n.t("home.site_map.transparency.management.social_control_tool"), link: transparency_page_path('ferramentas-de-controle-social') },
        { title: I18n.t("home.site_map.transparency.management.management_result"), link: transparency_page_path('gestao-por-resultados') },
        { title: I18n.t("home.site_map.transparency.management.fiscal_indicators"), link: transparency_page_path('indicadores-fiscais') },
        { title: I18n.t("home.site_map.transparency.management.investment_opportunity"), link: transparency_page_path('o-estado-do-ceara') },
        { title: I18n.t("home.site_map.transparency.management.government_policy"), link: transparency_page_path('prioridades-e-politicas-de-governo') },
        { title: I18n.t("home.site_map.transparency.management.radar"), link: transparency_page_path('radar') },
        { title: I18n.t("home.site_map.transparency.management.socioeconomic_information"), link: transparency_page_path('informacoes-socioeconomicas') },
        { title: I18n.t("home.site_map.transparency.management.result_indicators"), link: transparency_page_path('resultados') },
        { title: I18n.t("home.site_map.transparency.management.preventive_internal_control"), link: transparency_page_path('controle-interno-preventivo') },
        { title: I18n.t("home.site_map.transparency.management.governance_models"), link: transparency_page_path('modelo-de-governanca') },
        { title: I18n.t("home.site_map.transparency.management.organizational_structure"), link: transparency_page_path('estrutura-organizacional') },
        { title: I18n.t("home.site_map.transparency.management.address_phone"), link: transparency_page_path('enderecos-e-telefones') },
        { title: I18n.t("home.site_map.transparency.management.participative_management"), link: transparency_page_path('participative-management') },
        { title: I18n.t("home.site_map.transparency.management.cogerf"), link: transparency_page_path('comite-de-gestao-por-resultados-e-gestao-fiscal-cogerf') },
        { title: I18n.t("home.site_map.transparency.management.pib"), link: transparency_page_path('pib') }
    ]
  end

  def site_map_transparency_maps
    [
      { title: I18n.t("home.site_map.transparency.maps.constructions_daes"), link: transparency_constructions_daes_path },
      { title: I18n.t("home.site_map.transparency.maps.constructions_ders"), link: transparency_constructions_ders_path },
      { title: I18n.t("home.site_map.transparency.maps.hydrological_portal"), link: "http://www.hidro.ce.gov.br/" },
      { title: I18n.t("home.site_map.transparency.maps.srh"), link: "http://atlas.srh.ce.gov.br/" }
    ]
  end

  def site_map_sou_default
    [
      { title: I18n.t("home.site_map.sou.default.access"), link: transparency_sou_path },
      { title: I18n.t("home.site_map.sou.default.what_is"), link: transparency_page_path('ouvidoria') },
      { title: I18n.t("home.site_map.sou.default.new"), link: new_user_session_path(ticket_type: :sou) },
      { title: I18n.t("home.site_map.sou.default.login"), link: ticket_area_root_path },
      { title: I18n.t("home.site_map.sou.default.how_use"), link: transparency_page_path('ouvidoria') },
      { title: I18n.t("home.site_map.sou.default.service_channels"), link: transparency_contacts_path },
      { title: I18n.t("home.site_map.sou.default.executive_ombudsmen"), link: transparency_sou_executive_ombudsmen_path },
      { title: I18n.t("home.site_map.sou.default.organs_ce"), link: transparency_page_path('redes-de-ouvidorias', anchor: 'redeouvir') },
      { title: I18n.t("home.site_map.sou.default.organs_strengthening_program"), link: transparency_page_path('redes-de-ouvidorias', anchor: 'profort') },
      { title: I18n.t("home.site_map.sou.default.statistics"), link: transparency_public_tickets_path },
      { title: I18n.t("home.site_map.sou.default.report_management"), link: transparency_page_path('relatorios-de-gestao-de-ouvidoria') },
      { title: I18n.t("home.site_map.sou.default.legislation"), link: transparency_page_path('legislacao-sobre-ouvidoria') },
      { title: I18n.t("home.site_map.sou.default.articles"), link: transparency_page_path('diagnostico-das-manifestacoes-da-ouvidoria-da-secretaria-do-trabalho-e-desenvolvimento-social-do-estado-do-ceara-stds-com-foco-na-resolubilidade') },
      { title: I18n.t("home.site_map.sou.default.next_events"), link: transparency_events_path }
    ]
  end

  def site_map_sic_default
    [
      { title: I18n.t("home.site_map.sic.default.access"), link: transparency_sic_path },
        { title: I18n.t("home.site_map.sic.default.new"), link: new_user_session_path(ticket_type: :sic) },
        { title: I18n.t("home.site_map.sic.default.login"), link: ticket_area_root_path },
        { title: I18n.t("home.site_map.sic.default.public_sic"), link: transparency_public_tickets_path(ticket_type: :sic) },
        { title: I18n.t("home.site_map.sic.default.what_is"), link: transparency_page_path('acesso-a-informacao') },
        { title: I18n.t("home.site_map.sic.default.how_use"), link: transparency_page_path('acesso-a-informacao') },
        { title: I18n.t("home.site_map.sic.default.report_management"), link: transparency_page_path('relatorios-de-gestao-da-transparencia') },
        { title: I18n.t("home.site_map.sic.default.legislation"), link: transparency_page_path('legislacao-sobre-acesso-a-informacao') },
        { title: I18n.t("home.site_map.sic.default.report_statistics"), link: transparency_page_path('relatorios-estatisticos-de-acesso-a-informacao') },
        { title: I18n.t("home.site_map.sic.default.statistics"), link: transparency_public_tickets_path }
    ]
  end

  def site_map_sic_sensitive_information
    [
      { title: I18n.t("home.site_map.sic.sensitive_information.information_classification"), link: transparency_page_path('rol-de-documentos-classificados-com-grau-de-sigilo-e-o-rol-de-documentos-desclassificados-dos-orgaos-e-entidades-do-poder-executivo-estadual') },
      { title: I18n.t("home.site_map.sic.sensitive_information.cgai"), link: transparency_page_path('portaria-cgai-n-01-2016') }
    ]
  end

  def site_map_services_default
    [
      { title: I18n.t("home.site_map.services.default.service_letter"), link: "https://cartadeservicos.ce.gov.br/" },
      { title: I18n.t("home.site_map.services.default.mobile_apps"), link: transparency_mobile_apps_path },
      { title: I18n.t("home.site_map.services.default.electronic_services"), link: transparency_page_path('servicos-publicos') }
    ]
  end
end
