module PPA
  class Themes::ProposalsController < PPAController
  include PPA::Proposals::BaseBreadcrumbs,  PaginatedController

    before_action :authenticate_user!, only: %i[new create]
    before_action :ensure_current_plan_open_for_proposals!, only: %i[new create]

    PERMITTED_PARAMS = [
      :justification
    ]

    PER_PAGE = 3

    helper_method [
      :proposal, 
      :regions,
      :axes,
      :resources,
      :proposals,
      :plan,
      :theme
    ]

    def create
      if proposal.save
        flash[:notice] = t('.success')
        redirect_to ppa_plan_region_theme_proposal_path(plan.id, region.code, theme.id, proposal.id)
      else
        flash[:alert] = t('.failure')
        render :new
      end
    end

    def update
       if proposal.update(proposal_attributes)
        flash[:notice] = t('.success')
        redirect_to ppa_plan_region_theme_proposal_path(plan.id, region.code, theme.id, proposal.id)
      else
        flash[:alert] = t('.failure')
        render :new
      end
    end

    def destroy
      if proposal.destroy
        flash[:notice] = t('.success')
        redirect_to ppa_plan_themes_path(plan.id, region.code)
      else
        flash[:alert] = t('.failure')
        render :show
      end
    end

    def resources
      @resources ||= current_user.ppa_proposals.where(theme: params[:theme_id])
    end

    def proposals
      paginated_resources
    end

    def filtered_resources
      resources
    end

    def theme
      @theme ||= PPA::Theme.find(params[:theme_id])
    end

    private

    def regions
      PPA::Region.all
    end

    def axes
      a=*(1..20)
      PPA::Axis.joins(:themes).where('ppa_themes.id not in (?)', a).all
    end
  
    def proposal
      @proposal ||= set_proposal
    end

    def set_proposal
      if action_name.in? ['show', 'edit', 'destroy', 'update']
        PPA::Proposal.find(params[:id])
      else 
        PPA::Proposal.new(proposal_attributes)
      end
    end

    def themes_with_objectives
      PPA::Theme.with_objectives.order(PPA::Theme.arel_table[:name]).all.inject({}) do |hsh, theme|
        hsh[theme.name] = theme.objectives.order(:name).pluck(:name, :id)
        hsh
      end
    end

    def proposal_attributes
      @proposal_attrs ||= begin
        attrs = if params.key?(:ppa_proposal)
                  params.require(:ppa_proposal).permit(PERMITTED_PARAMS)
                else
                  {}
                end
        attrs.merge plan_id: plan.id, user_id: current_user.id, 
          theme_id: theme.id, region_id: region.id
      end
    end
  end
end