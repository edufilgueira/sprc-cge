#
# PPA::Attachment is the parent class for all
# kinds of assets in PPA.
#
class PPA::Attachment < ApplicationRecord

  belongs_to :uploadable, polymorphic: true

  validates :attachment_filename, presence: true

end
