module PPA
=begin

  Define escopos para Models que tenham associações com models do tipo "Regionais", ou seja,
com concern `PPA::Regional`.

  Basicamente, transforma:
```ruby
module PPA
  class Strategy < ApplicationRecord
    belongs_to :objective

    has_many :regional_strategies

    scope :in_region, -> do |region|
      joins(:regional_strategies)
        .where(regional_strategies: { region_id: region })
        .distinct
    end
  end
end
```

  Em:
```ruby
module PPA
  class Strategy < ApplicationRecord
    include Regionalizable

    regionalizable_by :regional_strategies

    belongs_to :objective
    has_many :regional_strategies

  end
end
```

  Ou seja, inclui escopos básicos de recortes por região:
- `::in_region`

=end
  module Regionalizable
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :regionalizable_metadata,
                  :regionalizable_association_name,
                  :regionalizable_association_class,
                  :regionalizable_foreign_key

      #
      # Setup method
      #
      # usage:
      # ```ruby
      # module PPA
      #   class Strategy < ApplicationRecord
      #     include Regionalizable
      #
      #     regionalizable_by :regional_strategies
      #     has_many :regional_strategies
      #   end
      # end
      # ```
      #
      def regionalizable_by(association)
        # reseta o metadata, permintindo redefinições (com herança/mixin)
        @regionalizable_metadata = {}
        metadata = @regionalizable_metadata # alias dentro do método

        metadata[:association_name] = association.to_sym
      end

      def regionalizable_association_name
        regionalizable_metadata[:association_name]
      end

      # lazily evaluated association class
      def regionalizable_association_class
        regionalizable_metadata[:association_class] ||= begin
          reflection = reflections[regionalizable_metadata[:association_name].to_s]
          reflection.klass
        end
      end

      # lazily evaluated association foreign key
      def regionalizable_foreign_key
        regionalizable_metadata[:foreign_key] ||= begin
          reflection = reflections[regionalizable_metadata[:association_name].to_s]
          reflection.foreign_key
        end
      end


      # scope methods
      # --

      #
      # Recupera os registros a partir de uma região
      #
      # @param [PPA::Region,Integer] region região do recorte
      #
      # @return [ActiveRecord::Relation] Relação/escopo com o recorte aplicado
      #
      def in_region(region)
        association_table = regionalizable_association_class.arel_table
        region_id = region.respond_to?(:id) ? region.id : region # casting to Integer => ARel

        joins(regionalizable_association_name)
          .where(association_table[:region_id].eq(region_id))
      end
      alias by_region in_region

    end
  end
end
