Rails.application.routes.draw do

  namespace :transparency, path: I18n.t('routes.transparency.title')  do

    namespace :contracts do
      resources :transfer_bank_orders, only: [:index] do
        member do
          get 'download'
        end
      end
    end

    namespace :contracts do
      resources :financials, only: [:index] do
        member do
          get 'download'
        end
      end
    end

    resources :contacts, path: I18n.t('routes.transparency.contacts'), only: [:index, :show]

    resources :pages, path: I18n.t('routes.transparency.pages'), only: [:index, :show] do
      member do
        get :attachments
      end
    end

    # Pesquisa de satisfação de transparência
    resources :survey_answers, only: [:create]


    # Ferramentas

    resources :city_undertakings, path: I18n.t('routes.transparency.city_undertakings'), only: [:index, :show]
    resources :purchases, path: I18n.t('routes.transparency.purchases'), only: [:index, :show]
    resources :macroregion_investiments, path: I18n.t('routes.transparency.macroregion_investiments'), only: [:index]
    resources :real_states, path: I18n.t('routes.transparency.real_states'), only: [:index, :show]
    resources :server_salaries, path: I18n.t('routes.transparency.server_salaries'), only: [:index, :show]

    resources :mobile_apps, path: I18n.t('routes.transparency.mobile_apps'), only: [:index]
    resources :society_mobile_apps, path: I18n.t('routes.transparency.society_mobile_apps'), only: [:index]

    resources :events, path: I18n.t('routes.transparency.events'), only: [:index, :show]

    namespace :tickets, path: I18n.t('routes.transparency.tickets.title') do
      resources :stats_tickets, path: I18n.t('routes.transparency.tickets.stats_tickets'), only: [:index, :show]
      resources :stats_evaluations, path: I18n.t('routes.transparency.tickets.stats_evaluations'), only: [:index, :create]
    end

    resources :public_tickets, path: I18n.t('routes.transparency.public_tickets.title'), only: [:index, :show] do
      resources :comments, module: 'public_tickets', path: I18n.t('routes.transparency.public_tickets.comments'), except: [:edit, :update]
      resources :subscriptions, module: 'public_tickets', path: I18n.t('routes.transparency.public_tickets.subscriptions.title'), except: [:update, :destroy] do
        collection do
          get I18n.t('routes.transparency.public_tickets.confirmation'), action: 'confirmation', as: 'confirmation'
          get I18n.t('routes.transparency.public_tickets.unsubscribe'), action: 'unsubscribe', as: 'unsubscribe'
        end
      end
      resources :likes, module: 'public_tickets', only: [:create, :destroy]
    end

    namespace :contracts, path: I18n.t('routes.transparency.contracts.contracts') do
      resources :contracts, path: I18n.t('routes.transparency.contracts.contracts'), only: [:index, :show] do
        get "#{I18n.t('routes.transparency.contracts.instrument')}/:instrument", action: 'show_by_instrument', on: :collection
      end
      resources :convenants, path: I18n.t('routes.transparency.contracts.convenants'), only: [:index, :show] do
        get "#{I18n.t('routes.transparency.contracts.instrument')}/:instrument", action: 'show_by_instrument', on: :collection
      end
      resources :management_contracts, path: I18n.t('routes.transparency.contracts.management_contracts'), only: [:index, :show]
    end

    namespace :expenses, path: I18n.t('routes.transparency.expenses.title') do
      resources :npfs, path: I18n.t('routes.transparency.expenses.npfs'), only: [:index, :show]
      resources :neds, path: I18n.t('routes.transparency.expenses.neds'), only: [:index, :show] do
        get "year/:year/organ/:organ/note/:note", action: 'ned_by_note', on:  :collection
      end
      resources :nlds, path: I18n.t('routes.transparency.expenses.nlds'), only: [:index, :show]
      resources :npds, path: I18n.t('routes.transparency.expenses.npds'), only: [:index, :show]

      # despesas do poder executivo
      resources :budget_balances, path: I18n.t('routes.transparency.expenses.budget_balances'), only: [:index]

      # transferências a municipios
      resources :city_transfers, path: I18n.t('routes.transparency.expenses.city_transfers'), only: [:index, :show]

      # transferências a entidades sem fins lucrativos
      resources :non_profit_transfers, path: I18n.t('routes.transparency.expenses.non_profit_transfers'), only: [:index, :show]

      # transferências a entidades com fins lucrativos
      resources :profit_transfers, path: I18n.t('routes.transparency.expenses.profit_transfers'), only: [:index, :show]

      # transferências a instituições multigovernamentais
      resources :multi_gov_transfers, path: I18n.t('routes.transparency.expenses.multi_gov_transfers'), only: [:index, :show]

      # transferencias a consórcios públicos
      resources :consortium_transfers, path: I18n.t('routes.transparency.expenses.consortium_transfers'), only: [:index, :show]

      # suprimento de fundos
      resources :fund_supplies, path: I18n.t('routes.transparency.expenses.fund_supplies'), only: [:index, :show]

      # diárias
      resources :dailies, path: I18n.t('routes.transparency.expenses.dailies'), only: [:index, :show]
    end

    namespace :revenues, path: I18n.t('routes.transparency.revenues.title') do

      # receitas do poder executivo
      resources :accounts, path: I18n.t('routes.transparency.revenues.accounts.title'), only: [:index]

      # receitas de transferências
      resources :transfers, path: I18n.t('routes.transparency.revenues.transfers.title'), only: [:index]

      # receitas lançadas
      resources :registered_revenues, path: I18n.t('routes.transparency.revenues.registered_revenues.title'), only: [:index]

      # hierarquie de natureza de receitas
      resources :node_types, only: [:index]
    end

    resources :revenues_expenses, path: I18n.t('routes.transparency.revenues_expenses.title'), only: :index

    namespace :constructions, path: I18n.t('routes.transparency.constructions.title') do
      resources :ders, path: I18n.t('routes.transparency.constructions.ders'), only: [:index, :show]
      resources :daes, path: I18n.t('routes.transparency.constructions.daes'), only: [:index, :show]
    end

    namespace :results, path: I18n.t('routes.transparency.results.title') do
      resources :strategic_indicators, path: I18n.t('routes.transparency.results.strategic_indicators'), only: [:index, :show]
      resources :thematic_indicators, path: I18n.t('routes.transparency.results.thematic_indicators'), only: [:index, :show]
    end

    namespace :open_data, path: I18n.t('routes.transparency.open_data') do
      resources :data_sets, path: I18n.t('routes.transparency.data_sets'), only: [:index, :show]
    end

    namespace :sic, path: I18n.t('routes.transparency.sic.title') do
      root 'home#index', as: I18n.t('routes.transparency.sic.home.title'), action: :index
    end

    namespace :sou, path: I18n.t('routes.transparency.sou.title') do
      resources :executive_ombudsmen, path: I18n.t('routes.transparency.sou.executive_ombudsmen.title'), only: :index
      resources :sesa_ombudsmen, path: I18n.t('routes.transparency.sou.sesa_ombudsmen.title'), only: :index
      root 'home#index', as: I18n.t('routes.transparency.sou.home.title'), action: :index
    end

    resources :exports, path: I18n.t('routes.transparency.export.title'), only: [] do
      member do
        get 'download'
      end
    end

    namespace :covid19 do
      resources :gas_vouchers, path: I18n.t('routes.transparency.covid19.gas_voucher'), only: [:index]
    end
    
    resources :followers, except: [:destroy]

    root 'home#index'
  end
end
