class Transparency::Sou::SesaOmbudsmenController < TransparencyController
  include Transparency::Sou::Ombudsmen::BaseController

  layout 'application'

  helper_method [
    :sesa_ombudsmen
  ]

  # Helper methods

  def sesa_ombudsmen
    paginated_resources
  end

  private

  def resource_klass
    ::SesaOmbudsman
  end
end
