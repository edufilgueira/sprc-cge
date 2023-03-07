module ::Pages::BaseController
  extend ActiveSupport::Concern

  included do
    helper_method [ :pages, :page, :page_attachments ]

    # Actions

    def attachments
      render partial: 'attachments', layout: false
    end

    # Helper methods

    def pages
      paginated_resources
    end

    def page
      resource
    end

    def page_attachments
      
      return sorted_attachments unless param_year.present? || param_title.present?

      attachments_by_params
    end

    # Private

    private

    def resource_klass
      Page
    end

    def sorted_attachments
      page.attachments.join_attachment_detail.sorted
        .where(page_attachment_translations: { locale: locale })
    end

    def attachments_by_params
      result = sorted_attachments

      result = result.by_year(param_year) if param_year.present?
      result = result.by_title(param_title) if param_title.present?
      result
    end

    def param_year
      params[:year]
    end

    def param_title
      params[:title]
    end
  end
end