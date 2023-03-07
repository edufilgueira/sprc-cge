module ::MobileApps::BaseController
  extend ActiveSupport::Concern
  include ::PaginatedController
  include ::FilteredController


  included do

    helper_method [:mobile_apps]

    # Helper methods

    def mobile_apps
      paginated(filtered_mobile_apps)
    end

    # Private

    private

    def resource_klass
      MobileApp
    end

    def filtered_mobile_apps
      filtered(resource_klass, sorted_resources)
    end

    def sorted_resources
      resources.sorted
    end

  end
end
