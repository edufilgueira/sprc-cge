require 'rails_helper'

describe FormHelper do

  it 'yes_or_no_for_select' do
    expected = [
      [ I18n.t("boolean.true"), true ],
      [ I18n.t("boolean.false"), false ]
    ]

    expect(yes_or_no_for_select).to eq(expected)
  end

end
