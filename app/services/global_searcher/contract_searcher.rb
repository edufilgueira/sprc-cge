#
# Classe responsável pela busca global relacionada ao model Contract.
#
class GlobalSearcher::ContractSearcher < GlobalSearcher::Base

  private

  def model_klass
    Integration::Contracts::Contract
  end

  def search_result(result)
    {
      title: result.title,
      description: strip_tags(result.descricao_objeto)&.truncate(description_truncate_size),
      link: transparency_contracts_contract_path(result, locale_params)
    }
  end

  def show_more_url
    transparency_contracts_contracts_path(show_more_url_params)
  end
end
