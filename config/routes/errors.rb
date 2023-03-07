Rails.application.routes.draw do

  match "/403", to: "errors#forbidden", via: :all, as: :forbidden
  match "/404", to: "errors#not_found", via: :all, as: :not_found
  match "/500", to: "errors#internal_server_error", via: :all, as: :internal_server_error

end
