module Transparency::RealStates::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.real_states.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.real_states.index.title"), transparency_real_states_path],
      [real_state.title, '']
    ]
  end
end

