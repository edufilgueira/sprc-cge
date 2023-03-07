#
# Representa o model básico da aplicação. Todos os models herdam de
# ApplicationRecord.
#

class ApplicationRecord < ActiveRecord::Base
  include EnumLocalizable

  self.abstract_class = true
end
