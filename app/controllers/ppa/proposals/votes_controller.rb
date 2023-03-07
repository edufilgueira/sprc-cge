require_dependency 'ppa/votable_controlling'

module PPA
  module Proposals
    class VotesController < ApplicationController
      include VotableControlling

      before_action :ensure_open_for_voting!, only: %i[new create]

      votable :proposal

      def proposal
        @proposal ||= PPA::Proposal.find params[:proposal_id]
      end


      private

      def ensure_open_for_voting!
        return if proposal.open_for_voting?

        flash[:alert] = t 'ppa.proposals.votes.ensure_open_for_voting.alert'
        redirect_back fallback_location: ppa_root_path
      end

    end
  end
end
