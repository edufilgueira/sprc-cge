require 'rails_helper'

describe Theme::Search do

  let!(:theme) { create(:theme) }

  it 'by name' do
    theme = create(:theme, name: 'Planajamento e gestão')
    theme_searched = Theme.search(theme.name)

    expect(theme_searched).to eq([theme])
  end

  it 'by code' do
    theme = create(:theme, code: '1.02')
    theme_searched = Theme.search(theme.code)

    expect(theme_searched).to eq([theme])
  end
end
