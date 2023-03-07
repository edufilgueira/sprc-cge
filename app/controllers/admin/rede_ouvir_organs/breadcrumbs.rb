module Admin::RedeOuvirOrgans::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('.title'), '']
    ]
  end

  def new_create_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.rede_ouvir_organs.index.title'), admin_rede_ouvir_organs_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.rede_ouvir_organs.index.title'), admin_rede_ouvir_organs_path],
      [rede_ouvir_organ.title, '']
    ]
  end
end
