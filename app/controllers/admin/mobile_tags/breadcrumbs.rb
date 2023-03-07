module Admin::MobileTags::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      bradcrumb_home,
      [t('.title'), '']
    ]
  end

  def new_create_breadcrumbs
    [
      bradcrumb_home,
      bradcrumb_index,
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      bradcrumb_home,
      bradcrumb_index,
      [mobile_tag.title, '']
    ]
  end

  private

  def bradcrumb_home
    [t('admin.home.index.title'), admin_root_path]
  end

  def bradcrumb_index
    [t('admin.mobile_tags.index.title'), admin_mobile_tags_path]
  end
end
