#
# Controlador base para as ferramentas de Administração do PPA
#
module PPA
  class AdminController < ::PPAController
    include ::PaginatedController
    include ::SortedController
    include ::FilteredController

    layout 'ppa/admin'

    before_action :authenticate_ppa_admin!

    helper_method [
      :namespace
    ]


    # Helper methods

    def namespace
      :'ppa/admin'
    end
  end
end
