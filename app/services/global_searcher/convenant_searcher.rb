#
# Classe responsável pela busca global relacionada ao model Convenant.
#
class GlobalSearcher::ConvenantSearcher < GlobalSearcher::ContractSearcher

  private

  def model_klass
    Integration::Contracts::Convenant
  end

  def search_result(result)
    {
      title: result.title,
      description: strip_tags(result.descricao_objeto)&.truncate(description_truncate_size),
      link: transparency_contracts_convenant_path(result, locale_params)
    }
  end

  def show_more_url
    transparency_contracts_convenants_path(show_more_url_params)
  end
end
