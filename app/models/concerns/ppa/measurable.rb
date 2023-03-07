module PPA
=begin

  Define comportamento de cálculos de medidas (PPA::Measurement) associadas.


  Setup:
```ruby
module PPA
  class MyModel < ApplicationRecord
    include Measurable

    measurable_from :budgets

    has_many :budgets

    # ...
  end
end
```

  Ao incluir o concern e _definir_ (setup) a associação que contém as métricas, define métodos
de cálculo como:
- `::total`
- `::expected_total`

=end
  module Measurable
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :measurable_metadata,
                  :measurable_association_name,
                  :measurable_association_class,
                  :measurable_foreign_key


      #
      # Setup method
      #
      # usage:
      # ```ruby
      # measurable_from :products
      # ```
      #
      def measurable_from(association)
        # reseta o metadata, permintindo redefinições (com herança/mixin)
        @measurable_metadata = {}
        measurable_metadata[:association_name] = association.to_sym
      end

      def measurable_association_name
        measurable_metadata[:association_name]
      end

      # lazily evaluated association class
      def measurable_association_class
        measurable_metadata[:association_class] ||= begin
          reflection = reflections[measurable_metadata[:association_name].to_s]
          reflection.klass
        end
      end

      # lazily evaluated association foreign key
      def measurable_foreign_key
        measurable_metadata[:foreign_key] ||= begin
          reflection = reflections[measurable_metadata[:association_name].to_s]
          reflection.foreign_key
        end
      end


      # calculation methods
      # --

      def total
        sum_in metric: :actual
      end

      def expected_total
        sum_in metric: :expected
      end


      private

      def sum_in(metric:)
        raise ArgumentError, <<~ERR unless %i[expected actual].include? metric
          #{metric.inspect} is not a valid metric attribute.
          - possible values: :expected, :actual (PPA::Measurement values)
        ERR

        association_table = measurable_association_class.arel_table

        joins(measurable_from_association_name)
          .sum(association_table[metric])
      end

    end # end class methods

  end

end
