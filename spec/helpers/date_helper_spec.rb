require 'rails_helper'

describe DateHelper do

  it 'date_months_for_select' do
    expected = Date::MONTHNAMES.compact.zip(1.upto(12)).map { |m| [I18n.t("date.months.#{m.first.downcase}"), m.second]}

    expect(date_months_for_select).to eq(expected)
  end

  it 'date_month_range_str' do
    expected = '01/2018 - 12/2018'

    expect(date_month_range_str(1, 12, 2018)).to eq(expected)
  end
end
