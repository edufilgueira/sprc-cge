module PPA
  module Biennial
=begin

  Define registros que representam métricas a serem acompanhadas, com dados de "previsto" e
"realizado", bienalmente!
- define validações básicas dos atributos `expected` (previsto) e `actual` (realizado)
- define validação de unicidade com associação-mãe

XXX Não há período de referência para valores bienais! Apenas para anuais! (veja Annual::Measurement)

> Model especialmente criado para medições de Orçamento de Iniciativas e Execução Física de
> Produtos do PPA.

  Basicamente, transforma:
```ruby
module PPA
  module Biennial
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
end
```

  Em:
```ruby
module PPA
  module Biennial
    class MyModel < Measurement
      measures :product
    end
  end
end
```

  Além disso, fornece alguns métodos de cálculo:
- `::total`          - calcula o total _realizado_ (`actual`)
- `::expected_total` - calcula o total _previsto_ (`expected`)

  E alguns métodos de _localização_ (find)
- `::latest`  - recupera o registro do _período_ mais recente.

=end
    class Measurement < ApplicationRecord
      self.abstract_class = true

      validates :expected, numericality: { greater_than_or_equal_to: 0 }
      validates :actual,   numericality: { greater_than_or_equal_to: 0 }
      validate  :expected_and_actual_cannot_be_both_zero


      class << self
        attr_reader :measures_association_name,
                    :measures_association_class,
                    :measures_foreign_key

        #
        # Setup method
        #
        # usage:
        # ```ruby
        # class MyClass < PPA::Biennial::Measurement
        #   measures :owner # , **options if needed
        # end
        # ```
        #
        def measures(association, **options)
          belongs_to association, **options

          # recuperando metadados por reflection
          reflection = reflections[association.to_s]
          @measures_association_name  = association.to_sym
          @measures_association_class = reflection.klass
          @measures_foreign_key       = reflection.foreign_key.to_sym

          # criando alias para a associação
          alias_attribute :measures, @measures_association_name

          # validações relacionadas à associação da medida
          validates @measures_association_name, presence: true
          # uniqueness validation
          validates @measures_foreign_key, uniqueness: true
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
        def latest
          # como não há período, recuperamos o mais recente por updated_at
          order(updated_at: :desc).first
        end

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
end
