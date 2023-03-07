module PPA
=begin

  Define escopos para Models que tenham associações com models do tipo "Anuais e regionalizados"
  (entenda `PPA::Annual`, com include `Regionalized`).

  Basicamente, transforma:
```ruby
module PPA
  class Strategy < ApplicationRecord
    belongs_to :objective

    has_many :annual_regional_strategies

    scope :in_year_and_region, -> do |year, region|
      joins(:annual_regional_strategies)
        .where(annual_regional_strategies: { year: year, region_id: region })
        .distinct
    end
  end
end
```

  Em:
```ruby
module PPA
  class Strategy < ApplicationRecord
    include AnnuallyRegionalizable

    annually_regionalizable_by :annual_regional_strategies

    belongs_to :objective
    has_many :annual_regional_strategies

  end
end
```


  Ou seja, inclui escopos básicos de recortes por ano e região:
- `::in_year_and_region`

=end
  module AnnuallyRegionalizable
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :annually_regionalizable_by_association_name,
                  :annually_regionalizable_by_association_class,
                  :annually_regionalizable_by_foreign_key

      #
      # Setup method
      #
      # usage:
      # ```ruby
      # module PPA
      #   class Strategy < ApplicationRecord
      #     include AnnuallyRegionalizable
      #
      #     annually_regionalizable_by :annual_regional_strategies
      #     has_many :annual_regional_strategies
      #   end
      # end
      # ```
      #
      def annually_regionalizable_by(association)
        @annually_regionalizable_by_association_name = association.to_sym

        # invalidating memoized values from association metadata, allowing the measurable
        # association to be redefined
        @annually_regionalizable_by_association_class = nil
        @annually_regionalizable_by_foreign_key       = nil
      end

      # lazily evaluated association class
      def annually_regionalizable_by_association_class
        @annually_regionalizable_by_association_class ||= begin
          reflection = reflections[annually_regionalizable_by_association_name.to_s]
          reflection.klass
        end
      end

      # lazily evaluated association foreign key
      def annually_regionalizable_by_foreign_key
        @annually_regionalizable_by_foreign_key ||= begin
          reflection = reflections[annually_regionalizable_by_association_name.to_s]
          reflection.foreign_key
        end
      end


      # scope methods
      # --

      #
      # Recupera os registros a partir de um ano e uma região
      #
      # @param [Integer] year Ano a ser recortado
      # @param [PPA::Region,Integer] region região do recorte
      #
      # @return [ActiveRecord::Relation] Relação/escopo com o recorte aplicado
      #
      def in_year_and_region(year, region)
        association_table = annually_regionalizable_by_association_class.arel_table
        region_id = region.respond_to?(:id) ? region.id : region # casting to Integer => ARel

        joins(annually_regionalizable_by_association_name)
          .where(
            association_table[:year].eq(year).and(
              association_table[:region_id].eq(region_id)
            )
          )
          .distinct # evitando replicações
      end
      alias by_year_and_region in_year_and_region

    end
  end
end
