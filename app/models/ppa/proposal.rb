module PPA
  class Proposal < ApplicationRecord
    include PPA::Proposal::Search # precisa ficar completo pelo padrão de nomeação de busca, que causa dependência circular
    include ::Sortable

    belongs_to :city, class_name: 'PPA::City'
    belongs_to :plan
    belongs_to :user
    belongs_to :theme
    belongs_to :region

    belongs_to :objective, optional: true

    with_options as: :interactable, dependent: :destroy, counter_cache: true do |assoc|
      assoc.has_many :votes
      assoc.has_many :comments
    end

    delegate :name, to: :user, prefix: true
    delegate :name, to: :city, prefix: true
    delegate :name, to: :region, prefix: true
    delegate :name, :axis_name, to: :theme, prefix: true

    validates :plan, :user, :theme, :region, presence: true
    validates :justification, presence: true



    class << self
      # scopes
      def in_biennium_and_region(biennium, region)
        biennium = PPA::Biennium.new biennium
        region_id = region.respond_to?(:id) ? region.id : region

        joins(:region)
          .where(
            arel_table[:created_at].gteq(biennium.beginning_date).and(
            arel_table[:created_at].lteq(biennium.ending_date).and(
            PPA::Region.arel_table[:id].eq(region_id)
            ))
          )
      end
    end

    def self.default_sort_column
      'ppa_proposals.strategy'
    end

    def open_for_voting?
      plan.open_for_voting?
    end

    def closed_for_voting?
      !open_for_voting?
    end

  end
end
