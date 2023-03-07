require_dependency 'ppa/source_mapper'
require_dependency 'ppa/calculator'

module PPA
=begin

  Orquestrador de todo o processamento de dados referentes ao PPA pós-importação dos dados brutos
via webservice.
  Garante a execução correta - respeitando dependência de dados - de todos os SourceMappers e
Calculators do PPA, além de processamentos simples também embutidos.

  Ainda, é um entry-point simples para controle dos dados:
```ruby
# para processar todos os dados pós-importação
PPA::DataLoader.load_all

# para apagar todos os dados processados
PPA::DataLoader.destroy_all

# assim, para _resetar_ os dados processados do PPA, faça

PPA::DataLoader.destroy_all
PPA::DataLoader.load_all
```

- Para mais informações sobre como importar dados do webservice, veja:
  + https://github.com/caiena/sprc-data/wiki/ppa-import
- Para mais informações sobre o processamento dos dados pós-importação, veja:
  + https://github.com/caiena/sprc/wiki/ppa-import

=end
  module DataLoader
    extend self

    def destroy_all
      SourceMapper.destroy_all
      Calculator.destroy_all
    end

    def load_all
      SourceMapper.map_all
      Calculator.calculate_all
    end

  end
end
