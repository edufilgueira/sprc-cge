class ServicesRatingController < TransparencyController
  include ServicesRating::Breadcrumbs

  prepend_before_action :check_captcha, only: [:create] # 

	helper_method :services_rating, :page_attachments

	PERMITTED_PARAMS = [:description]

  def create
    if resource_save

      # dá a oportunidade do 'caller' fazer algo com o recurso após ter gravado

      yield(resource) if block_given?

      redirect_after_save_with_success
    else
      set_error_flash_now_alert
      render :index
    end
  end

  def controller_base_view_path
    controller_path
  end


  def services_rating
    resource
  end

  def page_attachments
    Page.find_by_slug(slug_page_attahcments)
  end

  def slug_page_attahcments
    'anexos-das-avaliacoes-de-servicos-publicos'
  end

  def notice_exception?
    true
  end

  private

  def transparency_id
    :services_rating
  end

  def check_captcha
    unless verify_recaptcha
      respond_to do |format|
        format.html { render :index }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end 
  end  
end
