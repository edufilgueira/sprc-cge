require 'rails_helper'

describe Transparency::ServerSalariesHelper do

  let(:date) { Date.new(2017, 04) }
  let(:server_salary) { create(:integration_servers_server_salary, date: date) }
  let(:registration) { server_salary.registration }
  let(:server) { server_salary.server }

  it 'transparency_server_salaries_options_for_select' do
    first_date = Date.new(2017, 02)
    second_registration = create(:integration_servers_registration, server: server)
    second = create(:integration_servers_server_salary, date: first_date, registration: second_registration)

    another_date = Date.new(2017, 07)
    same_registration = create(:integration_servers_server_salary, date: another_date, registration: second_registration)

    another_registration = create(:integration_servers_registration)
    another_registration = create(:integration_servers_server_salary, date: first_date, registration: another_registration)

    expected = [
      [ I18n.l(first_date, format: :month_year_long), second.id ],
      [ I18n.l(date, format: :month_year_long), server_salary.id ],
      [ I18n.l(another_date, format: :month_year_long), same_registration.id ]
    ]

    result = transparency_server_salaries_options_for_select(server)

    expect(result).to eq(expected)
  end

  it 'transparency_server_salaries_options_for_select returns only first registration and unique month' do
    second_registration = create(:integration_servers_registration, server: server)
    second = create(:integration_servers_server_salary, date: date, registration: second_registration)

    expected = [
      [ I18n.l(date, format: :month_year_long), server_salary.id ]
    ]

    result = transparency_server_salaries_options_for_select(server)

    expect(result).to eq(expected)
  end

  context 'functional_statuses' do

    it 'transparency_server_salaries_statuses_options_for_select' do
      expected = Integration::Servers::Registration.functional_statuses.keys.map do |status|
        status_value = Integration::Servers::Registration.functional_statuses.keys.index(status)
        [I18n.t("integration/servers/registration.functional_statuses.#{status}"), status_value]
      end

      result = transparency_server_salaries_statuses_options_for_select

      expect(result).to eq(expected)
    end

    it 'transparency_server_salaries_statuses_options_for_select_with_all_option' do
      expected = expected = Integration::Servers::Registration.functional_statuses.keys.map do |status|
        status_value = Integration::Servers::Registration.functional_statuses.keys.index(status)
        [I18n.t("integration/servers/registration.functional_statuses.#{status}"), status_value]
      end

      expected.insert(0, [I18n.t('integration/servers/registration.functional_statuses.all'), ' '])

      result = transparency_server_salaries_statuses_options_for_select_with_all_option

      expect(result).to eq(expected)
    end
  end

  # Precisamos agrupar os proventos pelo tipo de provento pois pode haver mais
  # de um provento do mesmo tipo mas deve ser exibida a soma destes proventos.
  it 'transparency_server_salaries_grouped_proceeds' do
    proceed_type = create(:integration_servers_proceed_type)

    first_proceed = create(:integration_servers_proceed, cod_provento: proceed_type.cod_provento, vlr_financeiro: 1)
    second_proceed = create(:integration_servers_proceed, cod_provento: proceed_type.cod_provento, vlr_financeiro: 2)

    proceeds = [first_proceed, second_proceed]

    result = transparency_server_salaries_grouped_proceeds(proceeds)
    expected = {
      proceed_type.dsc_provento => proceeds.map(&:vlr_financeiro).inject(0, &:+)
    }

    expect(result).to eq(expected)
  end
end
