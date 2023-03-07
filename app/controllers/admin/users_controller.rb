class Admin::UsersController < Admin::BaseCrudController
  include Admin::Users::Breadcrumbs
  include ToggleDisabledController
  include Admin::Users::Filters

  before_action :assign_secure_random_password, only: :create, unless: :password_supplied?

  before_action :update_subnet, only: :update

  PERMITTED_PARAMS = [
    :name,
    :social_name,
    :gender,
    :document,
    :document_type,
    :email,
    :email_confirmation,
    :user_type,
    :operator_type,
    :organ_id,
    :department_id,
    :sub_department_id,
    :subnet_id,
    :password,
    :password_confirmation,
    :person_type,
    :internal_subnet,
    :denunciation_tracking,
    :education_level,
    :birthday,
    :server,
    :city_id,
    :positioning,
    :acts_as_sic,
    :sectoral_denunciation,
    notification_roles: User::NOTIFICATION_ROLES
  ]

  SORT_COLUMNS = {
    name: 'users.name',
    email: 'users.email',
    user_type: 'users.user_type',
    operator_type: 'users.operator_type',
    organ: 'organs.acronym'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:users, :user]

  def edit
    super
    flash.alert = I18n.t('user.need_to_change_password') if resource.password_changed_at.nil?
  end


  # Helper methods

  def users
    paginated_resources
  end

  def user
    resource
  end

  # Private

  private

  def assign_secure_random_password
    # Um password seguro, randômico e indedutível para satisfazer a validação do Devise
    resource.assign_secure_random_password
  end

  def default_sort_scope
    User.references([:organ, {department: :organ}, {subnet: :organ}]).includes([:organ, {department: :organ}, {subnet: :organ}]).where(user_type: [:operator, :admin])
  end

  def organ
    params[:organ]
  end

  def password_supplied?
    %i[password password_confirmation].any? { |attr_name| resource_params[attr_name].present? }
  end

  def update_subnet
    subnets_role = ["subnet_sectoral", "subnet_chief", "internal"]
    user.subnet = nil unless subnets_role.include?(resource_params[:operator_type])
  end
end
