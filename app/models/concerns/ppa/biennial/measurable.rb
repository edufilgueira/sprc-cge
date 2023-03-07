module PPA
  module Biennial
=begin

  Define comportamento de cálculos, por ano, de medidas (PPA::Biennial::Measurement) associadas.


  Setup:
```ruby
module PPA
  module Biennial
    class MyModel < ApplicationRecord
      include Measurable

      measurable_from :budgets

      has_many :budgets

      # ...
    end
  end
end
```

  Ao incluir o concern e _definir_ (setup) a associação que contém as métricas, define métodos
de cálculo como:
- `::total_in_biennium`
- `::expected_total_in_biennium`

=end
    module Measurable
      extend ActiveSupport::Concern

      class_methods do
        attr_reader :measurable_from_association_name,
                    :measurable_from_association_class,
                    :measurable_from_foreign_key

        #
        # Setup method
        #
        # usage:
        # ```ruby
        # measurable_from :products
        # ```
        #
        def measurable_from(association)
          @measurable_from_association_name = association.to_sym

          # invalidating memoized values from association metadata, allowing the measurable
          # association to be redefined
          @measurable_from_association_class = nil
          @measurable_from_foreign_key       = nil
        end

        # lazily evaluated association class
        def measurable_from_association_class
          @measurable_from_association_class ||= begin
            reflection = reflections[measurable_from_association_name.to_s]
            reflection.klass
          end
        end

        # lazily evaluated association foreign key
        def measurable_from_foreign_key
          @measurable_from_foreign_key ||= begin
            reflection = reflections[measurable_from_association_name.to_s]
            reflection.foreign_key
          end
        end


        # calculation methods
        # --

        def total_in_biennium(biennium)
          sum_in_biennium biennium, metric: :actual
        end

        def expected_total_in_biennium(biennium)
          sum_in_biennium biennium, metric: :expected
        end


        private

        def sum_in_biennium(biennium, metric:)
          raise ArgumentError, <<~ERR unless %i[expected actual].include? metric
            #{metric.inspect} is not a valid metric attribute.
            - possible values: :expected, :actual (PPA::Measurement values)
          ERR

          association_table = measurable_from_association_class.arel_table
          biennium = PPA::Biennium.new biennium

          joins(measurable_from_association_name)
            .where(
              association_table[:start_year].eq(biennium.start_year).and(
                association_table[:end_year].eq(biennium.end_year)
              )
            )
            .sum(association_table[metric])
        end

      end # end class methods

    end

  end
end
