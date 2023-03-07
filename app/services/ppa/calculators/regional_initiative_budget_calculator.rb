module PPA::Calculators
=begin

  Agrega valores de orçamento quadrienais (duração total do PPA) para Iniciativas, baseando-se em
dados pré-existentes de Orçamentos bienais!

@see PPA::Calculators::Biennial::RegionalInitiativeBudgetCalculator

=end
  class RegionalInitiativeBudgetCalculator < Base
    # default scope para cálculo de TODOS os orçamentos quadrienais!
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
    #   Calcula, criando ou atualizando registros de PPA::RegionalInitiativeBudget,
    # que representam os orçamentos de Iniciativas "totais" (duração total dos 4 anos).
    #
    #   Para isso, agrega dados existentes em PPA::Biennial::RegionalInitiativeBudget, que fornecem
    # valores já consolidados por biênio e região.
    #
    def calculate
      initiatives.find_each do |initiative|
        regional_initiative = initiative.regional_initiatives.in_region(region).first!
        expected = 0
        actual = 0

        bienniums.each do |biennium|
          biennial_regional_initiative = initiative.biennial_regional_initiatives
            .in_biennium_and_region(biennium, region).first

          # pode ser que a iniciativa tenha sido revista e removida do PPA para o sergundo biênio
          next unless biennial_regional_initiative

          biennial_budget = biennial_regional_initiative.budgets.first

          expected += biennial_budget&.expected || 0
          actual   += biennial_budget&.actual || 0
        end

        next if expected.zero? && actual.zero? # XXX ignora orçamentos zerados

        create_or_update_budget_for! regional_initiative, expected: expected, actual: actual
      end
    end


    protected

    def bienniums
      @bienniums ||= [
        PPA::Biennium.new([quadrennium.first, quadrennium.first + 1]),
        PPA::Biennium.new([quadrennium.last - 1, quadrennium.last])
      ]
    end

    def initiatives
      # XXX não há recorte temporal aqui! faremos o recorte temporal no agregador de orçamentos!
      PPA::Initiative.in_region region
    end

    def create_or_update_budget_for!(regional_initiative, **attrs)
      budget = regional_initiative.budgets.first_or_initialize
      budget.attributes = attrs
      budget.save! # if budget.new_record? || budget.changed?
    end

  end
end
