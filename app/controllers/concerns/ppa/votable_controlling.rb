module PPA
  module VotableControlling
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :votable_resource

      def votable(method)
        @votable_resource = method
        define_method(:votable) { send method }
      end
    end

    included do
      before_action :authenticate_user!
    end

    def create
      vote = votable.votes.new user: current_user

      if vote.save
        flash[:notice] = t '.success'
      else
        flash[:alert] = t '.failure'
      end

      redirect_back fallback_location: ppa_root_path
    end

    private

    def votable
      raise NotImplementedError, <<~ERR
        #{self.class.name} has not defined the votable resource method.
        Make sure to use ::votable method on the class to configure it.
      ERR
    end

  end
end
