#
# Classe responsável pela busca global. Deve receber um grupo e um termo de busca
# e deve retornar a lista de resultados e um link de 'ver mais'.
#
class GlobalSearcher

  SEARCHS_GROUPS = {
    search_content: GlobalSearcher::SearchContentSearcher,
    page: GlobalSearcher::PageSearcher,
    server_salary: GlobalSearcher::ServerSalarySearcher,
    ned: GlobalSearcher::NedSearcher,
    contract: GlobalSearcher::ContractSearcher,
    convenant: GlobalSearcher::ConvenantSearcher,
    executive_ombudsman: GlobalSearcher::ExecutiveOmbudsmanSearcher,
    public_ticket: GlobalSearcher::PublicTicketSearcher
  }

  attr_reader :search_group, :search_term

  def self.call(search_group, search_term)
    new(search_group, search_term).call
  end

  def initialize(search_group, search_term)
    @search_group = search_group
    @search_term = search_term
  end

  def call
    searcher_class = SEARCHS_GROUPS[search_group.to_sym]
    searcher_class.call(search_term)
  end
end
