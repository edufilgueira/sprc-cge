module PPA
  class StrategiesVotesController < ::PPAController

    before_action :authenticate_user!
    before_action :verify_region_opened_to_vote?, only: [:new, :create]
    before_action :set_proposal_region_vote, only: [:index, :new], if: :user_has_proposal?
    before_action :verify_user_has_vote?, only: [:new, :create]
    before_action :verify_user_efective_vote?, only: [:create]

    helper_method  :regions, :axes, :themes, :resource
    helper_method :objectives, :regions, :axes, :themes

    def axes
      plan.axes.order('ppa_axes.name')
    end

    def themes
      plan.themes.order('ppa_themes.name')
    end

    def create
      respond_to do |format|


        strategies_vote_params = Array.new
        ApplicationRecord.transaction do

          strategies_vote = StrategiesVote.create(resource_params_hash)
          for strategy_id in nested_resource_params.values

            if !strategies_vote.strategies_vote_items.create(
              nested_resource_params_hash(strategy_id)
            )
              raise 'erro'
            end
            format.html {
              redirect_to ppa_plan_strategies_vote_path(id: strategies_vote.id)
            }
          end
        end
      end
    end

    private

    def verify_user_has_vote?
      if resource_klass.where(user: current_user).present?
        flash[:alert] = t('.verify_user_has_vote')
        redirect_to ppa_plan_path(plan.id)
      end
    end

    def set_proposal_region_vote
      if region.code != params[:region_code]
        redirect_to new_ppa_plan_strategies_vote_path(region_code: region.code)
      end
    end

    def user_has_proposal?
      region.present? #region of proposal or param
    end

    def verify_region_opened_to_vote?
      unless region.strategic_voting_open?
        flash[:alert] = t('.region_schedule_dont_exist', region: region.name)
        redirect_to ppa_plan_path(plan.id)
      end
    end

    def resource_klass
      PPA::StrategiesVote
    end

    def nested_resource_params
      if params[resource_symbol].present?
        params.require(resource_symbol)[:strategies_vote_items].permit!
      end
    end

    def resource_params_hash
      {
        user: current_user,
        region: region
      }
    end

    def nested_resource_params_hash(strategy_id)
      {
        strategy_id: strategy_id
      }
    end

    def verify_user_efective_vote?
      if !nested_resource_params.present?
        flash[:alert] = t('.without_vote')
        redirect_to new_ppa_plan_strategies_vote_path(
          region_code: region.code,
        )
      end
    end

    def resource_symbol
      "ppa_#{resource_name}".to_sym
    end

    def javascript
      "views/#{controller_path}/#{action_name}"
    end
  end
end
