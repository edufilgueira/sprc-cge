#
# Classe responsável pela busca global relacionada ao model SearchContent.
#
class GlobalSearcher::SearchContentSearcher < GlobalSearcher::Base

  private

  def model_klass
    SearchContent
  end

  def search_result(result)
    {
      title: result.title,
      description: strip_tags(result.description)&.truncate(description_truncate_size),
      link: result.link
    }
  end

  def show_more_url
    search_contents_path(show_more_url_params)
  end
end
