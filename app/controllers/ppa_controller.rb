#
# Controlador básico para o layout e namespace PPA (/ppa)
#
class PPAController < ApplicationController

  layout 'ppa/application'

  helper_method [
    :namespace,
    :current_plan,
    :current_plan?,
    :elaborating_plan,
    :plan,
    :region,
    :plans_by_status
  ]

  # Helper methods

  def namespace
    :ppa
  end

  def current_plan
    @current_plan ||= PPA::Plan.current
  end

  def current_plan?
    !!current_plan
  end

  def elaborating_plan
    @elaborating_plan ||= PPA::Plan.elaborating.current
  end

  def plan
    @plan ||= set_plan
  end

  def region
    @region ||= set_region
  end

  def regions
    PPA::Region.all
  end

  def plans_by_status(status)
    PPA::Plan.send(status)
  end

  def card_name
    @card_name ||= set_card_name
  end

  def plan_status
    @plan_status ||= set_plan_status
  end


  private

  # Garante a existência de um plano.
  # Útil para criação de verificações com before_action.
  def ensure_current_plan!
    return if current_plan.present?

    flash[:alert] = t 'ppa.ensure_current_plan.alert'
    redirect_back fallback_location: ppa_root_path
  end

  def ensure_current_plan_open_for_proposals!
    return if plan&.open_for_proposals?(region)

    flash[:alert] = t 'ppa.proposals.ensure_current_plan_open_for_proposals.alert'
    redirect_back fallback_location: ppa_root_path
  end

  def set_plan
    id = (params[:plan_id] or params[:id])
    PPA::Plan.find(id)
  end

  def set_region
    user_proposals = current_user.ppa_proposals.where(plan_id: plan.id)

    if user_proposals.any?
      user_proposals.first.region
    else
      PPA::Region.find_by_code(params[:region_code])
    end
  end

  def set_card_name
    params[:card_name]
  end

  def set_plan_status
    params[:plan_status]
  end

end
