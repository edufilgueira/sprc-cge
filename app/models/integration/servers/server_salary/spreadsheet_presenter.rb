class Integration::Servers::ServerSalary::SpreadsheetPresenter

  COLUMNS = [
    :server_name,
    :organ_sigla,
    :role_name,
    :functional_status_str,
    :discount_total,
    :discount_under_roof,
    :discount_others,
    :income_total,
    :income_final,
    :income_dailies
  ]

  attr_reader :server_salary

  def initialize(server_salary)
    @server_salary = server_salary
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      server_salary.send(column)
    end
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::Servers::ServerSalary.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
