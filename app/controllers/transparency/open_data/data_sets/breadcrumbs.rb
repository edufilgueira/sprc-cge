module Transparency::OpenData::DataSets::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.open_data.data_sets.index.title'), transparency_open_data_data_sets_path],
      [data_set.title, '']
    ]
  end
end
