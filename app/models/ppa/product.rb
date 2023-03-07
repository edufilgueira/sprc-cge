module PPA
  class Product < ApplicationRecord
    include AnnuallyRegionalizable
    include BienniallyRegionalizable
    include Regionalizable

    annually_regionalizable_by   :annual_regional_products
    biennially_regionalizable_by :biennial_regional_products
    regionalizable_by            :regional_products

    belongs_to :initiative

    # annual associations
    has_many :annual_regional_products, dependent: :destroy, class_name: 'PPA::Annual::RegionalProduct'
    has_many :annual_regional_goals, through: :annual_regional_products, source: :goals

    # biennial associations
    has_many :biennial_regional_products, dependent: :destroy, class_name: 'PPA::Biennial::RegionalProduct'
    has_many :biennial_regional_goals, through: :biennial_regional_products, source: :goals

    # quadrennial associations (período completo do PPA)
    has_many :regional_products, dependent: :destroy
    has_many :regional_goals, through: :regional_products, source: :goals


    validates :name, presence: true
    validates :code, presence: true, uniqueness: { case_sensitive: false }

  end
end
