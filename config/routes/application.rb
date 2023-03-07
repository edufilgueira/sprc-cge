Rails.application.routes.draw do
  resources :extensions, only: [:show, :edit] do
    member do
      patch 'approve'
      patch 'reject'
    end
  end
  resources :open_data, only: [:index]
  resources :tickets, only: [:new, :create]

  resources :search_contents, only: [:index]
  resources :global_searches, only: [:index]

  resources :positionings, only: [:show, :edit, :update]

  root 'home#index'

  get 'privacy_policy', to: 'home#privacy_policy', as: :privacy_policy

  get 'terms_of_use', to: 'home#terms_of_use', as: :terms_of_use

  get 'site_map', to: 'home#site_map#index', as: :site_map

  resources :services_rating, path: I18n.t('routes.application.services_rating.title'), only: [:index, :create]
end
