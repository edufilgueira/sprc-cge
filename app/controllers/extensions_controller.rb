#
# Controller responsável pela aprovação/negação da solicitação de prorrogação
# através da url com o token gerado para cada dirigente/secretário na hora da
# criação da prorrogação
#
class ExtensionsController < ApplicationController
  include Extensions::BaseController

  before_action :can_change_extension_status, only: [ :approve, :reject ]
  after_action :extend_deadline, only: :update

  FIND_ACTIONS = FIND_ACTIONS + ['approve', 'reject']


  # Helpers

  helper_method [:extension, :ticket, :extension_user, :ticket_log_rejected]


  # Actions

  def edit
    set_flash_already_evaluate_and_redirect_to_show unless extension.in_progress?
  end

  def approve
    ApplicationRecord.transaction do
      extension.approved!
      extension.extend_deadline
			register_log
    end

    notify
    redirect_to_show_with_success
  end

  def reject
    if ensure_justification_and_save

      register_log
      notify
      redirect_to_show_with_success
    else
      set_error_flash_now_alert
      render :edit
    end
  end


  # Helpers methods

  def extension
    resource
  end

  def ticket
    extension.ticket
  end

  def current_ability
    @current_ability ||= Abilities::User.factory(nil)
  end

  def extension_user
    @extension_user ||= ExtensionUser.find_by(token: params[:id])
  end

  def ticket_log_rejected
    extension.ticket_logs.find_by("data LIKE '%status: rejected%'")
  end


  # Privates

  private

  def find_resource
    extension_user.extension
  end

  def redirect_to_show
    redirect_to extension_path(extension_user.token)
  end

  def extend_deadline
    extension.extend_deadline
  end

  def notify
    Notifier::Extension.delay.call(extension.id)
  end

  def resource_klass
    Extension
  end

  def current_user
    extension_user.user
  end

  def set_flash_already_evaluate_and_redirect_to_show
    flash[:alert] = t('.already_evaluate')
    redirect_to_show
  end

  def can_change_extension_status
    authorize! :change_extension_status, extension
  end
end
