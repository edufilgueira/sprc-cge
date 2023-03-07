module Operator::Notes::Breadcrumbs

  protected

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      [ t('.title'), '' ]
    ]
  end

  private

  def home_breadcrumb
    [ t('operator.home.index.title'), operator_root_path ]
  end
end
