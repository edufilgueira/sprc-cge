module PPA
  module CommentableControlling
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :commentable_resource

      def commentable(method)
        @commentable_resource = method
        define_method(:commentable) { send method }
      end
    end


    included do
      before_action :authenticate_user!
    end


    def create
      comment = commentable.comments.new user: current_user
      comment.assign_attributes(comment_params)

      if comment.save
        flash[:notice] = t '.success'
      else
        flash[:alert] = t '.failure'
      end

      redirect_back fallback_location: ppa_root_path
    end


    private

    def commentable
      raise NotImplementedError, <<~ERR
        #{self.class.name} has not defined the commentable resource method.
        Make sure to use ::commentable method on the class to configure it.
      ERR
    end

    def comment_params
      raise NotImplementedError, <<~ERR
        #{self.class.name} has not implemented the #comment_params method.
      ERR
    end

  end
end
