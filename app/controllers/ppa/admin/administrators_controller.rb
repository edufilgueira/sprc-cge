module PPA::Admin
  class AdministratorsController < PPA::AdminController
    include Administrators::BaseBreadcrumbs

    before_action :assign_secure_random_password, only: :create
    before_action :ensure_not_toggle_locking_one_self!, only: :toggle_lock

    FIND_ACTIONS = ['show', 'edit', 'update', 'destroy', 'toggle_lock']

    PERMITTED_PARAMS = [
      :name,
      :cpf,
      :email,
    ]

    def toggle_lock
      if resource.locked?
        resource.unlock_access!
        flash[:notice] = t '.unlock.done', name: resource.name
      else
        resource.lock_access!
        flash[:notice] = t '.lock.done', name: resource.name
      end

      redirect_to_index
    end

    helper_method [:ppa_administrators, :ppa_administrator]

    # Helper methods

    def ppa_administrators
      paginated(resources.sorted)
    end

    def ppa_administrator
      resource
    end

    private

    def assign_secure_random_password
      resource.assign_secure_random_password
    end

    def ensure_not_toggle_locking_one_self!
      return unless resource == current_ppa_admin

      flash[:alert] = t '.cannot_toggle_lock_one_self'
      redirect_to_index
    end

    def resource_name
      'ppa_administrator'
    end

    def resource_klass
      PPA::Administrator
    end

  end
end
