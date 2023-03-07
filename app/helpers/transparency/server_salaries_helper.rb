module Transparency::ServerSalariesHelper

  CHART_TYPES = [:unique_count, :income_total]

  def transparency_server_salaries_options_for_select(server)
    columns = 'integration_servers_server_salaries.date, integration_servers_server_salaries.id'

    salaries_from_server = Integration::Servers::ServerSalary.from_server(server).select(columns).order(:date)

    grouped_by_month =  salaries_from_server.group_by{|server_salary| server_salary.date}

    grouped_by_month.map do |date, server_salaries_from_date|
      [
        I18n.l(date, format: :month_year_long),
        server_salaries_from_date.first.id
      ]
    end
  end

  def transparency_server_salaries_statuses_options_for_select
    Integration::Servers::Registration.functional_statuses.keys.map do |status|
      status_value = Integration::Servers::Registration.functional_statuses.keys.index(status)
      [I18n.t("integration/servers/registration.functional_statuses.#{status}"), status_value]
    end
  end

  def transparency_server_salaries_statuses_options_for_select_with_all_option
    transparency_server_salaries_statuses_options_for_select.insert(0, [I18n.t('integration/servers/registration.functional_statuses.all'), ' '])
  end

  def transparency_server_salaries_grouped_proceeds(proceeds)
    grouped = proceeds.group_by {|proceed| proceed.dsc_provento}

    Hash[ grouped.map do |dsc_provento, proceeds|
      [
        dsc_provento,
        proceeds.map(&:vlr_financeiro).inject(0, &:+)
      ]
    end ]
  end

  def chart_filtered_data(series_data, chart_type)
    series_data.reject{|key, value| value.blank? || value[chart_type].nil? || value[chart_type].zero?}
  end

  def chart_sorted_data(series_data, chart_type)
    chart_filtered_data(series_data, chart_type).sort_by do |k,data| 
      data[chart_type]
    end.reverse!
  end

  def chart_limited_data(series_data, chart_type)
    chart_sorted_data(series_data, chart_type).first(10).to_h
  end

  def chart_types 
    CHART_TYPES
  end

  def chart_series_data_values(series_data, chart_type)
    chart_limited_data(series_data, chart_type).values.map do |v| 
      send("server_salaries_data_value_for_#{chart_type}", v, chart_type)
    end
  end

  def server_salaries_data_value_for_income_total(v, chart_type)
    v[chart_type] - v[:discount_under_roof]
  end

  def server_salaries_data_value_for_unique_count(v, chart_type)
    v[chart_type]
  end

  def chart_series_data_keys(series_data, chart_type)
    chart_limited_data(series_data, chart_type).map{|k, v| v[:title].present? ? v[:title] : k}
  end
end
