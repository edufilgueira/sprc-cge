module PagesHelper

  def scoped_parents_menu_title_for_select(page)
    scoped_parents(page).map { |p| [ p.menu_title, p.id ] }
  end

  def scoped_parents(page)
    Page.sorted_parents.where.not(id: page.id)
  end

  def page_status_for_select
    [
      [ I18n.t("boolean.true"), :active ],
      [ I18n.t("boolean.false"), :inactive ]
    ]
  end

  def series_type_for_select
    series_types.map do |key|
      [series_type_name(key), key]
    end
  end

  def page_attachments_years_for_select(page)
    sorted_attachments(page).map(&:imported_at_year).uniq
  end

  def style_for_big_display
    return if try(:page).nil? or page.nil? or !page.big_display
    content_for :stylesheet, stylesheet_link_tag(stylesheet_big_display)
  end

  private

  def stylesheet_big_display
    'views/big_display'
  end

  def series_types
    Page::SeriesDatum.series_types.keys
  end

  def series_type_name(key)
    Page::SeriesDatum.human_attribute_name("series_type.#{key}")
  end

  def sorted_attachments(page)
    page.attachments.order(imported_at: :desc)
  end

  def is_page_controller?
    controller.class == Transparency::PagesController
  end
end
