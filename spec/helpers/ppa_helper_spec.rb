require 'rails_helper'

describe PPAHelper do

	before {
		5.times { create(:ppa_axis) }
		5.times { create(:ppa_theme) }
	}

	it 'axes_for_select' do
    expect(axes_for_select).to eq(PPA::Axis.where(plan_id: plan_id).pluck(:name, :id))
	end

  it 'themes_for_select' do
    expect(themes_for_select).to eq(Theme.enabled.sorted.pluck(:name, :id))
  end

end