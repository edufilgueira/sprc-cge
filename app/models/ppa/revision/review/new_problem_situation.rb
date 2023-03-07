class PPA::Revision::Review::NewProblemSituation < ApplicationRecord

  belongs_to :region_theme
  belongs_to :city, class_name: 'PPA::City'
  
end
