#
# Controlador para a Home (página inicial) do PPA
#
module PPA
  class HomeController < ::PPAController
    include PPA::Home::Breadcrumbs

    helper_method :regions, :cities, :last_workshop

    def show; end
    
  end
end