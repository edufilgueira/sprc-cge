module Transparency::Constructions::Ders::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.constructions.ders.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.constructions.ders.index.title"), transparency_constructions_ders_path],
      [der.title, '']
    ]
  end
end

