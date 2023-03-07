# RESTful API pública de Cargos (Integration::Supports::ServerRole)
#
# 1) INDEX
#    GET /api/v1/integration/support/revenues_natures
#    HTTP 200 - [ { role }, { role }, ... ]
#
class Api::V1::Integration::Supports::RevenueNatures::RevenueTypesController < Api::V1::ApplicationController

  def index
    object_response(revenue_types)
  end

  def revenue_types
    filtered_revenue_types
  end

  def filtered_revenue_types
    sorted_revenue_natures
  end

  def sorted_revenue_natures
    resources
  end

  def revenue_nature_type
    params[:revenue_nature_type]
  end

  def year
    @year = params[:year].present? ? params[:year] : '2019'
  end

  def resources
    @resources ||= query_for_revenues_natures
  end

  def unique_id
    params[:unique_id]
  end

  private

  def query_for_revenues_natures
    revenues_natures = Integration::Supports::RevenueNature.
      where(
        revenue_nature_type: revenue_nature_type,
        year: year_nature
      ).
      order(
        :descricao
      ).
      pluck(
        :unique_id,
        :descricao
      ).map{ |unique_id, descricao| { id: unique_id, name: descricao.strip } }.uniq
  end

  def year_nature
    if (year.to_i <= 2018)
      '2018'
    else
      year
    end
  end

  def revenue_nature_types
    Integration::Supports::RevenueNature.revenue_nature_types
  end
end
