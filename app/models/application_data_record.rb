#
# Representa o model básico de dados da aplicação. Todos os models relacionados
# à integração de transparência herdam de ApplicationDataRecord
#

class ApplicationDataRecord < ApplicationRecord
  self.abstract_class = true
  establish_connection DATA_DATABASE_CONFIG

end
