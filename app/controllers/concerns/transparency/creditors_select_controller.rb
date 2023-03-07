#
# Módulo usado por controllers que possuem o filtro de Credor.
#
module Transparency::CreditorsSelectController

  def search_by_creditor_name(filtered)
    creditor_search = %Q{      
      unaccent(LOWER(#{creditors_name_column})) LIKE unaccent(LOWER(:search))
    }

    return filtered.where(creditor_search, search: like_search_term)
  end

  private

  def creditors_name_column
    resource_klass.creditors_name_column
  end

  def like_search_term    
    search_term = params[:search_datalist]
    cleared_search_term = search_term.to_s.gsub(/[^[:print:]]/,'%')
    
    "%#{cleared_search_term}%"
  end
end
