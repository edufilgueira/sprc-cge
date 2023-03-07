#
# Classe responsável pela busca global relacionada ao model Ned.
#
class GlobalSearcher::NedSearcher < GlobalSearcher::Base

  private

  def model_klass
    Integration::Expenses::Ned
  end

  def base_results
    model_klass.from_executivo.ordinarias.search(search_term)
  end

  def search_result(result)
    {
      title: result.title,
      description: strip_tags(result.especificacao_geral)&.truncate(description_truncate_size),
      link: transparency_expenses_ned_path(result, locale_params)
    }
  end

  def show_more_url
    transparency_expenses_neds_path(show_more_url_params)
  end
end
