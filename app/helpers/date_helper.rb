module DateHelper

  def date_months_for_select
    Date::MONTHNAMES.compact.zip(1.upto(12)).map { |m| [I18n.t("date.months.#{m.first.downcase}"), m.second]}
  end

  #
  # month_start   :    integer  :   ex: 1
  # month_end     :    integer  :   ex: 12
  # year          :    integer  :   ex: 2018
  #
  # return        :    string   :   ex: "01/2018 - 12/2018"
  #
  def date_month_range_str(month_start, month_end, year)
    month_start_str = l(Date.parse("#{month_start}/#{year}"), format: :month_year)
    month_end_str = l(Date.parse("#{month_end}/#{year}"), format: :month_year)

    "#{month_start_str} - #{month_end_str}"
  end
end
