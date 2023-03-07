module PPA
  class InitiativeStrategy < ApplicationRecord

    belongs_to :initiative
    belongs_to :strategy

    validates :initiative, presence: true
    validates :strategy, presence: true

    # uniqueness
    validates :strategy_id, uniqueness: { scope: :initiative_id }

  end
end
