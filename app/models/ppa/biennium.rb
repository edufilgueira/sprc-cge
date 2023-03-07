#
# Encapsulates a array with two integers
# to represent a PPA::Plan biennium
#
class PPA::Biennium

  class << self
    def current
      current! rescue nil
    end

    def current!
      from! Date.today.year
    end

    #
    # Cria um biênio a partir de um ano, verificando o biênio correto para os Planos do PPA
    # (PPA::Plan) disponíveis.
    #
    # @param [Integer] year ano desejado
    #
    # @return [PPA::Biennium] biênio relacionado ao ano, em um Plano disponível
    #
    def from(year)
      from! year rescue nil
    end

    def from!(year)
      plan = PPA::Plan.find_by_year! year

      distance = (year - plan.start_year).abs

      biennium_start_year = case distance
                            when 0, 1 then plan.start_year
                            else plan.start_year + 2
                            end

      new("#{biennium_start_year}-#{biennium_start_year.next}")
    end


    def valid?(value) # helper to validate bienniums
      # usando a validação do construtor
      biennium = new value rescue nil

      !!biennium # se construiu um biênio, então é válido
    end
  end

  attr_accessor :years

  def initialize(value)
    @years = case value
             when String
               raise ArgumentError, <<~ERR unless value.strip.match /\A[0-9]{4}-[0-9]{4}\z/
                 Invalid String format on #{value.inspect}.
                   - Use "\#\{start_year\}-\#\{end_year\}" (e.g. "2018-2019").
               ERR

               value.strip.split('-').map &:to_i

             when Array
               raise ArgumentError, <<~ERR unless value.size == 2 && value.map(&:to_s).all? { |v| v =~ /\A\d+\z/ }
                 Invalid Array format on #{value.inspect}.
                   - Use [start_year, end_year] (e.g. [2016, 2017]).
               ERR

               value.map &:to_i

             when Hash
               raise ArgumentError, <<~ERR unless value.key?(:start_year) && value.key?(:end_year)
                 Invalid Hash format on #{value.inspect}.
                   - Use { start_year: Integer, end_year: Integer ] (e.g. { start_year: 2016, end_year: 2017 }).
               ERR

               [value[:start_year], value[:end_year]]

             when self.class # PPA::Biennium
               value.years.dup

             else
              raise ArgumentError, "Can't create a Biennium from #{value.inspect}"
             end

    years_distance = @years.last - @years.first
    raise ArgumentError, <<~ERR if years_distance != 1
      Years #{@years} are not consecutive, composing a biennium.
    ERR
  end

  def plan
    @plan ||= PPA::Plan.find_by_biennium self
  end

  def start_year
    @years.first
  end
  alias first      start_year
  alias first_year start_year

  def end_year
    @years.last
  end
  alias second      end_year
  alias second_year end_year
  alias last        end_year
  alias last_year   end_year


  def beginning_date
    Date.new first_year, 1, 1
  end

  def ending_date
    Date.new last_year, 12, 31
  end


  def to_a
    @years
  end

  def to_s
    @years.join('-')
  end

  def ==(other)
    other.class == self.class && other.years == years
  end

end
