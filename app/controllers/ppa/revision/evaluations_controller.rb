class PPA::Revision::EvaluationsController < PPAController
   include ::AuthorizedController
   include PPA::Revision

   helper_method :resource

   before_action :can_plan_in_revision_status
   before_action :can_evaluate_plan?
   before_action :associate_user, only: [:create]
   before_action :associate_plan, only: [:create]
   before_action :redirect_if_exists, only: [:new]

   PERMITTED_PARAMS = [
      :question1,
      :question2,
      :question3,
      :question4,
      :question5,
      :question6,
      :question7,
      :question8,
      :question9,
      :question10
   ]

  def resource_name
      model_class.to_s
  end


   def can_plan_in_revision_status
     authorize! :revision, plan
   end

  def resource_symbol
      'ppa_revision_evaluation'
  end

   def model_class
      PPA::Revision::Evaluation
   end

   def associate_user
      resource.user = current_user
   end

   def associate_plan
      resource.plan = plan
   end

   def redirect_if_exists
      resource = model_class.find_by_user_id(current_user.id)
      if resource
         redirect_to resource
      end
   end

   # Sobrescrevendo medoto q atualizaria o perfil do participante
   def ppa_user_needs_update?; end

   def can_evaluate_plan?
      unless can? :can_review_evaluation, plan
         redirect_to root_path
      end
   end

end
