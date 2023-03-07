Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      devise_scope :user do
        post 'sign_in', to: 'users/sessions#create'
        delete 'sign_out', to: 'users/sessions#destroy'
      end

      namespace :integration do
        namespace :supports do
          resources :server_roles, only: :index
          namespace :revenue_natures do
            resources :revenue_types, only: :index
          end
        end
      end

      namespace :platform do
        resources :tickets, except: [:new, :edit, :destroy]

        resources :topics, only: [] do
          collection do
            get 'topics'
          end
        end
      end

      namespace :operator do

        resources :tickets, except: [:new, :edit, :destroy] do
          collection do
            get :search
          end
        end

        resources :stats_tickets, only: [:status, :create] do
          member do
            get 'status'
          end
        end

        resources :classifications, only: [] do
          collection do
            get 'topics'
            get 'subtopics'
            get 'departments'
            get 'sub_departments'
            get 'service_types'
            get 'budget_programs'
          end
        end

        resources :answer_templates, only: [] do
          collection do
            get :search
          end
        end
      end

      namespace :admin do
        resources :classifications, only: [] do
          collection do
            get 'subtopics'
          end
        end
      end

      namespace :transparency do
        resources :creditors, only: [] do
          collection do
            get :search
          end
        end

        resources :stats_tickets, only: [] do
          member do
            get :status
          end
        end
      end

      resources :cities, only: :index
      resources :departments, only: :index
      resources :organs, only: :index
      resources :sub_departments, only: :index
      resources :subnets, only: :index
      resources :ppa, only: [] do
        collection do
          get :themes_for_axis
          get :strategic_result
          get :theme_description
          get :link_report
          get :problem_situations
          get :regional_strategies
          get :cities_for_region
          get :has_theme_report
        end
      end
    end
  end
end
