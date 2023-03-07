module PPA
  class Theme < ApplicationRecord
    include BienniallyRegionalizable
    include ::Disableable

    biennially_regionalizable_by :biennial_regional_strategies

    belongs_to :axis

    has_many :theme_strategies, dependent: :destroy
    has_many :strategies, through: :theme_strategies
    has_many :regional_strategies, through: :strategies
    has_many :objectives, through: :strategies
    has_many :region_themes, class_name: 'PPA::Revision::Review::RegionTheme'

    has_many :annual_regional_strategies, through: :strategies
    has_many :biennial_regional_strategies, through: :strategies
    has_many :proposals

    validates :axis, presence: true
    validates :code, presence: true, uniqueness: { scope: :axis_id }
    validates :name, presence: true

    delegate :name, to: :axis, prefix: true

    default_scope { enabled }

    #codigos sem relatório de atividades
    NO_REPORT_ACTIVITIES = [
      "2.3",
      "2.5"
    ]


    def self.no_report_activities
      NO_REPORT_ACTIVITIES
    end
  end
end
