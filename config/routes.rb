Rails.application.routes.draw do
  get 'notifications_check' => 'notifications#check'
  resources :notifications do
    put :read
  end

  mount Attachinary::Engine => "/attachinary"

  resources :goals
  resources :cycles
  devise_for :thinkers, :controllers => {
    :sessions      => "thinkers/sessions",
    :registrations => "thinkers/registrations",
    :notifications => "notifications"
  }

  resources :workloads
  resources :statuses
  resources :dependences
  resources :thinkers
  resources :licenses
  resources :languages
  resources :projects do
    put :read_all

    member do
      get :team

      put :partecipate
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
      end

      resources :comments, only: [:create, :edit, :update, :destroy], shallow: true do
        resources :likes, shallow: true
        resources :reasons, shallow: true

        member do
          put :approve
        end
      end
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
