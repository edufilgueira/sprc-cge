module PPA
  module Biennial
=begin

  Define comportamento de um model Anual que seja classificado por Região.
  - belongs_to association
  - belongs_to :region
  - validates association and :region presence
  - validates uniqueness in region, biennium


  E adiciona escopos de recorte por região no biênio:
  - in_region(region)
  - in_biennium_and_region(biennium, region)


  Setup:
```ruby
module PPA
  module Biennial
    class MyModel < ApplicationRecord
      include Regionalized

      regionalizes :parent

      # ...
    end
  end
end
```

=end
    module Regionalized
      extend ActiveSupport::Concern

      class_methods do
        attr_reader :regionalizes_association_name,
                    :regionalizes_association_class,
                    :regionalizes_foreign_key

        #
        # Setup method
        #
        # usage:
        # ```ruby
        # module PPA
        #   module Biennial
        #     class MyClass < ApplicationRecord
        #       include Regionalized
        #
        #       regionalizes :parent # , **options if needed
        #     end
        #   end
        # end
        # ```
        #
        def regionalizes(association, **options)
          belongs_to association, **options
          belongs_to :region # TODO precisa de `class_name: PPA::Region`?

          # recuperando metadados por reflection
          reflection = reflections[association.to_s]
          @regionalizes_association_name  = association.to_sym
          @regionalizes_association_class = reflection.klass
          @regionalizes_foreign_key       = reflection.foreign_key.to_sym

          # criando alias para a associação
          alias_attribute :regionalizes, @regionalizes_association_name

          # validações relacionadas à associação da medida
          validates @regionalizes_association_name, presence: true
          validates :region, presence: true
          validates :start_year, numericality: { only_integer: true, greater_than: 1900 }
          validates :end_year,   numericality: { only_integer: true }
          validate  :end_year_greater_than_start_year,
                    :start_and_end_year_compose_a_biennium

          # uniqueness validation
          validates @regionalizes_foreign_key, uniqueness: { scope: %i[start_year end_year region_id] }
        end


        # scope methods
        # --

        def in_biennium(biennium)
          biennium = PPA::Biennium.new biennium

          where start_year: biennium.start_year, end_year: biennium.end_year
        end
        alias by_biennium in_biennium


        def in_region(region)
          where region_id: region
        end
        alias by_region in_region

        #
        # Recupera os registros a partir de um biênio e uma região
        #
        # @param [PPA::Biennium,Array,String] biennium Biênio a ser recortado
        # @param [PPA::Region,Integer] region região do recorte
        #
        # @return [ActiveRecord::Relation] Relação/escopo com o recorte aplicado
        #
        def in_biennium_and_region(biennium, region)
          in_biennium(biennium).in_region(region)
        end
        alias by_biennium_and_region in_biennium_and_region

      end # end class methods


      # O PPA::Biennium correspondente aos dados de start_year, end_year
      def biennium
        PPA::Biennium.new [start_year, end_year]
      end

      # Permite definir os valores de ano a partir de um biênio!
      def biennium=(biennium)
        biennium = PPA::Biennium.new biennium
        self.start_year = biennium.start_year
        self.end_year   = biennium.end_year

        biennium
      end


      private

      def end_year_greater_than_start_year
        return nil unless start_year.present? && end_year.present?

        errors.add :end_year, :greater_than, count: start_year unless end_year > start_year
      end

      def start_and_end_year_compose_a_biennium
        return nil unless start_year.present? && end_year.present?

        errors.add :end_year, :invalid unless PPA::Biennium.valid? [start_year, end_year]
      end

    end

  end
end
