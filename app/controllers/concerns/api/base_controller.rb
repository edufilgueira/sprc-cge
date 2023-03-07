module Api::BaseController
  extend ActiveSupport::Concern

  included do

    before_action :skip_session

  end

  # Helper methods

  ## Public

  def object_response(object, status = :ok)
    render json: object, status: status
  end

  def object_index_response(object)
    render json: object, status: :ok, action_index: true
  end

  def unauthorized_response
    render json: { message: I18n.t('app.unauthorized_message') }, status: :unauthorized
  end

  def object_paginated_response(results, count_filtered, status = :ok)

    object = {
      results: results,
      count_filtered: count_filtered
    }

    render json: object, status: status
  end


  # Private

  private

  ## Methods

  def skip_session
    # Skip sessions and cookies for api
    request.session_options[:skip] = true
  end

end
