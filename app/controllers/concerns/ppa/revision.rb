module PPA
  module Revision
    extend ActiveSupport::Concern

    included do
      # Controla se o plano passado na rota, está na fase de revisão
      before_action :can_plan_in_revision_status

      # Redireciona para tela de atualização de perfil antes de iniciar a revisão
      #before_action :ppa_user_needs_update?

      helper_method :plan, :resource, :model_class, :region_param, :theme_param, :axis_param, :region_theme_param, :id
    end

    def can_plan_in_revision_status
      authorize! :revision, plan
    end

    def plan
      @plan ||= PPA::Plan.find(param_plan)
    end

    def param_plan
      params[:plan_id]
    end

    def ppa_user_needs_update?
      unless PPA::Revision::ParticipantProfile.find_by(user_id: current_user.id)
        redirect_to new_ppa_revision_participant_profile_path(plan_id: plan.id)
      end
    end

    def resource_params
      return nil if !params[resource_symbol].present?

      params.require(resource_symbol).permit(self.class::PERMITTED_PARAMS)
    end

    def resource_name
      model_class.to_s
    end

    def model_class
      PPA::Revision::Prioritization
    end

    def region_param
      params[:region_id]
    end

    def theme_param
      params[:theme_id]
    end

    def axis_param
      params[:axis_id]
    end

    def region_theme_param
      params[:region_theme_id]
    end

    def id
      params[:id]
    end
  end
end
