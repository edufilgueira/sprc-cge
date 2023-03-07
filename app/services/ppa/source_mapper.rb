module PPA
=begin

  Orquestrador dos SourceMappers, garantindo a ordem e otimizando a execução na medida do possível.

  Ainda, é um entry-point simples para controle dos dados:
```ruby
PPA::SourceMapper.map_all
```

=end
  module SourceMapper
    extend self

    def destroy_all
      PPA::Axis.destroy_all
      PPA::Objective.destroy_all
      PPA::Initiative.destroy_all
      # the rest goes away with dependent: :destroy
    end

    def map_all
      SourceMappers::RegionSourceMapper.map_all

      PPA::Source::CityRegion.find_each do |source|
        SourceMappers::CityRegionSourceMapper.map source
      end

      # SourceMappers::AxisSourceMapper.map_all
      # SourceMappers::ThemeSourceMapper.map_all
      # --
      # otimizando numa iteração sobre o escopo:
      PPA::Source::AxisTheme.find_each do |source|
        SourceMappers::AxisSourceMapper.map source
        SourceMappers::ThemeSourceMapper.map source
      end

      # SourceMappers::ObjectiveSourceMapper.map_all
      # SourceMappers::StrategySourceMapper.map_all
      # SourceMappers::InitiativeSourceMapper.map_all
      # SourceMappers::ProductSourceMapper.map_all
      # --
      # otimizando numa iteração sobre o escopo:
      PPA::Source::Guideline.find_each do |source|
        SourceMappers::ObjectiveSourceMapper.map source
        SourceMappers::StrategySourceMapper.map source
        SourceMappers::InitiativeSourceMapper.map source
        SourceMappers::ProductSourceMapper.map source
      end
    end

  end
end
