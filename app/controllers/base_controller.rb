module BaseController
  extend ActiveSupport::Concern

  include BreadcrumbsController

  FIND_ACTIONS = ['show', 'edit', 'update', 'destroy', 'import']


  PERMITTED_PARAMS = []

  included do
    helper_method [:breadcrumbs, :javascript, :stylesheet, :print?]
  end

  # Default actions

  def index
    if request.xhr?
      render partial: index_partial_view_path, layout: false
    else
      render index_view_path
    end
  end

  def new
  end

  def create
    if resource_save

      # dá a oportunidade do 'caller' fazer algo com o recurso após ter gravado

      yield(resource) if block_given?

      redirect_after_save_with_success
    else
      set_error_flash_now_alert
      render :new
    end
  end

  def show
    if request.xhr?
      render partial: show_partial_view_path, layout: false
    else
      render show_view_path
    end
  end

  def edit
  end

  def update
    resource.assign_attributes(resource_params)

    # dá a oportunidade do 'caller' fazer algo com o recurso ANTES de ser gravado
    yield(resource) if block_given?

    if resource.save
      redirect_after_save_with_success
    else
      set_error_flash_now_alert
      render :edit
    end
  end

  def destroy
    # usa um método para remover o recurso pois alguns podem usar diretamente
    # o destroy enquanto outros podem usar remoção lógica, por ex.
    if resource_destroy
      redirect_to_index_with_success
    else
      redirect_to_index_with_error
    end
  end

  # Helper methods

  def javascript
    "views/#{controller_path}/#{action_name}"
  end

  def stylesheet
    "views/#{controller_path}/#{action_name}"
  end

  # Privates

  private

  ## Resource access

  def resources
    @resources ||= resource_klass.all
  end

  def resource
    @resource ||= (find_action? ? find_resource : new_resource)
  end

  def find_resource
    resources.find(params[:id])
  end

  def new_resource
    resources.new(resource_params)
  end

  # retorna o nome do recurso para o controller corrente
  # Ex: UsersController # => user
  def resource_name
    controller_name.singularize
  end

  # retorna o nome do recurso no plural
  # Ex: UsersController # => users
  def resources_name
    resource_name.to_s.pluralize
  end

  # resource_name como symbol usado para autorizar params, por ex.
  # Não funciona para models com namespace e deve ser sobrescrito pelo próprio
  # controller nesses casos.
  def resource_symbol
    resource_name.to_sym
  end

  def resource_params
    if params[resource_symbol].present?
      params.require(resource_symbol).permit(self.class::PERMITTED_PARAMS)
    end
  end

  # Retorna a classe relacionada ao controller. Não funciona para models com
  # namespace e deve ser sobrescrito pelo próprio controller nesses casos.
  def resource_klass
    resource_name.camelize.constantize
  end

  def find_action?
    self.class::FIND_ACTIONS.include?(action_name)
  end

  # Resources

  def resource_destroy
    resource.destroy
  end

  def resource_save
    retorno = resource.save
  end

  # View paths

  def index_view_path
    # Permite que as subclasse renderizem uma view específica para a
    # index.
    'index'
  end

  def index_partial_view_path
    # Permite que as subclasse renderizem uma partial específica para a
    # index.
    index_view_path
  end

  def show_view_path
    # Permite que as subclasse renderizem uma view específica para a
    # show.
    'show'
  end

  def show_partial_view_path
    # Permite que as subclasse renderizem uma partial específica para a
    # show.
    show_view_path
  end

  # Navigational methods

  def redirect_after_save_with_success
    if params[:from] == 'index'
      redirect_to_index_with_success
    else
      redirect_to_show_with_success
    end
  end

  def redirect_to_index_with_success
    set_success_flash_notice
    redirect_to_index
  end

  def redirect_to_index_with_error
    set_error_flash_alert
    redirect_to_index
  end

  def redirect_to_index
    redirect_to resource_index_path
  end

  def resource_index_path
    { controller: controller_path, action: :index }
  end

  def redirect_to_show_with_success
    set_success_flash_notice
    redirect_to_show
  end

  def redirect_to_show(params={})
    redirect_to resource_show_path
  end

  def resource_show_path(params={})
    params.merge(controller: controller_path, action: :show, id: resource.to_param)
  end

  def set_success_flash_notice
    flash[:notice] = t('.done', title: resource_notice_title)
  end

  def set_error_flash_alert
    flash[:alert] = t('.error', title: resource_notice_title)
  end

  def set_error_flash_now_alert
    flash.now[:alert] = t('.error', title: resource_notice_title)
  end

  def resource_notice_title
    resource.title if resource.respond_to?(:title)
  end

  def print?
    params[:print] == 'true'
  end
end
