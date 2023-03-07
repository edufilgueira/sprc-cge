module PPA::Revision::ReviewProblemSituationStrategies::Breadcrumbs

  def actions_breadcrumbs
    {
      'index': index_breadcrumbs,

      'new': new_create_breadcrumbs,

      'create': new_create_breadcrumbs,

      'show': show_edit_update_breadcrumbs,

      'edit': show_edit_update_breadcrumbs,

      'update': show_edit_update_breadcrumbs,

      'delete': delete_destroy_breadcrumbs,

      'destroy': delete_destroy_breadcrumbs,

      'conclusion': show_edit_update_breadcrumbs
    }
  end

  protected

  def show_edit_update_breadcrumbs
    breadcrumbs_base
  end

  def new_create_breadcrumbs
  	breadcrumbs_base
  end

  def conclusion
    breadcrumbs_base
  end

  

  def breadcrumbs_base
  	[
      [t('app.home'), root_path],
      [t('ppa.home.headline.title'), ppa_root_path],
      [t('ppa.plans.show.title', plan: plan.name), ppa_plan_path(plan.id)],
      [t('ppa.revision.review_problem_situation_strategies.new.title')]
    ]
  end
end
