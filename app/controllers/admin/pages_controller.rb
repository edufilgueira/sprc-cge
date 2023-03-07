class Admin::PagesController < Admin::BaseCrudController
  include ::Pages::BaseController
  include Admin::Pages::Breadcrumbs

  FIND_ACTIONS = FIND_ACTIONS + ['attachments']

  PERMITTED_PARAMS = [
    :title,
    :content,
    :status,
    :menu_title,
    :parent_id,

    :show_survey,

    attachments_attributes: [
      :id, :document, :title, :imported_at, :_destroy
    ],
    page_charts_attributes: [
      :id, :title, :unit, :_destroy,
      page_series_data_attributes: [
        :id, :title, :series_type, :_destroy,
        page_series_items_attributes: [
          :id, :title, :value, :_destroy
        ]
      ]
    ]
  ]

  SORT_COLUMNS = {
    title: 'page_translations.title'
  }

  before_action :load_title, only: :destroy

  private

  # XXX: Carrega o atributo 'title' para setar no flash do :destroy
  def load_title
    page.title
  end
end
