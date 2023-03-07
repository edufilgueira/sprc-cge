module Transparency::Sou::Ombudsmen::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('transparency.sou.home.index.title'), transparency_sou_path],
      [t("transparency.sou.#{resource_symbol.to_s.pluralize}.index.title"), '']
    ]
  end
end
