require_dependency 'ppa/interaction'

module PPA
  class UniqueInteraction < Interaction

    validates :user_id, uniqueness: { scope: %i[interactable_type interactable_id] }

  end
end
