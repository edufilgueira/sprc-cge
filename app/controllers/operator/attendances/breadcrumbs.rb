module Operator::Attendances::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [ t('operator.home.index.title'), operator_root_path ],
      [ t("operator.attendances.index.title"), '' ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [ t('operator.home.index.title'), operator_root_path ],
      [ t("operator.attendances.index.title"), operator_attendances_path ],
      [ t("operator.attendances.show.title", protocol: attendance.protocol), '']
    ]
  end

end
