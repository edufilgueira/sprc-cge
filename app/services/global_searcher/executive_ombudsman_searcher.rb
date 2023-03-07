#
# Classe responsável pela busca global relacionada ao model ExecutiveOmbudsman.
#
class GlobalSearcher::ExecutiveOmbudsmanSearcher < GlobalSearcher::Base

  private

  def model_klass
    ExecutiveOmbudsman
  end

  def search_result(result)
    {
      title: result.title,
      description: description_data(result),
      link: search_result_link(result)
    }
  end

  def show_more_url
    transparency_sou_executive_ombudsmen_path(show_more_url_params)
  end

  # A página de ouvidorias não tem show. Mandamos o usuário para a index com
  # a busca contendo o nome todo da ouvidoria.

  def search_result_link(result)
    params = { search: result.title }.merge(locale_params)

    transparency_sou_executive_ombudsmen_path(params)
  end

  # Os resultados de busca de ouvidoria são mais elaborados pois contém várias
  # informações como descrição da busca
  #
  def description_data(result)
    {
      contact_name: result.contact_name,
      phone: result.phone,
      email: result.email,
      address: result.address,
      operating_hours: result.operating_hours
    }
  end
end
