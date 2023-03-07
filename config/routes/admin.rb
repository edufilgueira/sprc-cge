Rails.application.routes.draw do
  namespace :admin do

    concern :toggle_disabled do
      member do
        patch 'toggle_disabled'
      end
    end

    resources :survey_answer_exports, except: [:edit, :update] do
      member do
        get 'download'
      end
    end
    resources :themes, except: :destroy, concerns: :toggle_disabled
    resources :budget_programs, except: :destroy, concerns: :toggle_disabled
    resources :citizens, only: [:index, :show, :destroy]
    resources :departments, except: :destroy, concerns: :toggle_disabled
    resources :subnets, except: :destroy, concerns: :toggle_disabled
    resources :holidays
    resources :mobile_apps
    resources :mobile_tags, except: :show
    resources :notifications, only: [:index, :show, :update]
    resources :executive_organs, except: :destroy, concerns: :toggle_disabled
    resources :rede_ouvir_organs, except: :destroy, concerns: :toggle_disabled
    resources :ombudsmen
    resources :pages do
      member do
        get :attachments
      end
    end
    resources :search_contents
    resources :service_types, except: :destroy, concerns: :toggle_disabled
    resources :unregistred_citizens, only: [:index, :show, :destroy]
    resources :users, except: :destroy, concerns: :toggle_disabled
    resources :events

    resources :topics do
      member do
        get 'delete'
      end
    end

    resources :integrations, only: :index
    namespace :integrations do
      root 'integrations#index'

      concern :importable do
        member do
          post 'import'
        end
      end

      concern :configurable do
        resources :configurations, only: [:show, :edit, :update], concerns: :importable
      end

      resources :city_undertakings, only: [:index, :show]
      namespace :city_undertakings do
        concerns :configurable
      end

      namespace :contracts do
        resources :contracts, only: [:index, :show]
        resources :convenants, only: [:index, :show]
        concerns :configurable
      end

      namespace :eparcerias do
        concerns :configurable
      end

      resources :expenses, only: [:index]
      namespace :expenses do
        concerns :configurable
        root 'expenses#index'

        # despesas do poder executivo.
        resources :budget_balances, only: [:index]

        # transferencias a municipios
        resources :city_transfers, only: [:index, :show]

        # transferências a entidades sem fins lucrativos
        resources :non_profit_transfers, only: [:index, :show]

        # transferências a entidades com fins lucrativos
        resources :profit_transfers, only: [:index, :show]

        # transferências a instituições multigovernamentais
        resources :multi_gov_transfers, only: [:index, :show]

        # transferencias a consórcios públicos
        resources :consortium_transfers, only: [:index, :show]

        # suprimento de fundos
        resources :fund_supplies, only: [:index, :show]

        # diárias
        resources :dailies, only: [:index, :show]

        resources :npfs, only: [:index, :show]
        resources :neds, only: [:index, :show]
        resources :nlds, only: [:index, :show]
        resources :npds, only: [:index, :show]
      end

      resources :purchases, only: [:index, :show]
      namespace :purchases do
        concerns :configurable
      end

      resources :macroregion_investiments, only: [:index]
      namespace :macroregion_investiments do
        concerns :configurable
      end

      resources :real_states, only: [:index, :show]
      namespace :real_states do
        concerns :configurable
      end

      namespace :revenues do
        concerns :configurable

        resources :accounts, only: [:index]
        resources :transfers, only: [:index]
      end

      resources :server_salaries, only: [:index, :show]
      namespace :servers do
        concerns :configurable
      end

      namespace :supports do
        resources :organs, only: [:index, :show]
        namespace :organ do
          concerns :configurable
        end

        resources :creditors, only: [:index, :show]
        namespace :creditor do
          concerns :configurable
        end

        namespace :domain do
          concerns :configurable
        end

        resources :axes, only: [:index, :show]
        namespace :axis do
          concerns :configurable
        end

        resources :themes, only: [:index, :show]
        namespace :theme do
          concerns :configurable
        end
      end

      namespace :constructions do
        concerns :configurable

        resources :ders, only: [:index, :show]
        resources :daes, only: [:index, :show]
      end

      resources :results, only: [:index]
      namespace :results do
        concerns :configurable
        root 'results#index'

        resources :strategic_indicators, only: [:index, :show]
        resources :thematic_indicators, only: [:index, :show]
      end
    end

    namespace :open_data do
      resources :data_sets, concerns: :importable
    end

    resources :services_rating_exports, except: [:edit, :update] do
      member do
        get 'download'
      end
    end

    root 'users#index'
  end
end
