##
# Módulo incluído por controllers que possuem actions genérica
##
module ToggleDisabledController
  extend ActiveSupport::Concern

  included do

    # Actions

    def toggle_disabled
      if toggle_disabled_update
        flash[:notice] = toggle_disabled_success_message
      else
        flash[:alert] = toggle_disabled_error_message
      end

      redirect_to_same_page_after_toggle_disabled
    end
  end


  # private

  private

  def redirect_to_same_page_after_toggle_disabled
    redirect = request.referrer.present? ? request.referrer : resource_index_path
    redirect_to redirect
  end

  def toggle_disabled_update
    resource.disabled? ? resource.enable! : resource.disable!
  end

  def toggle_disabled_success_message
    resource.disabled? ? t('.disabled') : t('.enabled')
  end

  def toggle_disabled_error_message
    resource.disabled? ? t('messages.toggle_disabled.error.enable') : t('messages.toggle_disabled.error.disable')
  end
end
