require_dependency 'ppa/dislikable_controlling'

module PPA
  module Themes::RegionalStrategies
    class DislikesController < ApplicationController
      include PPA::RegionWithBiennium
      include DislikableControlling

      dislikable :regional_strategy


      def regional_strategy
        @regional_strategy ||= PPA::Biennial::RegionalStrategy.find params[:regional_strategy_id]
      end

    end
  end
end
