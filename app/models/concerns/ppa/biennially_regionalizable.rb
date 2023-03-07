module PPA
=begin

  Define escopos para Models que tenham associações com models do tipo "Bieniais e regionalizados"
  (entenda `PPA::Biennial`, com include `Regionalized`).

  Basicamente, transforma:
```ruby
module PPA
  class Strategy < ApplicationRecord
    belongs_to :objective

    has_many :biennial_regional_strategies

    scope :in_biennium_and_region, -> do |biennium, region|
      biennium = PPA::Biennium.new(biennium)

      joins(:biennial_regional_strategies)
        .where(
          biennial_regional_strategies: {
            start_year: biennium.start_year,
            end_year:   biennium.end_year,
            region_id:  region
          }
        ).distinct
    end
  end
end
```

  Em:
```ruby
module PPA
  class Strategy < ApplicationRecord
    include BienniallyRegionalizable

    biennially_regionalizable_by :biennial_regional_strategies

    belongs_to :objective
    has_many :biennial_regional_strategies

  end
end
```


  Ou seja, inclui escopos básicos de recortes por biênio e região:
- `::in_biennium_and_region`

=end
  module BienniallyRegionalizable
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :biennially_regionalizable_by_association_name,
                  :biennially_regionalizable_by_association_class,
                  :biennially_regionalizable_by_foreign_key

      #
      # Setup method
      #
      # usage:
      # ```ruby
      # module PPA
      #   class Strategy < ApplicationRecord
      #     include BienniallyRegionalizable
      #
      #     biennially_regionalizable_by :biennial_regional_strategies
      #     has_many :biennial_regional_strategies
      #   end
      # end
      # ```
      #
      def biennially_regionalizable_by(association)
        @biennially_regionalizable_by_association_name = association.to_sym

        # invalidating memoized values from association metadata, allowing the measurable
        # association to be redefined
        @biennially_regionalizable_by_association_class = nil
        @biennially_regionalizable_by_foreign_key       = nil
      end

      # lazily evaluated association class
      def biennially_regionalizable_by_association_class
        @biennially_regionalizable_by_association_class ||= begin
          reflection = reflections[biennially_regionalizable_by_association_name.to_s]
          reflection.klass
        end
      end

      # lazily evaluated association foreign key
      def biennially_regionalizable_by_foreign_key
        @biennially_regionalizable_by_foreign_key ||= begin
          reflection = reflections[biennially_regionalizable_by_association_name.to_s]
          reflection.foreign_key
        end
      end


      # scope methods
      # --

      #
      # Recupera os registros a partir de um biênio e uma região
      #
      # @param [PPA::Biennium,String,Array,Hash] biennium Biênio a ser recortado
      # @param [PPA::Region,Integer] region região do recorte
      #
      # @return [ActiveRecord::Relation] Relação/escopo com o recorte aplicado
      #
      def in_biennium_and_region(biennium, region)
        association_table = biennially_regionalizable_by_association_class.arel_table
        biennium = PPA::Biennium.new biennium
        region_id = region.respond_to?(:id) ? region.id : region # casting to Integer => ARel

        joins(biennially_regionalizable_by_association_name)
          .where(
            association_table[:start_year].eq(biennium.start_year).and(
              association_table[:end_year].eq(biennium.end_year).and(
                association_table[:region_id].eq(region_id)
              )
            )
          )
          .distinct # evitando replicações
      end
      alias by_biennium_and_region in_biennium_and_region

    end # class methods

  end
end
