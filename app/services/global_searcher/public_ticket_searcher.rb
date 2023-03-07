#
# Classe responsável pela busca global relacionada ao model Ticket (públicos).
#
class GlobalSearcher::PublicTicketSearcher < GlobalSearcher::Base
  include OrgansHelper

  private

  def model_klass
    Ticket
  end

  def base_results
    model_klass.public_tickets.from_type(:sic).search(search_term)
  end

  def search_result(result)
    title = "#{result.parent_protocol} - #{acronym_organs_list(result)} - (#{result.internal_status_str})"
    {
      title: title,
      description: strip_tags(result.description)&.truncate(description_truncate_size),
      link: transparency_public_ticket_path(result, locale_params)
    }
  end

  def show_more_url
    transparency_public_tickets_path(show_more_url_params)
  end
end
