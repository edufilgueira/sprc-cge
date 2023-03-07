module IntegrationConstructionsHelper

  def integrations_constructions_dae_status_color(status)
    case status
    when 'done', 'finished' then 'badge-primary'
    when 'canceled' then 'badge-danger'
    when 'in_progress' then 'badge-success'
    when 'paused' then 'badge-warning'
    when 'physical_progress_done' then 'badge-orange'
    when 'waiting' then 'badge-info'
    else 'badge-default'
    end
  end

  def integrations_constructions_der_status_color(status)
    case status
    when 'done' then 'badge-primary'
    when 'canceled' then 'badge-danger'
    when 'in_progress', 'project_done' then 'badge-success'
    when 'not_started', 'paused' then 'badge-warning'
    when 'in_project', 'in_bidding' then 'badge-info'
    else 'badge-default'
    end
  end

  def integration_constructions_dae_status_for_select_with_all_option
    integration_constructions_status_for_select_with_all_option('dae')
  end

  def integration_constructions_der_status_for_select_with_all_option
    integration_constructions_status_for_select_with_all_option('der')
  end

  private

  def integration_constructions_status_for_select_with_all_option(kind)
    send("integration_constructions_#{kind}_status_for_select").insert(0, [t('messages.filters.select.all.male').upcase, ' '])
  end

  def integration_constructions_dae_status_for_select
    integration_constructions_status_for_select('dae')
  end

  def integration_constructions_der_status_for_select
    integration_constructions_status_for_select('der')
  end

  def allowed_der_keys
    constructions_statuses_keys('der') - ['in_project', 'in_bidding', 'not_started', 'project_done']
  end

  def allowed_dae_keys
    constructions_statuses_keys('dae')
  end

  def integration_constructions_status_for_select(kind)
    send("allowed_#{kind}_keys").map do |status|
      [ I18n.t("integration/constructions/#{kind}.#{kind}_statuses.#{status}"), status ]
    end
  end

  def constructions_statuses_keys(kind)
    "Integration::Constructions::#{kind.classify}".constantize.send("#{kind}_statuses").keys
  end

end
