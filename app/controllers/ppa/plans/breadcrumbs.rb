module PPA::Plans::Breadcrumbs

  protected

  def show_edit_update_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('ppa.home.headline.title'), ppa_root_path],
      [t('ppa.plans.show.title', plan: plan.name), '']
    ]
  end
end
