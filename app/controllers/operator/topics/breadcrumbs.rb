module Operator::Topics::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('operator.home.index.title'), operator_root_path],
      [t('.title'), '']
    ]
  end

  def new_create_breadcrumbs
    [
      [t('operator.home.index.title'), operator_root_path],
      [t('operator.topics.index.title'), operator_topics_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('operator.home.index.title'), operator_root_path],
      [t('operator.topics.index.title'), operator_topics_path],
      [topic.title, '']
    ]
  end

  def delete_destroy_breadcrumbs
    [
      [t('operator.home.index.title'), operator_root_path],
      [t('operator.topics.index.title'), operator_topics_path],
      [t('.title'), '']
    ]
  end
end
