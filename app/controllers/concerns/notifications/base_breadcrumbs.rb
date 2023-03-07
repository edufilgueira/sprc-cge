module ::Notifications::BaseBreadcrumbs

  protected

  def index_breadcrumbs
    [
      [t("app.home"), '/'],
      [t("shared.notifications.index.breadcrumb_title"), '']
    ]
  end


  def show_edit_update_breadcrumbs
    [
      [t("app.home"), '/'],
      [t("shared.notifications.index.breadcrumb_title"), url_for([namespace, :notifications, only_path: true])],
      [notification_show_title, '']
    ]
  end

  private

  def notification_show_title
    notification.subject.truncate(30)
  end
end

