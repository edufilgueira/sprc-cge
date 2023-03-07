class PPA::Revision::Review::RegionalStrategy < ApplicationRecord
  belongs_to :region_theme
  belongs_to :strategy, class_name: 'PPA::Strategy'
end
