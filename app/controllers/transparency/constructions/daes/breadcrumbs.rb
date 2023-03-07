module Transparency::Constructions::Daes::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.constructions.daes.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.constructions.daes.index.title"), transparency_constructions_daes_path],
      [dae.title, '']
    ]
  end
end

