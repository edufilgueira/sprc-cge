Rails.application.routes.draw do
	namespace :ceara_app do
		resources :tickets, only: [:new, :create]

		namespace :ticket_area do
    	resources :tickets, only: [:show, :edit, :update] do
	      # member do
	      #   get :history
	      # end

	      #resources :appeals, module: 'tickets', only: [:new, :create]
  	    #resources :reopen_tickets, module: 'tickets', only: [:new, :create]
    	end

	    # resources :answers do
	    #   resources :evaluations, module: 'answers', only: :create
	    # end

	    # resources :comments, only: :create
	    # resources :notifications, only: [:index, :show, :update]
	    # resources :attachments, only: :destroy

	    root 'tickets#show'
	  end

	  #get :sign_in,  to: 'sessions#new'

	  namespace :platform do

    	resources :tickets do
    		# member do
      #   	get :history
      # 	end
      end
    end
	  
	end
end
