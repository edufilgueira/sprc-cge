require 'rails_helper'

describe PPA::Themes::RegionalStrategies::RegionalInitiativesController, type: :controller do
  let(:biennium)   { PPA::Biennium.new '2010-2011' }
  let(:region)     { create :ppa_region }
  let!(:axis)      { create :ppa_axis }
  let(:theme)      { create :ppa_theme,      axis: axis }
  let(:objective)  { create :ppa_objective,  themes: [theme] }
  let(:strategy)   { create :ppa_strategy,   objective: objective }
  let(:initiative) { create :ppa_initiative, strategies: [strategy] }
  let(:regional_strategy) do
    create :ppa_biennial_regional_strategy, biennium: biennium, region: region, strategy: strategy
  end
  let(:regional_initiative) do
    create :ppa_biennial_regional_initiative, biennium: biennium, region: region, initiative: initiative
  end


  context 'show' do
    before do
      get :show,
        params: { biennium: biennium,
                  region_code: region.code,
                  theme_id: theme.id,
                  regional_strategy_id: regional_strategy.id,
                  id: regional_initiative.id }
    end

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.breadcrumbs.home.show.title'), url: ppa_root_path },
        {
          title: I18n.t('ppa.breadcrumbs.region_with_biennium', biennium: biennium, region: region.name),
          url: ppa_scoped_axes_path(biennium, region.code)
        },
        { title: axis.name, url: ppa_scoped_axes_path(biennium, region.code) },
        { title: theme.name, url: ppa_scoped_theme_regional_strategies_path(biennium, region.code, theme) },
        { title: regional_strategy.strategy_name, url: ppa_scoped_theme_regional_strategy_path(biennium, region.code, theme, regional_strategy) },
        { title: regional_initiative.name, url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
