class PPA::Revision::Review::ProblemSituation < ApplicationRecord

  belongs_to :region_theme
  belongs_to :problem_situation, class_name: 'PPA::ProblemSituation'

  def description
    problem_situation.situation.description
  end
end
