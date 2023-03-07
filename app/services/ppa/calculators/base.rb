module PPA::Calculators
=begin

  Classe base para criação de Calculators, que têm o intuito de processar/calcular dados a partir
de dados/registros pré-existentes.

  Para isso, baseia-se no pattern Command, através dos métodos `::calculate` e `#calculate` para
execução (que possuem `call` como _alias_, caso prefira).

  Ainda, é necessário definir as classes _source_ - da entrada de dado - para verificações
automáticas de dados.

  No contexto de instância, você tem acesso a #source que representa a instância da classe _source_
que é o _seed_ do processamento. Assim, basta implementar o método `#calculate` para executar o
cálculo/processamento.

usage
----

Defina seu Calculator:
```ruby
class MyCalculator < Calculators::Base
  source MySourceClass

  def calculate
    # source is an instance of MySourceClass

    something = MyTargetClass.new
    something.name = source.nome
    something.value = source.valor * (1 + source.juros)

    sum = something.budgets.sum :expected

    source.update! total: sum
  end
end
```

E use-o:
```ruby
source = MySourceClass.find id
MyCalculator.calculate source
```

## Cálculo "em lote":
  Utilize o método `::calculate_all` para iterar sobre um _escopo_ (ActiveRecord) e invocar
`#calculate` em cada uma das instâncias:
```ruby
MyCalculator.calculate_all
# é o mesmo que fazer:
# MySourceClass.find_each { |source| MyCalculator.calculate source }
```

Ainda, se quiser _recortar_ o conjunto a ser _calculado_, use a opção `scope:`:
```ruby
MyMapper.calculate_all scope: MySourceClass.active_only
# é o mesmo que fazer:
# MySourceClass.active_only.find_each { |source| MyCalculator.calculate source }
```

**IMPORTANTE**: o método `::calculate_all` faz uso de `ActiveRecord::Scope#find_each`, que usa a ordenação
por `id` (primary_key) para processamento em lotes.

Assim, caso precise de um escopo com ordenação própria, use a opção `with:`:
```ruby
MyCalculator.calculate_all scope: custom_scope, with: :each
# é o mesmo que fazer:
# custom_scope.each { |source| MyCalculator.calculate source }
```

=end
  class Base
    #
    # Módulo que inclui um hook no método #calculate (executor do comando) com verificação
    # de #blacklisted?
    # IMPORTANT esse módulo é prepended ao estender Base, ou seja, ao definir:
    # `MeuCalculator < SourceMappers::Base`
    #
    module BlacklistingHookOnMap
      def calculate
        return if blacklisted?
        super
      end
    end

    # Prints a helping message when an error occurs on #calculate, with SourceMapper class name and
    # #calculate source argument class name and id, if available
    module PrettyErrorMessageLogging
      def calculate
        super
      rescue => err
        logger.error <<~LOG
          #{self.class.name} calculating with #{attributes} #{"and options #{options}" if options.present?}
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

      attr_accessor :logger

      def calculate(*args)
        new(*args).calculate
      end
      alias call           calculate
      alias calculate_with calculate

      def calculate_all(scope: default_scope, with: :each)
        # doing `scope.each do ...`
        scope.public_send(with) do |source|
          calculate *Array.wrap(source)
        end
      end
      alias call_all           calculate_all
      alias calculate_all_with calculate_all


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

        # getter - escopo deve ter sido pré-definido
        raise RuntimeError, <<~ERR unless @default_scope
          #{self.name} default_scope not define yet. Ensure the ::default_scope method is used on class definition.
        ERR

        # executando escopo
        @default_scope.call
      end

      def default_scope_iterator(method = nil)
        @default_scope_iterator ||= :each # default value
        @default_scope_iterator = method unless method.nil?

        @default_scope_iterator
      end


      def attributes(*names)
        @attributes ||= []
        return @attributes if names.blank?

        names.each do |name|
          name = name.to_sym
          @attributes << name unless @attributes.include? name

          define_method(name) { attributes[name] }
          define_method("#{name}=") { |value| attributes[name] = value }
        end
      end

      def attribute_names
        @attributes.keys.sort
      end


      def logger
        @logger ||= Logger.new(STDOUT).tap do |logger|
          # avoiding logs in test environment
          logger.level = Logger::UNKNOWN if Rails.env.test?
        end
      end

    end # class methods


    attr_reader :options, :attributes, :target

    delegate :logger, to: :class

    def initialize(attributes = {}, options = {})
      @attributes = attributes
      @options    = options

      after_initialize
    end

    def calculate
      raise NotImplementedError
    end
    alias call calculate

    # Sobrecarregue esse método para definir lógica própria de blacklisting
    def blacklisted?
      false
    end


    private

    # override it for custom behavior
    def after_initialize; end

  end
end
