Rails.application.routes.draw do
  namespace :operator do

    concern :toggle_disabled do
      member do
        patch 'toggle_disabled'
      end
    end

    namespace :home do
      get :redirect_to_ticket_by_protocol
    end

    resources :global_tickets, only: :index

    resources :notes, only: [:edit, :update]

    resources :sou_evaluation_samples, only: [:create, :index, :show] do
      collection do
        resources :generated_lists, module: :sou_evaluation_samples, only: [:create, :index, :show, :destroy]
      end
    end

    resources :sou_evaluation_sample_details, only: [:index, :show]


    resources :tickets, except: :destroy do
      member do
        get 'history'
      end
      collection do
        resources :importers, module: 'tickets', only: [:create]
      end
      resources :change_answer_certificates, module: 'tickets', only: [:edit, :update]
      resources :change_types, module: 'tickets', only: [:new, :create]
      resources :classifications, module: 'tickets', only: [:new, :create, :edit, :update, :show]
      resources :transfer_organs, module: 'tickets', only: [:new, :create]
      resources :transfer_departments, module: 'tickets', only: [:edit, :update]
      resources :sharings, module: 'tickets', only: [:new, :create, :destroy]
      resources :referrals, module: 'tickets', only: [:new, :create, :destroy]
      resources :extensions_organ, module: 'tickets', only: [:new, :create, :update] do
        member do
          patch 'approve'
          patch 'reject'
        end
      end
      resources :attendance_evaluations, module: 'tickets', only: [:create, :update]
      resources :appeals, module: 'tickets', only: [:new, :create]
      resources :reopen_tickets, module: 'tickets', only: [:new, :create]

      resources :denunciation_classifications, module: 'tickets', only: [:update] do
        collection do
          patch :update
        end
      end

      resources :invalidations, module: 'tickets', only: [:new, :create] do
        member do
          patch 'approve'
          patch 'reject'
        end
      end

      resources :email_replies, module: 'tickets', only: [:edit, :update] do
        collection do
          get :edit
          patch :update
        end
      end

      resources :attendance_responses, module: 'tickets', only: [:new] do
        collection do
          post 'failure'
          post 'success'
        end
      end
      resources :change_sou_types, module: 'tickets', only: [:new, :create]
      resources :change_denunciation_organs, module: 'tickets', only: [:new, :create]
      resources :change_denunciation_types, module: 'tickets', only: [:new, :create]
    end

    resources :comments, only: :create

    resources :answers, only: [:create, :update] do
      member do
        patch 'approve_answer'
        patch 'reject_answer'
      end

      resources :evaluations, module: 'answers', only: :create
    end

    resources :departments

    namespace :reports do
      root 'home#index'

      resources :stats_tickets, only: [:index, :show]
      resources :gross_exports, only: [:index, :new, :create, :show, :destroy]
      resources :ticket_reports, only: [:index, :new, :create, :show, :destroy]
      resources :solvability_reports, only: [:index, :new, :create, :show, :destroy]
      resources :attendance_reports, only: [:index, :new, :create, :show, :destroy]
      resources :evaluation_exports, only: [:index, :new, :create, :show, :destroy]
    end

    resources :attendances, except: [:create, :destroy] do
      resources :occurrences, module: 'attendances', only: :create
    end

    resources :call_center_tickets, only: [:index, :show] do
      member do
        patch 'feedback'
      end

      collection do
        patch :update_checked
      end
    end

    resources :notifications, only: [:index, :show, :update]

    resources :users, except: :destroy, concerns: :toggle_disabled
    resources :departments, except: :destroy, concerns: :toggle_disabled
    resources :answer_templates

    resources :attachments, only: :destroy

    resources :ticket_departments, only: [:edit, :update] do
      member do
        get :poke
        get 'renew_referral'
      end
    end

    resources :subnet_departments, only: [:index, :show]

    resources :topics do
      member do
        get 'delete'
      end
    end

    root 'home#index'
  end
end
