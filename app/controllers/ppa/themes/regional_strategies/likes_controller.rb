require_dependency 'ppa/likable_controlling'

module PPA
  module Themes::RegionalStrategies
    class LikesController < ApplicationController
      include PPA::RegionWithBiennium
      include LikableControlling

      likable :regional_strategy


      def regional_strategy
        @regional_strategy ||= PPA::Biennial::RegionalStrategy.find params[:regional_strategy_id]
      end

    end
  end
end
