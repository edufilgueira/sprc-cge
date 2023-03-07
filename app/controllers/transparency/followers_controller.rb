class Transparency::FollowersController < TransparencyController

  helper_method :transparency_follower

  PERMITTED_PARAMS = [
    :email,
    :transparency_link,
    :resourceable_type,
    :resourceable_id
  ]

  # subscribe
  def create
    if resource_save
      render partial: view_path('show'), locals: { resource: resource }
    else
      render partial: view_path('form'), locals: { resource: resource }
    end
  end

  def show
    render partial: view_path('show'), layout: false, locals: { resource: resource }
  end

  def edit
    render view_path('edit')
  end

  # unsubscribe
  def update
    transparency_follower.mark_as_unsubscribed

    render view_path('edit')
  end

  def transparency_follower
    resource
  end


  # private

  private

  def resource_params
    if params[:transparency_follower]
      params.require(:transparency_follower).permit(PERMITTED_PARAMS)
    end
  end

  def resource_klass
    Transparency::Follower
  end

  def view_path(view)
    "shared/transparency/followers/#{view}"
  end
end
