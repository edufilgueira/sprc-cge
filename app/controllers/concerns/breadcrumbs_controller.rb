module BreadcrumbsController
  extend ActiveSupport::Concern

  def breadcrumbs
    @breadcrumbs ||= breadcrumbs_for(action_name)
  end

  def actions_breadcrumbs
    {
      'index': index_breadcrumbs,

      'new': new_create_breadcrumbs,

      'create': new_create_breadcrumbs,

      'show': show_edit_update_breadcrumbs,

      'edit': show_edit_update_breadcrumbs,

      'update': show_edit_update_breadcrumbs,

      'delete': delete_destroy_breadcrumbs,

      'destroy': delete_destroy_breadcrumbs
    }
  end

  # métodos que devem ser sobrescritos por cada breadcrumb específico

  protected

  def index_breadcrumbs
  end

  def new_create_breadcrumbs
  end

  def show_edit_update_breadcrumbs
  end

  def delete_destroy_breadcrumbs
  end

  private

  def breadcrumbs_for(action_name)
    return [] unless has_breadcrumbs?(action_name)

    actions_breadcrumbs[action_name.to_sym].map do |breadcrumb|
      breadcrumb_item(breadcrumb[0], breadcrumb[1])
    end
  end

  def breadcrumb_item(title, url)
    { title: title, url: url}
  end

  def has_breadcrumbs?(action_name)
    ! actions_breadcrumbs[action_name.to_sym].nil?
  end
end
