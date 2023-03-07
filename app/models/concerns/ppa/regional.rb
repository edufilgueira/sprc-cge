module PPA
=begin

  Define comportamento de um model "classificado" por Região.
  - belongs_to association
  - belongs_to :region
  - validates association and :region presence


  E adiciona escopos de recorte por região:
  - in_region(region)


  Setup:
```ruby
module PPA
  class MyModel < ApplicationRecord
    include Regional

    regionalizes :parent

    # ...
  end
end
```

=end
  module Regional
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :regional_metadata

      #
      # Setup method
      #
      # usage:
      # ```ruby
      # module PPA
      #   class MyClass < ApplicationRecord
      #     include Regional
      #
      #     regionalizes :parent # , **options if needed
      #   end
      # end
      # ```
      #
      # advanced
      # ---
      # Caso precise _ajustar_ a validação de unicidade adicionando outro atributo no escopo, use:
      # ````ruby
      # module PPA
      #   class MyClass < ApplicationRecord
      #     include Regional
      #
      #     regionalizes :parent, uniqueness: { scope: :classification }
      #
      #     enum classification: { good: 1, bad: 2, ugly: 3 }
      #   end
      # end
      # ```
      #
      # @param [Symbol] association name of the association that is being regionalized by this model
      # @param [Boolean,Hash] uniqueness: Defaults to true.
      # @param [Hash] **options belongs to association options forwarded to association
      #
      def regionalizes(association, uniqueness: true, **options)
        @regional_metadata ||= {}
        metadata = @regional_metadata # alias dentro do método

        metadata[:uniqueness] = uniqueness

        belongs_to association, **options
        belongs_to :region # TODO precisa de `class_name: PPA::Region`?

        # recuperando metadados por reflection
        reflection = reflections[association.to_s]
        metadata[:association_name]  = association.to_sym
        metadata[:association_class] = reflection.klass
        metadata[:foreign_key]       = reflection.foreign_key.to_sym

        # criando alias para a associação
        alias_attribute :regionalizes, metadata[:association_name]

        # validações relacionadas à associação da medida
        validates metadata[:association_name], presence: true
        validates :region, presence: true

        # uniqueness validation
        if uniqueness
          metadata[:uniqueness_scope] = [:region_id]
          if uniqueness.respond_to?(:key?) && uniqueness.key?(:scope)
            metadata[:uniqueness_scope].concat(Array.wrap(uniqueness[:scope]))
          end

          validates metadata[:foreign_key], uniqueness: { scope: metadata[:uniqueness_scope] }
        end
      end


      # scope methods
      # --

      def in_region(region)
        where region_id: region
      end
      alias by_region in_region

    end # end class methods

  end

end
