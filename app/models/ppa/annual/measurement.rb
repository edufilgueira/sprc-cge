require_dependency 'ppa/annual/measurement_period_adapter'

module PPA
  module Annual
=begin

  Define registros que representam métricas a serem acompanhadas, com dados de "previsto" e
"realizado", anualmente por período!
- define o `enum :period` - que contempla períodos relativos a um ano
- define validações básicas dos atributos `expected` (previsto) e `actual` (realizado)
- define validação de unicidade com associação-mãe

> Model especialmente criado para medições de Orçamento de Iniciativas e Execução Física de
> Produtos do PPA.

  Basicamente, transforma:
```ruby
module PPA
  moduel Annual
    class MyModel < ApplicationRecord
      belongs_to :product

      enum period: { until_march: 1, until_june: 2, until_september: 3, until_december: 4 }

      validates :expected, numericality: { greater_than_or_equal_to: 0 }
      validates :actual,   numericality: { greater_than_or_equal_to: 0 }
      validate  :expected_and_actual_cannot_be_both_zero

      validates :product, presence: true

      # uniqueness
      validates :product_id, uniqueness: { scope: :period }
    end
  end
end
```

  Em:
```ruby
module PPA
  module Annual
    class MyModel < Annual::Measurement
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
      extend MeasurementPeriodAdapter

      self.abstract_class = true

      # TODO isolar PPA::Measurement sem o enum :period, e fazer Annual::Measurement < Measurement,
      # adicionando o enum :period
      enum period: {
        until_march:     1,
        until_june:      2,
        until_september: 3,
        until_december:  4
      }

      # XXX permitindo período "não sabido" como nil - "Sem Período Concluído para o Ano"
      # validates :period, presence: true
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
        # class MyClass < PPA::Annual::Measurement
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
          validates @measures_foreign_key, uniqueness: { scope: :period }
        end



        # scope methods
        # --

        def in_period(period)
          where period: period
        end

        def in_latest_period
          in_period latest_period
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
          order(period: :desc).first
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


        # helpers
        # --

        def latest_period
          order(period: :desc).first&.period
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
