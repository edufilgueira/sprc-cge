module PPA::SourceMappers
=begin

  Classe base para criação de SourceMappers, que têm o intuito de transformar uma classe (source)
em outra (target).
  Para isso, baseia-se no pattern Command, através dos métodos `::map` e `#map` para execução
(que possuem `call` como _alias_, caso prefira).
  Ainda, é necessário definir as classes _source_ e _target_ para verificações automáticas de dados.

  No contexto de instância, você tem acesso a #source que representa a instância da classe _source_
a ser "traduzida" para a classe _target_. Assim, basta implementar o método `#map` para fazer a
"tradução".

usage
----

Defina seu SourceMapper:
```ruby
class MyMapper < SourceMappers::Base
  maps MySourceClass, to: MyTargetClass

  def map
    target = MyTargetClass.new
    target.name = source.nome
    target.value = source.valor * (1 + source.juros)

    target.save!
  end
end
```

E use-o:
```ruby
source = MySourceClass.find id
MyMapper.map source
```

## Mapeamento "em lote":
  Utilize o método `::map_all` para iterar sobre um _escopo_ (ActiveRecord) e invocar `#map` em cada
uma das instâncias:
```ruby
MyMapper.map_all
# é o mesmo que fazer:
# MySourceClass.find_each { |source| MyMapper.map source }
```

Ainda, se quiser _recortar_ o conjunto a ser _mapeado_, use a opção `scope:`:
```ruby
MyMapper.map_all scope: MySourceClass.active_only
# é o mesmo que fazer:
# MySourceClass.active_only.find_each { |source| MyMapper.map source }
```

**IMPORTANTE**: o método `::map_all` faz uso de `ActiveRecord::Scope#find_each`, que usa a ordenação
por `id` (primary_key) para processamento em lotes.

Assim, caso precise de um escopo com ordenação própria, use a opção `with:`:
```ruby
MyMapper.map_all scope: custom_scope, with: :each
# é o mesmo que fazer:
# custom_scope.each { |source| MyMapper.map source }
```

=end
  class Base
    #
    # Módulo que inclui um hook no método #map (executor do comando) com verificação
    # de #blacklisted?
    # IMPORTANT esse módulo é prepended ao estender Base, ou seja, ao definir:
    # `MeuMapper < SourceMappers::Base`
    #
    module BlacklistingHookOnMap
      def map
        return if blacklisted?
        super
      end
    end

    # Prints a helping message when an error occurs on #map, with SourceMapper class name and
    # #map source argument class name and id, if available
    module PrettyErrorMessageLogging
      def map
        super
      rescue => err
        logger.error <<~LOG
          #{self.class.name} calculating #{source.class.name}<id=#{source.try(:id)}> #{"with options #{options}" if options.present?}
        LOG
        raise err # re-raise
      end
    end

    class << self
      # ensuring blacklisting works on child classes
      # @see https://stackoverflow.com/a/40014327
      def inherited(base_class)
        base_class.prepend BlacklistingHookOnMap
        base_class.prepend PrettyErrorMessageLogging
        super
      end

      attr_reader :source_class, :target_class
      attr_accessor :logger

      def maps(source_class, to:)
        @source_class = source_class
        @target_class = to
      end

      def map(*args)
        new(*args).map
      end
      alias call map

      def map_all(scope: default_scope, with: default_scope_iterator)
        # doing `scope.find_each do ...`
        scope.public_send(with) do |source_record|
          map source_record
        end
      end
      alias call_all map_all

      #
      # Get/set default scope
      #
      # getter:
      # - call it with no args!
      # ```ruby
      # default_scope
      # ```
      #
      # setter:
      # - call it passing a block which defines the default_scope
      # ```
      # class MyCalculator < Calculators::Base
      #   default_scope -> { MyRecord.available_only }, with: :each
      # end
      # ```
      #
      def default_scope(lambda = nil, with: nil, &block)
        # permitindo definição por lambda (primeiro arg) ou bloco (último arg)
        lambda = block if lambda.nil? && block_given?
        default_scope_iterator with unless with.nil?

        if lambda.present? # setter
          @default_scope = lambda
          return
        end

        # getter
        #
        @default_scope ||= -> { all } # ensuring defaut value
        # como é executado no contexto da source class, é equivalente a:
        # { source_class.all }

        # executando o escopo no contexto da source class
        source_class.class_exec &@default_scope
      end

      def default_scope_iterator(method = nil)
        @default_scope_iterator ||= :find_each # default value
        @default_scope_iterator = method unless method.nil?

        @default_scope_iterator
      end


      def logger
        @logger ||= Logger.new(STDOUT).tap do |logger|
          # avoiding logs in test environment
          logger.level = Logger::UNKNOWN if Rails.env.test?
        end
      end
    end


    attr_reader :options, :source, :target

    delegate :source_class, :target_class, to: :class
    delegate :logger, to: :class

    def initialize(source, **options)
      raise RuntimeError, <<~ERR unless source_class && target_class
        #{self.class.name} not configured yet. Ensure the ::maps method is used on class definition.
      ERR

      raise TypeError, <<~ERR unless source.is_a?(source_class)
        #{source.inspect} must be an instance of #{source_class.name}
      ERR

      @source  = source
      @options = options
    end

    def map
      raise NotImplementedError
    end
    alias call map

    # Sobrecarregue esse método para definir lógica própria de blacklisting
    def blacklisted?
      false
    end

  end
end
