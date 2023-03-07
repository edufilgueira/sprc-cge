module Api::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      object_response({ message: :not_found }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      object_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
