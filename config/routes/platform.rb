Rails.application.routes.draw do
  namespace :platform do

    resources :tickets do
      member do
        get :history
      end
      resources :change_types, module: 'tickets', only: [:new, :create]
      resources :appeals, module: 'tickets', only: [:new, :create]
      resources :reopen_tickets, module: 'tickets', only: [:new, :create]

      resources :publish_tickets, module: 'tickets', only: [:create]
    end

    resources :answers do
      resources :evaluations, module: 'answers', only: :create
    end

    resources :comments, only: :create
    resources :notifications, only: [:index, :show, :update]
    resources :users, only: [:edit, :update]
    resources :attachments, only: :destroy

    root 'home#index'
  end
end
