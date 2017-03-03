Rails.application.routes.draw do
  match '/404', :to => "errors#not_found", :via => :all
  match '/500', :to => "errors#internal_server_error", :via => :all

  resources :notifications do
    put :read
    get :follow
  end
  put 'notifications/:project_id/read_all', to: 'notifications#read_all', as: 'notifications_read_all'
  get 'notifications_check' => 'notifications#check'

  mount Attachinary::Engine => '/attachinary'

  resources :goals
  resources :cycles
  devise_for :thinkers, :controllers => {
    :sessions      => 'thinkers/sessions',
    :registrations => 'thinkers/registrations',
    :notifications => 'notifications'
  }

  resources :password, only: [:edit, :update]
  resources :otp, only: [:show] do
    member do
      put :enable
      put :disable
      put :codes
    end
  end

  resources :workloads
  resources :statuses
  resources :dependences
  resources :thinkers, except: [:index] do
    resources :skills, except: [:show, :update, :edit], controller: 'thinkers/skills'
    resources :notifications, except: [:new], controller: 'thinkers/notifications'
  end
  resources :licenses
  resources :languages
  resources :projects do
    member do
      put :contribute
      put :elect
      put :migrate
      put :suspend
      put :resume
    end

    resources :teams do
      member do
        get 'ban'
        get 'unban'
      end
    end

    resources :statistics, only: [:show], controller: 'projects/statistics'

    resources :releases, shallow: true
    resources :election_polls, shallow: true
    namespace :settings, :module => :projects do
      resources :links, :controller   => :settings_links, :only   => [:index, :create]
      resources :other, :controller   => :settings_other, :only   => [:index, :create]
      resources :release, :controller => :settings_release, :only => [:index, :create]
      resources :skills, :controller => :settings_skills, except: [:show, :update, :edit]
      resources :father, :controller => :settings_father, :only => [:index, :create, :destroy]
      resources :images, :controller => :settings_images, :only => [:index, :create]
      resources :contribution_types, :controller => :settings_contribution_types, :only => [:index, :create]
    end

    resources :sprints, shallow: true do
      resources :survey, only: [:index, :create, :new]
    end

    resources :tasks, shallow: true do
      member do
        put :sprint
        put :release
        put :assign
        put :judge
        put :reopen
        put :give_up
      end

      resources :comments, only: [:create, :edit, :update, :destroy], shallow: true do
        resources :reasons, shallow: true

        member do
          get :approve
          get :like
        end
      end

      resources :operations, shallow: true, except: [:new, :show] do
        member do
          put :done
        end
      end

      resource :ratings, only: [:create], shallow: true
    end

    resources :goals, shallow: true do
      member do
        put :tasks_in_sprint
      end
    end
  end
  resources :start, only: [:index]
  resources :how_does_it_works
  resources :faqs

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root "start#index"

  # namespace :api do
  #   namespace :v1 do
  #     devise_for :thinkers, :controllers => {
  #       :sessions      => 'api/v1/thinkers/sessions',
  #       :registrations => 'api/v1/thinkers/registrations',
  #       # :notifications => 'notifications'
  #     }
  #   end
  # end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
