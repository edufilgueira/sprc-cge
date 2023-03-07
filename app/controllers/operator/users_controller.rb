class Operator::UsersController < OperatorController
  include Operator::Users::Breadcrumbs
  include ::FilteredController
  include ::PaginatedController
  include ::SortedController
  include ::ToggleDisabledController
  include Operator::FilterDisabled

  load_and_authorize_resource

  PER_PAGE = 20

  PERMITTED_PARAMS = [
    :name,
    :social_name,
    :gender,
    :document,
    :document_type,
    :email,
    :email_confirmation,
    :password,
    :password_confirmation,
    :internal_subnet,
    :denunciation_tracking,
    :coordination,
    :organ_id,
    :department_id,
    :sub_department_id,
    :subnet_id,
    :operator_type,
    :education_level,
    :birthday,
    :server,
    :city_id,
    :positioning,
    notification_roles: User::NOTIFICATION_ROLES
  ]

  FILTERED_ASSOCIATIONS = [
    :organ_id,
    :department_id
  ]

  FILTERED_ENUMS = [:operator_type]

  SORT_COLUMNS = [
    'users.name',
    'users.email',
    'users.operator_type'
  ]

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:users, :user, :yourself?, :transparency_resources_path]

  # Actions

  def index
    respond_to do |format|
      format.html do
        super
      end
      
      format.xlsx do
        index_for_xlsx
      end
    end
  end

  def create
    super { set_internal_subnet }
  end

  def update
    super
    set_internal_subnet
    ensure_organ
    ensure_subnet
  end

  def edit
    super
    flash.alert = I18n.t('user.need_to_change_password') if resource.password_changed_at.nil?
  end

  private


  def transparency_export
    @transparency_export ||= Transparency::Export.new(transparency_export_params)
  end
  
  def human?
    verify_recaptcha(model: transparency_export, attribute: :recaptcha)
  end
  
  def transparency_export_params
    {
      # form params
      name: params[:export_name],
      email: params[:export_email],
      worksheet_format: params[:export_worksheet_format],
      
      # controller
      query: filtered_resources_sql,
      resource_name: resource_klass_str,
      status: :queued
    }
  end

  def filtered_resources_sql
    filtered_resources.to_sql
  end
  
  def resource_klass_str
    resource_klass.to_s
  end
  
  def index_for_xlsx
    if human? && transparency_export.save
      Operator::CreateSpreadsheetWorker.perform_async(transparency_export.id)
      render json: { status: 'success', message: I18n.t('transparency.exports.create.done', expiration: Transparency::Export::DEADLINE_EXPIRATION) }
    else
      render json: { status: 'error', errors: transparency_export.errors, message: I18n.t('transparency.exports.create.error') }
    end
  end

  # Helper methods

  def transparency_resources_path
    url_for controller: controller_path, action: :index
  end

  def users
    paginated_users
  end

  def user
    resource
  end

  def yourself?
    current_user == user
  end

  # Resources

  def new_resource
    super.tap do |user|
      user.user_type = :operator
      user.organ = current_user.organ
      user.subnet = current_user.subnet if current_user.subnet.present?
      user.assign_secure_random_password
    end
  end

  def paginated_users
    paginated_resources
  end

  def users_by_operator_types_avaliable
    resources.where(operator_type: operator_types_avaliable)
  end

  def default_sort_scope
    users = users_by_operator_types_avaliable

    if current_user.sectoral?
      users = users.where(organ: current_user.organ)
    elsif current_user.subnet_operator?
      users = users.where(subnet: current_user.subnet)
    end

    users
  end

  def default_sort_column
    User.default_sort_column
  end

  def default_sort_direction
    User.default_sort_direction
  end

  ## Devise reset password

  def send_reset_password_instructions(user)
    user.send_reset_password_instructions
  end

  def operator_types_avaliable
    return User::OPERATOR_TYPES_FOR_CGE_OPERATORS if current_user.cge?
    return User::OPERATOR_TYPES_FOR_SUBNET_OPERATORS if current_user.subnet_operator?

    current_user.sou_sectoral? ? User::OPERATOR_TYPES_FOR_SOU_OPERATORS : User::OPERATOR_TYPES_FOR_SIC_OPERATORS
  end

  def ensure_organ
    user.update_column(:organ_id, current_user.organ_id) if current_user.organ.present?
  end

  def ensure_subnet
    user.update_column(:subnet_id, current_user.subnet_id) if current_user.subnet.present?
  end

  def set_internal_subnet
    user.update(internal_subnet: internal_subnet?)
  end

  def internal_subnet?
    user.internal? && user.subnet.present?
  end

end
