class Admin::MobileTagsController < AdminController
  include Admin::MobileTags::Breadcrumbs
  include ::PaginatedController
  include ::FilteredController

  PER_PAGE = 20

  PERMITTED_PARAMS = [:name]

  helper_method [:mobile_tags, :mobile_tag]

  # Actions

  def create
    if resource.save
      redirect_to_index_with_success
    else
      set_error_flash_now_alert
      render :new
    end
  end

  def update
    if resource.update_attributes(resource_params)
      redirect_to_index_with_success
    else
      set_error_flash_now_alert
      render :edit
    end
  end

  # Helper methods

  def mobile_tags
    paginated_mobile_tags
  end

  def mobile_tag
    resource
  end

  # Private

  def paginated_mobile_tags
    paginated(filtered_mobile_tags)
  end

  def filtered_mobile_tags
    filtered(resource_klass, resources)
  end
end
