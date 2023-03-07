class PPA::ThemeStrategy < ApplicationRecord

  belongs_to :theme
  belongs_to :strategy

  validates :strategy, presence: true
  validates :theme, presence: true

end
