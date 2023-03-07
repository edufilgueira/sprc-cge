#
# Classe responsável pela busca global relacionada ao model Page (CMS).
#
class GlobalSearcher::PageSearcher < GlobalSearcher::Base

  private

  def model_klass
    Page
  end

  def search_result(result)
    {
      title: result.title,
      description: strip_tags(result.content)&.truncate(description_truncate_size),
      link: transparency_page_path(result, locale_params)
    }
  end

  def show_more_url
    transparency_pages_path(show_more_url_params)
  end
end
