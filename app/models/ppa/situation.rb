module PPA
  class Situation < ApplicationRecord
    
    validates :description, :isn_solucao, presence: true
    validates :isn_solucao, uniqueness: true

    has_many :problem_situations#, class_name: 'PPA::ProblemSituation', foreign_key: :isn_solucao, primary_key: :isn_solucao
    
  end
end
