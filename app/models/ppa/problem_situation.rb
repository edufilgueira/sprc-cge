module PPA
  class ProblemSituation < ApplicationRecord
    
    validates :axis, :theme, :region, :situation, presence: true
    validates :isn_solucao_problema, uniqueness: true

    belongs_to :situation 
    belongs_to :theme
    belongs_to :axis
    belongs_to :region
    
  end
end
