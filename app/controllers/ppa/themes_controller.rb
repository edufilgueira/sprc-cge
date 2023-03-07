module PPA
  class ThemesController < PPAController
  	include PPA::Themes::BaseBreadcrumbs,  PaginatedController

    before_action :authenticate_user!

		helper_method :axes, :has_user_proposal?, :user_proposal, :proposals

		def proposals

		end

	  def has_user_proposal?(theme_id)
	  	theme = set_proposal(theme_id)
	  	theme.proposal.where(user: current_user).any?
	  end

	  def user_proposal(theme_id)
	  	theme = set_proposal(theme_id)
	  	theme.proposal.where(user: current_user).first
	  end

		def resources
      @resources ||= current_user.ppa_proposals
    end

    def proposals
      paginated_resources
    end

    def filtered_resources
      resources
    end

	  private

	  def axes
	    PPA::Search::ThemesGroupedByAxis.new(params[:search]).records
	  end    

	  def set_proposal(theme_id)
	  	PPA::Theme.find(theme_id)
	  end
  end
end