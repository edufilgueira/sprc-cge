module PPA
  class StrategiesVoteItem < ApplicationRecord

    belongs_to :strategy
    belongs_to :strategies_vote
  end
end
