module User::NotificationRoles
  extend ActiveSupport::Concern

  included do

    NOTIFICATION_ROLES = [
      :new_ticket,
      :deadline,
      :transfer,
      :share,
      :referral,
      :invalidate,
      :appeal,
      :reopen,
      :extension,
      :answer,
      :user_comment,
      :internal_comment,
      :attendance_allocation,
      :change_ticket_type,
      :satisfaction_survey
    ]


    # Initializer

    def initialize(attributes={})
      super

      self.notification_roles = notification_roles_for_user if self.notification_roles.blank?
    end


    # private

    private

    def notification_roles_for_user
      return default_notification_roles unless user_type.present?

      send("#{user_type}_notification_roles")
    end

    def user_notification_roles
      default_notification_roles.except(:internal_comment, :change_ticket_type)
    end

    def admin_notification_roles
      {}
    end

    def operator_notification_roles
      default_notification_roles
    end

    # Todas a notificações padrões e possíveis
    def default_notification_roles
      Hash[NOTIFICATION_ROLES.collect{ |n| [n, 'email'] }]
    end
  end
end
