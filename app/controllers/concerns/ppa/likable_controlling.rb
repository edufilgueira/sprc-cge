module PPA
  module LikableControlling
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :likable_resource

      def likable(method)
        @likable_resource = method
        define_method(:likable) { send method }
      end
    end


    included do
      before_action :authenticate_user!
    end


    def create
      ApplicationRecord.transaction do
        # antes de tudo, tenta remover um possível "dislike" antagônico, pois temos
        # validação de unicidade em interações like/dislike
        remove_antagonic_dislike_if_exists

        if likable.likes.create user: current_user
          flash[:notice] = t '.success'
        else
          flash[:alert] = t '.failure'
        end
      end

      redirect_back fallback_location: ppa_root_path
    end


    private

    def likable
      raise NotImplementedError, <<~ERR
        #{self.class.name} has not defined the likable resource method.
        Make sure to use ::likable method on the class to configure it.
      ERR
    end

    def remove_antagonic_dislike_if_exists
      if likable.respond_to? :dislikes
        prev_user_dislike = likable.dislikes.find_by user_id: current_user.id
        prev_user_dislike.destroy if prev_user_dislike.present?
      end
    end

  end
end
