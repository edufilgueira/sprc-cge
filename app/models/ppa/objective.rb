module PPA
  class Objective < ApplicationRecord
    include BienniallyRegionalizable
    include ::Disableable

    biennially_regionalizable_by :biennial_regional_strategies

    belongs_to :region

    has_many :strategies, dependent: :destroy
    has_many :biennial_regional_strategies, through: :strategies

    validates_presence_of :name
    validates_presence_of :code
    validates_presence_of :region_id

    #validates_uniqueness_of :code


    default_scope { enabled }
  end
end
