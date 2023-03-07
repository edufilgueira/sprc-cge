module PPA
=begin

  Orquestrador dos Calculators, garantindo a ordem e otimizando a execução na medida do possível.

  Ainda, é um entry-point simples para o processamento dos dados:
```ruby
PPA::Calcualtor.calculate_all
```

=end
  module Calculator
    extend self

    def calculate_all
      # initiative calculators
      Calculators::Annual::RegionalInitiativeBudgetCalculator.calculate_all
      Calculators::Biennial::RegionalInitiativeBudgetCalculator.calculate_all
      # quadrennial
      Calculators::RegionalInitiativeBudgetCalculator.calculate_all

      # product calculators
      Calculators::Biennial::RegionalProductGoalCalculator.calculate_all
      Calculators::RegionalProductGoalCalculator.calculate_all


      # counters
      calculate_counts
    end


    def calculate_counts
      # e mais alguns cálculos de "counter cache"
      # --

      PPA::Biennial::RegionalStrategy.find_each do |strategy|
        strategy.calculate_initiatives_count!
        strategy.calculate_products_count!
      end
    end


    def destroy_all
      # annual
      PPA::Annual::RegionalInitiativeBudget.destroy_all

      # biennial
      PPA::Biennial::RegionalInitiativeBudget.destroy_all
      PPA::Biennial::RegionalProductGoal.destroy_all

      # quadrennial
      PPA::RegionalInitiativeBudget.destroy_all
      PPA::RegionalProductGoal.destroy_all
    end

  end
end
