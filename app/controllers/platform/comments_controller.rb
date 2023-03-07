class Platform::CommentsController < PlatformController
  include ::Tickets::Comments::BaseController

  def comment_form_url
    [:platform, new_comment]
  end

end
