module PPA
  module PlanHelper

  	def statuses_for_select
    	statuses_keys.map do |status|
     		[status_title(status), status]
    	end
  	end

  	def statuses_keys
    	PPA::Plan.statuses.keys
  	end

	 	def status_title(status)
	    I18n.t("ppa/plan.status.#{status}")
		end

    def ppa_elaboration_current
      PPA::Plan.elaborating.current
    end

    def plan_item(item)
      plans_by_status(item).any? ? plans_by_status(item).last : nil
    end

    # set no status específico o nome do card (partial)
    # que será renderizada em: ../view/ppa/plan/show.halm.html
    def search_card_name(status)
      case status.to_sym
      when :elaborating
        'strategies_vote'
      when :monitoring
        # trocar nome quando for disponibilizar,
        # é apenas de aviso temporário a string
        'partial pendente'
      when :evaluating, :revising
        'schedule_activies'
      end
    end

    def take_last_record(item)
      PPA::Plan.send(item).last if PPA::Plan.send(item).any?
    end

    def url_submit_elaborating
      new_ppa_plan_strategies_vote_path(
        plan_id: plan.id,
        region_code: ":region",
        card_name: params['card_name'],
        plan_status: params['plan_status']
      )
    end

    def url_submit_revising_revision_review
      new_ppa_revision_review_problem_situation_strategy_path(plan_id: plan.id)
    end

    def url_submit_revising_revision_prioritization
      ppa_revision_prioritizations_path(plan_id: plan.id)
    end

    def view_card_on_revising_for_status
      {
        revising: 'schedule_activies',
        elaborating: 'strategies_vote'
      }
    end

    def show_card
      view_card_on_revising_for_status[plan.status.to_sym]
    end

    def cards_for_phases_path
      "ppa/plans/cards/phases/#{plan.status}/#{show_card}"
    end
  end
end
