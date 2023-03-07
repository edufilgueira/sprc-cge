require 'rails_helper'

describe Integration::Servers::ServerSalary::SpreadsheetPresenter do

  subject(:server_salary_spreadsheet_presenter) do
    Integration::Servers::ServerSalary::SpreadsheetPresenter.new(server_salary)
  end

  let(:server_salary) { create(:integration_servers_server_salary) }

  let(:klass) { Integration::Servers::ServerSalary }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:server_name),
      klass.human_attribute_name(:organ_sigla),
      klass.human_attribute_name(:role_name),
      klass.human_attribute_name(:functional_status_str),
      klass.human_attribute_name(:discount_total),
      klass.human_attribute_name(:discount_under_roof),
      klass.human_attribute_name(:discount_others),
      klass.human_attribute_name(:income_total),
      klass.human_attribute_name(:income_final),
      klass.human_attribute_name(:income_dailies)
    ]

    expect(Integration::Servers::ServerSalary::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      server_salary.server_name,
      server_salary.organ_sigla,
      server_salary.role_name,
      server_salary.functional_status_str,
      server_salary.discount_total,
      server_salary.discount_under_roof,
      server_salary.discount_others,
      server_salary.income_total,
      server_salary.income_final,
      server_salary.income_dailies
    ]

    result = server_salary_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
