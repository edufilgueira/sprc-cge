require_dependency 'ppa/biennial/regionalized'

module PPA
  module Biennial
    class RegionalStrategy < ApplicationRecord
      include Regionalized
      include PPA::Biennial::RegionalStrategy::Search # precisa ficar completo pelo padrão de nomeação de busca, que causa dependência circular
      include ::Sortable

      regionalizes :strategy

      has_one :objective, through: :strategy

      has_many :initiatives,
        ->(regional_strategy) do
          in_biennium_and_region(regional_strategy.biennium, regional_strategy.region_id)
            .distinct
        end,
        through: :strategy, source: :biennial_regional_initiatives
      has_many :products, through: :initiatives, source: :products

      # interactions
      with_options as: :interactable, dependent: :destroy do |assoc|
        assoc.has_many :likes
        assoc.has_many :dislikes
        assoc.has_many :comments
      end

      # prioridade regional? "Sim" ou "Não"
      enum priority: { prioritized: 1 }


      delegate :name, to: :strategy,  prefix: true
      delegate :name, to: :objective, prefix: true

      # Há o atributo "priority_index", que indica a ordem da priorização, para os que estiverem
      # marcados como "prioridade regional" (prioritized)
      validates :priority_index, allow_blank: true, numericality: { only_integer: true, greater_than: 0 }


      def self.default_sort_column
        'ppa_strategies.name'
      end


      def calculate_initiatives_count!
        update! initiatives_count: initiatives.count
      end

      def calculate_products_count!
        update! products_count: products.count
      end

    end
  end
end
