module PPA::Calculators
=begin

  Agrega valores de metas (execução física) quadrienais (duração total do PPA) para Produtos,
baseando-se em dados pré-existentes de metas (execução física) bienais!

@see PPA::Calculators::Biennial::RegionalProductGoalCalculator

=end
  class RegionalProductGoalCalculator < Base
    # default scope para cálculo de TODAS as metas quadrienais!
    # - para o quadriênio 2016-2019
    # - para todas as regiões
    default_scope -> do
      scope = []

      quadrenniums = [[2016, 2019]]
      regions = PPA::Region.pluck :id

      quadrenniums.each do |quadrennium|
        regions.each do |region|
          scope << { quadrennium: quadrennium, region: region }
          # attributes - params used in Calculator#initialize
          # as `calculate quadrennium: quadrennium, region: region`
        end
      end

      scope
    end

    #
    # atributos do calculador
    #
    # @param [Array<Integer>] quadrennium: [first_year, last_year]
    # @param [PPA::Region,Integer] region: instance or id
    attributes :quadrennium, :region


    # transformando e validando atributos
    def after_initialize
      self.region   = region.is_a?(Numeric) ? PPA::Region.find(region) : region
      bienniums # eager loading to validate it
    end


    #
    #   Calcula, criando ou atualizando registros de PPA::RegionalProductGoal,
    # que representam os metas de Produtos "totais" (duração total dos 4 anos).
    #
    #   Para isso, agrega dados existentes em PPA::Biennial::RegionalProductGoal, que fornecem
    # valores já consolidados por biênio e região.
    #
    def calculate
      products.find_each do |product|
        regional_product = product.regional_products.in_region(region).first!
        expected = 0
        actual = 0

        bienniums.each do |biennium|
          biennial_regional_product = product.biennial_regional_products
            .in_biennium_and_region(biennium, region).first

          # pode ser que o produto tenha sido revisto e removido do PPA para o sergundo biênio
          next unless biennial_regional_product

          biennial_goal = biennial_regional_product.goals.first

          expected += biennial_goal&.expected || 0
          actual   += biennial_goal&.actual || 0
        end

        next if expected.zero? && actual.zero? # XXX ignora metas zeradas

        create_or_update_goal_for! regional_product, expected: expected, actual: actual
      end
    end


    protected

    def bienniums
      @bienniums ||= [
        PPA::Biennium.new([quadrennium.first, quadrennium.first + 1]),
        PPA::Biennium.new([quadrennium.last - 1, quadrennium.last])
      ]
    end

    def products
      # XXX não há recorte temporal aqui! faremos o recorte temporal no agregador de metas!
      PPA::Product.in_region region
    end

    def create_or_update_goal_for!(regional_product, **attrs)
      goal = regional_product.goals.first_or_initialize
      goal.attributes = attrs
      goal.save! # if goal.new_record? || goal.changed?
    end

  end
end
