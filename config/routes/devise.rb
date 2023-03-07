Rails.application.routes.draw do

  devise_for :ticket, controllers: { sessions: 'ticket_area/sessions' }

  devise_for :users,
    path: '/',
    controllers: {
      confirmations: 'confirmations',
      sessions: 'sessions',
      passwords: 'passwords',
      registrations: 'registrations',
      omniauth_callbacks: 'omniauth_callbacks'
    }

  
  devise_scope :user do
    # rota extra para definição de senha na confirmação de conta
    # XXX ao adicionar essa rota, o método URL Helper do Devise `confirmation_path(resource_name)`
    # para de funcionar. Assim, precisamos usar um `as: 'update_#{name}_confirmation'` para não
    # "conflitar" com o `confirmation_path` do Devise (nome diferente).
    patch 'confirmation', to: 'confirmations#update', as: 'update_user_confirmation'
    get "/ceara_app/sign_in" => "ceara_app/sessions#new"
    post "/ceara_app/sign_in" => "ceara_app/sessions#create"
  end

  devise_scope :ticket do
    get "/ceara_app/ticket/sign_in", to: "ceara_app/ticket_area/sessions#new", as: :new_ceara_app_ticket_session
    post "/ceara_app/ticket/sign_in", to: "ceara_app/ticket_area/sessions#create", as: :ceara_app_ticket_session
    delete "ceara_app/ticket/sign_out", to: "ceara_app/ticket_area/sessions#destroy" , as: :destroy_ceara_app_ticket_session
  end
end
