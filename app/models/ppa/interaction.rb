module PPA
  class Interaction < ApplicationRecord
    belongs_to :user
    belongs_to :interactable, polymorphic: true

    validates :user, presence: true

    # jsonb serialized :data


    class << self
      def latest(n = 1)
        order(arel_table[:id].desc).limit(n)
      end
    end

  end
end
