require_dependency 'ppa/commentable_controlling'

module PPA
  module Themes::RegionalStrategies
    class CommentsController < ApplicationController
      include PPA::RegionWithBiennium
      include CommentableControlling

      commentable :regional_strategy


      private

      def comment_params
        params.require(:ppa_comment).permit(:content)
      end

      def regional_strategy
        @regional_strategy ||= PPA::Biennial::RegionalStrategy.find params[:regional_strategy_id]
      end

    end
  end
end
