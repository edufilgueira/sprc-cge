require 'rails_helper'

describe Holiday::Search do

  let!(:holiday) { create(:holiday) }

  it 'by title' do
    holiday = create(:holiday, title: 'Proclamação da república')
    holidays = Holiday.search(holiday.title)

    expect(holidays).to eq([holiday])
  end

  it 'by day' do
    holiday = create(:holiday, day: '15')
    holidays = Holiday.search(holiday.day)

    expect(holidays).to eq([holiday])
  end

  it 'by month' do
    holiday = create(:holiday, month: '11')
    holidays = Holiday.search(holiday.month)

    expect(holidays).to eq([holiday])
  end
end
