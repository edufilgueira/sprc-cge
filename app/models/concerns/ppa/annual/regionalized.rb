module PPA
  module Annual
=begin

  Define comportamento de um model Anual que seja classificado por Região.
  - belongs_to association
  - belongs_to :region
  - validates association and :region presence
  - validates uniqueness in region, year


  E adiciona escopos de recorte por região no ano:
  - in_region(region)
  - in_year_and_region(year, region)
  - current_in_region(region)


  Setup:
```ruby
module PPA
  module Annual
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
        #   module Annual
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
          validates :year, presence: true, numericality: { only_integer: true, greater_than: 1900 }

          # uniqueness validation
          validates @regionalizes_foreign_key, uniqueness: { scope: %i[year region_id] }
        end


        # scope methods
        # --

        def in_year(year)
          where year: year
        end
        alias by_year in_year

        def in_region(region)
          where region_id: region
        end
        alias by_region in_region

        #
        # Recupera os registros a partir de um ano e uma região
        #
        # @param [Integer] year Ano a ser recortado
        # @param [PPA::Region,Integer] region região do recorte
        #
        # @return [ActiveRecord::Relation] Relação/escopo com o recorte aplicado
        #
        def in_year_and_region(year, region)
          in_year(year).in_region(region)
        end
        alias by_year_and_region in_year_and_region

      end # end class methods

    end

  end
end
