require_dependency 'ppa/commentable_controlling'

module PPA
  module Proposals
    class CommentsController < ApplicationController
      include CommentableControlling

      commentable :proposal

      private

      def comment_params
        params.require(:ppa_comment).permit(:content)
      end

      def proposal
        @proposal ||= PPA::Proposal.find params[:proposal_id]
      end

    end
  end
end
