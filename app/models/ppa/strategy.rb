module PPA
  class Strategy < ApplicationRecord
    include AnnuallyRegionalizable
    include BienniallyRegionalizable
    include ::Disableable

    annually_regionalizable_by   :annual_regional_strategies
    biennially_regionalizable_by :biennial_regional_strategies

    belongs_to :objective

    has_many :theme_strategies
    has_many :themes, through: :theme_strategies
    has_many :regional_strategies, class_name: 'PPA::Revision::Review::RegionalStrategy'

    has_many :initiative_strategies, dependent: :destroy
    has_many :initiatives, through: :initiative_strategies
    has_many :products, through: :initiatives

    has_many :strategies_vote_item, dependent: :destroy

    # annual associations
    has_many :annual_regional_strategies, dependent: :destroy, class_name: 'PPA::Annual::RegionalStrategy'
    has_many :annual_regional_initiatives, through: :initiatives
    has_many :annual_regional_products, through: :products

    # biennial associations
    has_many :biennial_regional_strategies, dependent: :destroy, class_name: 'PPA::Biennial::RegionalStrategy'
    has_many :biennial_regional_initiatives, through: :initiatives
    has_many :biennial_regional_products, through: :products

    validates_presence_of :code
    validates_presence_of :name

    validates_uniqueness_of :code, case_sensitive: false

    default_scope { enabled }
  end
end
