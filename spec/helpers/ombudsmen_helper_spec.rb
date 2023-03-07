require 'rails_helper'

describe OmbudsmenHelper do

  it 'ombudsmen_kinds_for_select' do
    expected = Ombudsman.kinds.keys.map {|o| [I18n.t("ombudsman.kinds.#{o}"), o ]}

    expect(ombudsmen_kinds_for_select).to eq(expected)
  end
end
