#
# Planos plurianuais
#
module PPA
  class Plan < ApplicationRecord
    enum status: {
      elaborating: 0,
      monitoring: 1,
      evaluating: 2,
      revising: 3
    }

    DURATION = 4 # in years

    has_many :workshops
    has_many :proposals, dependent: :destroy
    has_many :proposal_themes
    has_many :votings
    has_many :revision_schedules, class_name: 'PPA::Revision::Schedule'

    has_many :axes
    has_many :themes, through: :axes
    has_many :theme_strategies, through: :themes
    has_many :strategies, through: :theme_strategies

    has_many :strategies_vote_item, through: :strategies
    has_many :strategies_vote, through: :strategies_vote_item

    validates :start_year, :end_year,
      presence: true,
      numericality: { only_integer: true },
      uniqueness: true

    validates_with PPA::PlanValidator

    # Scopes

    scope :sorted, -> { order(end_year: :desc) }

    def self.current
      find_by_year Date.today.year
    end

    def self.find_by_biennium(biennium)
      biennium = Biennium.new biennium

      where(
        arel_table[:start_year].lteq(biennium.first_year).and(
          arel_table[:end_year].gteq(biennium.second_year)
        )
      ).first
    end

    def self.find_by_year(year)
      find_by_year! year rescue nil
    end

    def self.find_by_year!(year)
      where('? BETWEEN ppa_plans.start_year AND ppa_plans.end_year', year).first!
    end

    def name
      "#{start_year} - #{end_year}"
    end


    def bienniums
      [Biennium.new([start_year, start_year+1]), Biennium.new([end_year-1, end_year])]
    end

    def duration
      start_year..end_year
    end

    def duration_as_text
      "#{start_year}-#{end_year}"
    end

    def end_date
      Date.parse("#{end_year}-12-31")
    end

    def open_for_proposals?(at = Date.today, region)
      open_regions = proposal_themes.find_by_region_id(region.id)
      return false unless open_regions

      date = at.is_a?(String) ? Date.parse(at) : at

      # raise open_regions.start_in.inspect
      # raise open_regions.start_in.inspect
      # Mon, 22 Apr 2019

      open_regions.start_in <= date && open_regions.end_in >= date
    end


    def in_time_to_prioritization_regional_strategies?
      revision_schedules_per_stage_in_time(:prioritization_regional_strategies)
    end

    def in_time_to_revision_problem_situation?
      revision_schedules_per_stage_in_time(:review_regional_guidelines)
    end

    def in_time_to_evaluation?
      revision_schedules_per_stage_in_time(:process_evaluation)
    end

    def revision_schedules_per_stage_in_time(stage)
      revision_schedules
        .where(stage: stage)
        .where("start_in <= ? and end_in >= ?", Date.today, Date.today)
        .exists?
    end
  end
end
