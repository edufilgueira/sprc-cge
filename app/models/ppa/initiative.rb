module PPA
  class Initiative < ApplicationRecord
    include AnnuallyRegionalizable
    include BienniallyRegionalizable
    include Regionalizable

    annually_regionalizable_by   :annual_regional_initiatives
    biennially_regionalizable_by :biennial_regional_initiatives
    regionalizable_by            :regional_initiatives


    has_many :initiative_strategies, dependent: :destroy
    has_many :strategies, through: :initiative_strategies
    has_many :products, dependent: :destroy

    # annual associations
    has_many :annual_regional_initiatives, dependent: :destroy, class_name: 'PPA::Annual::RegionalInitiative'
    has_many :annual_regional_budgets, through: :annual_regional_initiatives, source: :budgets
    has_many :annual_regional_products, through: :products

    # biennial associations
    has_many :biennial_regional_initiatives, dependent: :destroy, class_name: 'PPA::Biennial::RegionalInitiative'
    has_many :biennial_regional_budgets,  through: :biennial_regional_initiatives, source: :budgets
    has_many :biennial_regional_products, through: :products

    # quadrennial associations (período completo do PPA)
    has_many :regional_initiatives, dependent: :destroy
    has_many :regional_budgets, through: :regional_initiatives, source: :budgets


    validates :name, presence: true
    validates :code, presence: true, uniqueness: { case_sensitive: false }

  end
end
