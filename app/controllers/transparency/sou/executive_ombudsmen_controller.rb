class Transparency::Sou::ExecutiveOmbudsmenController < TransparencyController
  include Transparency::Sou::Ombudsmen::BaseController

  layout 'application'

  helper_method [
    :executive_ombudsmen
  ]


  # Helper methods

  def executive_ombudsmen
    paginated_resources
  end

  private

  def resource_klass
    ::ExecutiveOmbudsman
  end
end
