module ::Transparency::Contracts::Instrument
  extend ActiveSupport::Concern

  def show_by_instrument #numero sac
    convenant =  resource_klass.find_by_isn_sic(params[:instrument])
    if convenant.present?
      params[:id] = convenant.id
      @resource = find_resource
      redirect_to resource_show_path
    else
      error_not_found!(404)
    end
  end

end
