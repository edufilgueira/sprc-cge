module PPA
  module DislikableControlling
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :dislikable_resource

      def dislikable(method)
        @dislikable_resource = method
        define_method(:dislikable) { send method }
      end
    end


    included do
      before_action :authenticate_user!
    end


    def create
      ApplicationRecord.transaction do
        # antes de tudo, tenta remover um possível "like" antagônico, pois temos
        # validação de unicidade em interações like/dislike
        remove_antagonic_like_if_exists

        if dislikable.dislikes.create user: current_user
          flash[:notice] = t '.success'
        else
          flash[:alert] = t '.failure'
        end
      end

      redirect_back fallback_location: ppa_root_path
    end


    private

    def dislikable
      raise NotImplementedError, <<~ERR
        #{self.class.name} has not defined the dislikable resource method.
        Make sure to use ::dislikable method on the class to configure it.
      ERR
    end

    def remove_antagonic_like_if_exists
      if dislikable.respond_to? :likes
        prev_user_like = dislikable.likes.find_by user_id: current_user.id
        prev_user_like.destroy if prev_user_like.present?
      end
    end

  end
end
