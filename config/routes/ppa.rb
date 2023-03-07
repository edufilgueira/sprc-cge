Rails.application.routes.draw do
  # SAMPLE: optamos por usar o `devise_for` dentro do namespace `:ppa`.
  # Poderíamos ter feito a configuração do devise fora do namespace, e ficaria:
  # ----
  # ```ruby
  # PPA::Administrator
  # devise_for :ppa_admins, class_name: "PPA::Administrator",
  #                         module: 'ppa/admin/auth',
  #                         path: 'ppa/admin',
  #                         path_names: {
  #                           sign_in: 'login',
  #                           sign_out: 'logout'
  #                         }

  # devise_scope :ppa_admin do
  #   # rota extra para definição de senha na confirmação de conta
  #   # XXX ao adicionar essa rota, o método URL Helper do Devise `confirmation_path(resource_name)`
  #   # para de funcionar. Assim, precisamos usar "na mão" as URLs de confirmação em
  #   # `views/**/confirmations/new.html.haml`!
  #   patch 'ppa/admin/confirmation', to: 'ppa/admin/auth/confirmations#update', as: 'update_ppa_admin_confirmation'
  # end
  # ```

  namespace :ppa do
    # # PPA::Administrator
    # XXX uma vez que estamos no namespace :ppa, podemos usar só :admins, que o Devise entende :ppa_admins.
    devise_for :admins, class_name: "PPA::Administrator",
      module: 'ppa/admin/auth',
      path: 'admin',
      path_names: {
        sign_in:  'login',
        sign_out: 'logout'
    }

    # # XXX aqui não! no `devise_scope`, precisamos escrever o `scope` inteiro => `:ppa_admin`
    devise_scope :ppa_admin do
      # rota extra para definição de senha na confirmação de conta
      # XXX ao adicionar essa rota, o método URL Helper do Devise `confirmation_path(resource_name)`
      # para de funcionar. Assim, precisamos usar um `as: 'update_#{name}_confirmation'` para não
      # "conflitar" com o `confirmation_path` do Devise (nome diferente).
      patch 'admin/confirmation', to: 'admin/auth/confirmations#update', as: 'update_ppa_admin_confirmation'
    end

    resources :workshops, path: I18n.t('routes.ppa.workshops'), only: :index
    resources :past_workshops, path: I18n.t('.routes.ppa.past_workshops'), only: :index

    root 'home#show'

    # PPA admin @ /ppa/admin
    namespace :admin do
      root 'home#show'

      resources :administrators do
        post :toggle_lock, on: :member
      end

      resources :plans do
        resources :workshops, module: :plans
      end

      resources :votings do
      end

      namespace :revision do
        resources :schedules
        resource :export, path: 'export/plan/:id', only: [:show]
      end

      resources :proposal_themes do
      end


    end

    resources :plans, only: [:show], path: I18n.t('routes.ppa.plans') do
      resources :themes, only: [:index], path: "#{I18n.t('routes.ppa.thematic_proposition')}/#{I18n.t('routes.ppa.regions')}/:region_code/#{I18n.t('routes.ppa.themes')}" do
        get I18n.t('routes.ppa.proposals'), action: :proposals, on: :collection
      end
      resources :themes, only: [:index], path: "#{I18n.t('routes.ppa.themes')}" do
        scope path: "#{I18n.t('routes.ppa.thematic_proposition')}/#{I18n.t('routes.ppa.regions')}/:region_code", as: :region do
          resources :proposals, path: I18n.t('routes.ppa.proposals'), module: :themes do
          end
        end
      end

      resources :strategies_votes, only: [:new, :create, :show], path: "#{I18n.t('routes.ppa.regions')}/:region_code/#{I18n.t('routes.ppa.strategies_votes')}/"
      #resources :strategies_votes, only: [:index], path: "#{I18n.t('routes.ppa.strategies_votes')}"
    end


    resources :objectives, only: [], path: I18n.t('routes.ppa.objectives') do
      resources :strategies, only: [:index], module: :objectives, path: I18n.t('routes.ppa.strategies')
    end

    scope path: ':biennium/:region_code', as: :scoped, constraints: { biennium: /[0-9]{4}-[0-9]{4}/, region_code: /[0-9]+/ } do
      resources :axes, only: :index, path: I18n.t('routes.ppa.axes')

      resources :themes, only: [], path: I18n.t('routes.ppa.themes') do
        scope module: :themes do
          resources :proposals, only: :index, path: I18n.t('routes.ppa.proposals')


          resources :regional_strategies, only: %i[index show],
                    path: I18n.t('routes.ppa.regional_strategies') do

            scope module: :regional_strategies do
              resources :likes,    only: :create
              resources :dislikes, only: :create
              resources :comments, only: :create

              resources :regional_initiatives, only: :show,
                        path: I18n.t('routes.ppa.regional_initiatives')
            end
          end
        end
      end
    end # biennium/region

    namespace :revision, path:  I18n.t('routes.ppa.revision.title') do
      scope "#{I18n.t('routes.ppa.plans')}/:plan_id" do
        resources :participant_profiles, path: I18n.t('routes.ppa.revision.participant_profile'), only: [:new, :create]
        
        resources :review_problem_situation_strategies, path: I18n.t('routes.ppa.revision.review_problem_situation_strategies'), except:[:destroy] do
          resources :region_themes, path: I18n.t('routes.ppa.revision.region_themes'), only: [:show, :destroy, :edit, :update]
          get :conclusion, path: I18n.t('routes.ppa.revision.conclusion')
        end


        resources :prioritizations, path: I18n.t('routes.ppa.prioritization.title'), except: [:new] do
          resources :operations, path: I18n.t('routes.ppa.prioritization.operations'), only: [:new, :create]
          get :conclusion, path: I18n.t('routes.ppa.prioritization.conclusion')
        end

        get :themes_list, path: I18n.t('routes.ppa.revision.themes_list'), to: 'review_problem_situation_strategies#themes_list'

        resource :evaluation, path: I18n.t('routes.ppa.revision.evaluation')
      end
    end

    namespace :api do # Não vamos traduzir rotas de API, seguindo padrão do sprc
      namespace :v1 do
        resources :regions, only: [] do
          scope module: :regions do
            resources :themes, only: :index
          end
        end
      end
    end

  end # [end] namespace :ppa

end
