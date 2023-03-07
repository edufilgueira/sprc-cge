module PPA
  class Objectives::StrategiesController < PPAController

    helper_method :strategies

    def index
    end

    private

    def objective
      @objective ||= PPA::Objective.find(params[:objective_id])
    end

    def strategies
      @strategies ||= objective.strategies
    end

  end
end
