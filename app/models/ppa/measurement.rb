module PPA
=begin

  Define registros que representam métricas a serem acompanhadas por toda a duração do PPA, ou seja,
a agregação total dos dados ao longo dos 4 anos.
- define validações básicas dos atributos `expected` (previsto) e `actual` (realizado)
- define validação de unicidade com associação-mãe

> Model especialmente criado para medições de Orçamento de Iniciativas e Execução Física de
> Produtos do PPA.

  Basicamente, transforma:
```ruby
module PPA
  class MyModel < ApplicationRecord
    belongs_to :product

    validates :expected, numericality: { greater_than_or_equal_to: 0 }
    validates :actual,   numericality: { greater_than_or_equal_to: 0 }
    validate  :expected_and_actual_cannot_be_both_zero

    validates :product, presence: true

    # uniqueness
    validates :product_id, uniqueness: true
  end
end
```

  Em:
```ruby
module PPA
  class MyModel < Measurement
    measures :product
  end
end
```

  Além disso, fornece alguns métodos de cálculo:
- `::total`          - calcula o total _realizado_ (`actual`) no período desejado
- `::expected_total` - calcula o total _previsto_ (`expected`) no período desejado

=end
  class Measurement < ApplicationRecord
    self.abstract_class = true

    validates :expected, numericality: { greater_than_or_equal_to: 0 }
    validates :actual,   numericality: { greater_than_or_equal_to: 0 }
    validate  :expected_and_actual_cannot_be_both_zero


    class << self
      attr_reader :measurement_metadata

      #
      # Setup method
      #
      # usage:
      # ```ruby
      # class MyClass < PPA::Measurement
      #   measures :owner # , **options if needed
      # end
      # ```
      #
      def measures(association, uniqueness: true, **options)
        @measurement_metadata ||= {}
        metadata = @measurement_metadata # alias dentro do método

        metadata[:uniqueness] = uniqueness

        belongs_to association, **options

        # recuperando metadados por reflection
        reflection = reflections[association.to_s]
        metadata[:association_name]  = association.to_sym
        metadata[:association_class] = reflection.klass
        metadata[:foreign_key]       = reflection.foreign_key.to_sym

        # criando alias para a associação
        alias_attribute :measures, metadata[:association_name]

        # validações relacionadas à associação da medida
        validates metadata[:association_name], presence: true

        # uniqueness validation
        if uniqueness
          medatada[:uniqueness_scope] = uniqueness[:scope] if uniqueness.respond_to?(:key?) && uniqueness.key?(:scope)

          validates metadata[:foreign_key], uniqueness: uniqueness
        end
      end


      # calculation methods
      # --

      def expected_total
        sum :expected
      end

      def total
        sum :actual
      end


      # finder methods
      # --
      def least_expected_valuable
        order(expected: :asc).first
      end

      def least_valuable
        order(actual: :asc).first
      end

      def most_expected_valuable
        order(expected: :desc).first
      end

      def most_valuable
        order(actual: :desc).first
      end

    end # end class methods


    private

    def expected_and_actual_cannot_be_both_zero
      return unless expected.present? && expected.zero? &&
                    actual.present? && actual.zero?

      errors.add :expected, :greater_than, count: 0
      errors.add :actual,   :greater_than, count: 0
    end

  end
end
