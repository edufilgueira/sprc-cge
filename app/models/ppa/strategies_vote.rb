module PPA
  class StrategiesVote < ApplicationRecord

    belongs_to :user
    belongs_to :region
    has_many :strategies_vote_items
  end
end
