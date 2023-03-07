Rails.application.routes.draw do

  namespace :about, path: I18n.t('routes.about.title')  do
    resources :sou, path: I18n.t('routes.about.sou'), only: :index
  end
end
