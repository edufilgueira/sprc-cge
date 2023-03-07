require 'rails_helper'

describe IntegrationConstructionsHelper do

  it 'integration_constructions_dae_status_for_select_with_all_option' do
    expected =
      Integration::Constructions::Dae.dae_statuses.keys.map do |status|
        [ I18n.t("integration/constructions/dae.dae_statuses.#{status}"), status ]
      end.insert(0, [t('messages.filters.select.all.male').upcase, ' '])

    expect(integration_constructions_dae_status_for_select_with_all_option).to eq(expected)
  end

  it 'integrations_constructions_dae_status_color' do
    expect(integrations_constructions_dae_status_color('canceled')).to eq ('badge-danger')
    expect(integrations_constructions_dae_status_color('done')).to eq ('badge-primary')
    expect(integrations_constructions_dae_status_color('finished')).to eq ('badge-primary')
    expect(integrations_constructions_dae_status_color('in_progress')).to eq ('badge-success')
    expect(integrations_constructions_dae_status_color('paused')).to eq ('badge-warning')
    expect(integrations_constructions_dae_status_color('waiting')).to eq ('badge-info')
  end

  it 'integration_constructions_der_status_for_select_with_all_option' do
    keys = Integration::Constructions::Der.der_statuses.keys - ['in_project', 'in_bidding', 'not_started', 'project_done']

    expected =
      keys.map do |status|
        [ I18n.t("integration/constructions/der.der_statuses.#{status}"), status ]
      end.insert(0, [t('messages.filters.select.all.male').upcase, ' '])

    expect(integration_constructions_der_status_for_select_with_all_option).to eq(expected)
  end

  it 'integrations_constructions_der_status_color' do
    expect(integrations_constructions_der_status_color('done')).to eq ('badge-primary')
    expect(integrations_constructions_der_status_color('canceled')).to eq ('badge-danger')
    expect(integrations_constructions_der_status_color('in_progress')).to eq ('badge-success')
    expect(integrations_constructions_der_status_color('project_done')).to eq ('badge-success')
    expect(integrations_constructions_der_status_color('not_started')).to eq ('badge-warning')
    expect(integrations_constructions_der_status_color('paused')).to eq ('badge-warning')
    expect(integrations_constructions_der_status_color('in_project')).to eq ('badge-info')
    expect(integrations_constructions_der_status_color('in_bidding')).to eq ('badge-info')
    expect(integrations_constructions_der_status_color('bid')).to eq ('badge-default')
  end

end
