class PPA::Revision::ParticipantProfilesController < PPAController
   include ::AuthorizedController

   helper_method :participant_profile, :resource_klass

   PERMMITED_PARAMS = [
    :age,
    :genre,
    :other_genre,
    :sexual_orientation,
    :other_sexual_orientation,
    :deficiency,
    :other_deficiency,
    :breed,
    :ethnic_group,
    :educational_level,
    :family_income,
    :representative,
    :representative_description,
    :collegiate,
    :other_ppa_participation
  ]

  before_action :can_plan_in_revision_status

  def new
    render :new
  end

  def create
    ApplicationRecord.transaction do
      participant_profile = PPA::Revision::ParticipantProfile.find_or_create_by(user_id: current_user.id)
      participant_profile.update(resource_params)
    end

    redirect_to new_ppa_revision_review_problem_situation_strategy_path(plan_id: plan.id)
  end

  def participant_profile
    resource
    # current_participant_profile = resource_klass.find_by(user_id: current_user.id)
    # return resource if current_participant_profile.blank?

    # current_participant_profile
  end

  private

  def resource_klass
    PPA::Revision::ParticipantProfile
  end

  def resource_params
    if params[:ppa_revision_participant_profile]
      params.require(:ppa_revision_participant_profile).permit(PERMMITED_PARAMS)
    end
  end

  def can_plan_in_revision_status
    authorize! :revision, plan
  end
end
