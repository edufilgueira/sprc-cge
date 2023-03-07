##
# Módulo incluído por models que tenham enums localizáveis.
#
# Ex:
#
# class User
#
#   enum user_type: [:admin, :operator]
#
# end

# => User.new(user_type: :admin).user_type_str # I18n.t('user.user_types.admin')
#
# Para models com namspace, a separação é por barra:
# Ex: integration/eparcerias/configuration.import_types.import_all
##

module EnumLocalizable
  extend ActiveSupport::Concern

  def method_missing(method_name, *args, &block)
    method_name_str = method_name.to_s

    if method_name_str.end_with?('_str')
      enum_name = method_name_str.gsub(/_str$/,'')

      if self.class.defined_enums.keys.include?(enum_name)
        enum_value = send(enum_name)

        if enum_value.present?
          root_key = self.class.model_name.i18n_key

          return I18n.t("#{root_key}.#{enum_name.pluralize}.#{enum_value}")
        else
          return enum_value
        end
      end
    end

    super
  end
end
